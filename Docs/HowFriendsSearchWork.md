# Friends Search

MySpc allows users to search for other users by **username**.

The search system is split into two stages:

1. **Candidate Search** — Quickly find usernames that are potentially relevant to the query.
2. **Result Ranking** — Accurately rank those candidates by how closely they match the query.

MySpc uses:

- PostgreSQL **`pg_trgm`** for candidate search
- **Levenshtein distance** for result ranking
- A **GIN trigram index** to make candidate retrieval efficient

The overall flow is:

```text
All users
   │
   ▼
pg_trgm + GIN Index
   │
   ▼
Potentially relevant candidates
   │
   ▼
Levenshtein distance
   │
   ▼
Rank candidates
   │
   ▼
Return top results
```

---

## 1. Candidate Search

The first stage finds usernames that are potentially related to the user's search query.

For example, if a user searches:

```text
alex
```

we may want to find usernames such as:

```text
alex
alexander
alexis
myalex
```

The system should also handle small spelling mistakes.

For example:

```text
Query:    alxe
Username: alex
```

Even though `alxe` is not an exact match for `alex`, it should still be possible to identify `alex` as a relevant candidate.

For this stage, MySpc uses PostgreSQL's **`pg_trgm`** extension.

---

## 2. What Is `pg_trgm`?

`pg_trgm` is a PostgreSQL extension that provides functions and operators for measuring **text similarity using trigrams**.

A **trigram** is a sequence of three consecutive characters.

For example:

```text
alex
```

contains overlapping trigrams such as:

```text
ale
lex
```

For a longer username:

```text
alexander
```

the trigrams include:

```text
ale
lex
exa
xan
and
nde
der
```

Notice that the trigrams **overlap**.

They are not simply split into independent groups of three characters.

```text
alexander

ale
  lex
    exa
      xan
        and
          nde
            der
```

This overlapping representation allows PostgreSQL to compare strings based on the character sequences they share.

### Why Trigrams Are Useful

Consider:

```text
alex
alexander
```

Both contain:

```text
ale
lex
```

Because the strings share trigrams, `pg_trgm` can determine that they are similar.

This makes trigram similarity useful for username search, especially when the query is incomplete or contains a small typo.

---

# 3. Fuzzy Matching With `pg_trgm`

`pg_trgm` can also help with approximate matches.

For example:

```text
Query:    alxe
Username: alex
```

These strings are not identical:

```text
alxe != alex
```

and `alxe` is not a substring of `alex`.

However, their trigram-based representations still provide information about their similarity.

PostgreSQL provides the `similarity()` function:

```sql
SELECT similarity(username, 'alxe')
FROM "Profile";
```

This returns a similarity score between the two strings.

A higher score indicates that the strings are more similar.

The important idea is that `pg_trgm` does not need the query to be an exact substring of the username.

It can use shared character patterns to identify **approximately matching usernames**.

---

# 4. Enabling `pg_trgm`

`pg_trgm` is a PostgreSQL extension, so it must be enabled in the database.

```sql
CREATE EXTENSION IF NOT EXISTS pg_trgm;
```

Once enabled, PostgreSQL provides trigram-based functions and operators that can be used for similarity searches.

For example:

```sql
SELECT
    username,
    similarity(username, 'alxe') AS similarity
FROM "Profile";
```

This allows us to inspect how similar each username is to the search query.

---

# 5. GIN Trigram Index

Running similarity calculations across every username can become expensive as the number of users grows.

To make trigram searches more efficient, MySpc can create a **GIN (Generalized Inverted Index)** using the `gin_trgm_ops` operator class.

```sql
CREATE INDEX profile_username_trgm_idx
ON "Profile"
USING GIN (username gin_trgm_ops);
```

The index stores information about the trigrams contained in usernames.

This allows PostgreSQL to narrow down the search space more efficiently instead of blindly examining every username.

### Why the Index Matters

Suppose MySpc has:

```text
1,000,000 users
```

Without an appropriate candidate-search strategy, a search could require PostgreSQL or the application to inspect a very large number of usernames.

With a trigram index, PostgreSQL can first identify usernames that share relevant trigram patterns.

Conceptually:

```text
1,000,000 users
       │
       ▼
GIN trigram index
       │
       ▼
Potentially relevant usernames
       │
       ▼
~100–200 candidates
```

The exact number of candidates depends on the query, similarity threshold, data distribution, and search implementation.

The important point is that the ranking stage should operate on a **small candidate set**, not the entire user table.

---

# 6. Why Candidate Search Is Necessary

