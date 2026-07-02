ALTER TABLE accounts ADD COLUMN id_token TEXT;
ALTER TABLE accounts ADD COLUMN access_token_expires_at INTEGER;
ALTER TABLE accounts ADD COLUMN refresh_token_expires_at INTEGER;
ALTER TABLE accounts ADD COLUMN scope TEXT;

CREATE TABLE IF NOT EXISTS verifications (
  id TEXT PRIMARY KEY,
  identifier TEXT NOT NULL,
  value TEXT NOT NULL,
  expires_at INTEGER NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
