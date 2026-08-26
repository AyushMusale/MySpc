CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX IF NOT EXISTS "profile_username_trgm_idx"
ON "Profile"
USING GIN ("username" gin_trgm_ops);