MySpc uses two separate stages because candidate retrieval and ranking have different responsibilities.

Imagine MySpc has:

```text
1,000,000 users
```

If we calculate Levenshtein distance for every username on every search, we could end up performing:

```text
1,000,000 Levenshtein calculations
```

for a single query.

That is unnecessary.

Instead, MySpc first uses `pg_trgm` to narrow the search space:

```text
1,000,000 users
       │
       ▼
pg_trgm + GIN index
       │
       ▼
Potential candidates
       │
       ▼
~100–200 candidates
       │
       ▼
Levenshtein ranking
```

Now the expensive ranking step only needs to process the candidates that are already considered relevant.

---

# 7. Result Ranking

Candidate search is only the first stage.

There may still be several usernames that are reasonably similar to the query.

For example, searching:

```text
alxe
```

might produce candidates such as:

```text
alxe
alex
alexis
alexander
```

We now need to determine which candidates are the closest match.

For this, MySpc uses **Levenshtein distance**.

---

# 8. What Is Levenshtein Distance?

Levenshtein distance measures the minimum number of **single-character edits** required to transform one string into another.

The three supported operations are:

1. **Insert** a character
2. **Delete** a character
3. **Replace** a character

For example:

```text
cat
car
```

Only one character needs to be replaced:

```text
cat
  ↓
car
```

Therefore:

```text
Levenshtein distance = 1
```

If the strings are identical:

```text
alex
alex
```

then:

```text
Levenshtein distance = 0
```

A smaller distance means the strings require fewer edits to become equal.

---

# 9. Why Use Levenshtein After `pg_trgm`?

`pg_trgm` and Levenshtein solve different problems.

### `pg_trgm`

Its job is:

> **Find usernames that are potentially relevant.**

It is well suited for quickly narrowing down a large dataset.

### Levenshtein

Its job is:

> **Measure how many character edits separate each candidate from the query.**

It is useful for determining the exact closeness of the candidates.

Therefore, the two techniques complement each other.

Instead of:

```text
1,000,000 users
       │
       ▼
Levenshtein
       │
       ▼
1,000,000 distance calculations
```

MySpc uses:

```text
1,000,000 users
       │
       ▼
pg_trgm + GIN index
       │
       ▼
Candidate pool
       │
       ▼
Levenshtein
       │
       ▼
Rank candidates
       │
       ▼
Top results
```

This separates **fast candidate retrieval** from **more precise ranking**.

---

# 10. Complete Example

Suppose the user searches:

```text
alxe
```

The database contains:

```text
alex
alexander
alexis
alxe
bob
charlie
```

## Step 1 — Candidate Search

`pg_trgm` is used to identify usernames that are potentially similar to the query.

Possible candidates:

```text
alex
alexander
alexis
alxe
```

Unrelated usernames such as:

```text
bob
charlie
```

are unlikely to be included in the candidate pool.

The exact candidates depend on the configured similarity threshold and query.

---

## Step 2 — Ranking

The candidate usernames are then compared with:

```text
alxe
```

Conceptually:

| Username | Levenshtein Distance |
|---|---:|
| `alxe` | 0 |
| `alex` | 2 |
| `alexis` | higher |
| `alexander` | higher |

The candidates can then be sorted by their distance.

The smaller the distance, the better the match.

> **Note:** The exact distances should be calculated by the implementation rather than assumed from visual similarity.

---

# 11. Final Search Pipeline

The complete MySpc username search pipeline is:

```text
User enters query
        │
        ▼
      "alxe"
        │
        ▼
┌─────────────────────┐
│ Candidate Search    │
│                     │
│ pg_trgm + GIN index │
└─────────────────────┘
        │
        ▼
Potential candidates
        │
        ▼
┌─────────────────────┐
│ Result Ranking      │
│                     │
│ Levenshtein distance│
└─────────────────────┘
        │
        ▼
Sort by match quality
        │
        ▼
Return top usernames
```

---

# 12. Responsibilities of Each Component

| Component | Responsibility |
|---|---|
| `pg_trgm` | Finds potentially similar usernames |
| GIN index | Makes trigram-based candidate retrieval efficient |
| Candidate pool | Limits the number of usernames that need detailed comparison |
| Levenshtein distance | Measures edit distance between the query and each candidate |
| Ranking | Orders candidates from best to worst match |

The key design principle is:

> **Use `pg_trgm` to reduce the search space, then use Levenshtein to rank the reduced candidate set.**

This prevents expensive fuzzy ranking from being performed against the entire user database.
