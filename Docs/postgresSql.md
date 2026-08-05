# Why PostgreSQL?

MySpc uses **PostgreSQL**, a Relational Database Management System (RDBMS), because the application's data is highly relational. Most entities are connected through well-defined relationships, making an RDBMS a better fit than a NoSQL database.

---

## Strong Relationships

The core entities in MySpc are closely connected.

```
Users
   │
   ▼
Profile
   │
   ├──────────┐
   ▼          ▼
Friends   Space Members
              │
              ▼
            Space
              │
              ▼
           Messages
```

PostgreSQL allows these relationships to be enforced using **foreign keys**, ensuring that related records always remain consistent.

---

## Data Integrity

Relational databases enforce constraints that help prevent invalid data.

Examples include:

- Every Profile must belong to a valid User.
- Every Message must belong to an existing Space.
- Every Space Member must belong to both a valid Space and Profile.
- Duplicate usernames and email addresses are prevented using unique constraints.

These guarantees help maintain data consistency throughout the application.

---

## ACID Transactions

Many operations in MySpc involve updating multiple tables.

For example, when creating a new private conversation:

1. Create a new Space.
2. Add the first user to Space Members.
3. Add the second user to Space Members.

These operations should either **all succeed or all fail**.

PostgreSQL supports ACID transactions, ensuring that the database never enters a partially updated state.

---

## Efficient Joins

MySpc frequently needs data from multiple tables.

Examples include:

- Fetch all conversations for a user.
- Retrieve members of a group.
- Load messages along with sender information.
- Display a user's friends list.

PostgreSQL is highly optimized for these types of relational queries.

---

## Scalability

PostgreSQL can comfortably support applications ranging from small personal projects to large-scale production systems.

As MySpc grows, PostgreSQL provides advanced features such as:

- Indexing
- Full-text search
- JSON support
- Replication
- Partitioning
- Materialized views

These features allow the database to scale without changing the underlying architecture.

---

## Why Not NoSQL?

A document database such as MongoDB excels when data is flexible and has few relationships.

However, MySpc contains many interconnected entities:

- Users
- Profiles
- Friendships
- Spaces
- Space Members
- Messages

Maintaining these relationships manually in a NoSQL database would introduce unnecessary complexity and increase the risk of inconsistent data.

---

## Conclusion

PostgreSQL was chosen because it provides:

- Strong relational modeling
- Data integrity through constraints
- ACID-compliant transactions
- Efficient joins for relational queries
- Excellent performance for structured data
- A scalable foundation for future features

These characteristics make PostgreSQL an ideal choice for MySpc's communication platform.