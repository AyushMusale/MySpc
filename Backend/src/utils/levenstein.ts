/**
 * Computes the Levenshtein edit distance between two strings —
 * the minimum number of single-character insertions, deletions,
 * or substitutions needed to turn `a` into `b`.
 *
 * Used to catch near-miss username searches (typos, transpositions)
 * that a plain substring match would miss.
 */
export function levenshteinDistance(a: string, b: string): number {
  const m = a.length;
  const n = b.length;

  if (m === 0) return n;
  if (n === 0) return m;

  // Single-row rolling array — O(min(m,n)) space instead of O(m*n)
  let prevRow = Array.from({ length: n + 1 }, (_, j) => j);

  for (let i = 1; i <= m; i++) {
    const currRow = [i];

    for (let j = 1; j <= n; j++) {
      const cost = a[i - 1] === b[j - 1] ? 0 : 1;
      currRow[j] = Math.min(
        currRow[j - 1]! + 1, // insertion
        prevRow[j]! + 1, // deletion
        prevRow[j - 1]! + cost, // substitution
      );
    }

    prevRow = currRow;
  }

  return prevRow[n]!;
}

/**
 * Returns true if `candidate` is "close enough" to `query` to be
 * considered a typo-tolerant match. Threshold scales with query
 * length so short usernames aren't over-matched.
 */
export function isFuzzyMatch(query: string, candidate: string): boolean {
  const maxDistance = query.length <= 4 ? 1 : query.length <= 8 ? 2 : 3;
  return levenshteinDistance(query, candidate) <= maxDistance;
}