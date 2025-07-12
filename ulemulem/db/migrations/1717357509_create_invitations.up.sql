CREATE TABLE IF NOT EXISTS invitations (
  id TEXT PRIMARY KEY,
  recipient_name TEXT NOT NULL,
  code TEXT NOT NULL,
  status TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  opened_at TIMESTAMP,
  cancelled_at TIMESTAMP
);
