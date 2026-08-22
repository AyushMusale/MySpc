CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
CREATE INDEX IF NOT EXISTS profile_username_trgm_idx
  ON "Profile"
  USING gin (username gin_trgm_ops);