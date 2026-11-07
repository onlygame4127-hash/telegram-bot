PRAGMA foreign_keys = ON;
ALTER TABLE edit_requests ADD COLUMN proposed_photo_unique_id TEXT;
ALTER TABLE edit_requests ADD COLUMN proposed_caption TEXT;
CREATE TABLE IF NOT EXISTS broadcast_jobs (id INTEGER PRIMARY KEY AUTOINCREMENT, created_by TEXT NOT NULL, message_text TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'queued' CHECK(status IN('queued','running','completed','failed','cancelled')), cursor_user_id TEXT, sent_count INTEGER NOT NULL DEFAULT 0, failed_count INTEGER NOT NULL DEFAULT 0, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS broadcast_recipients (id INTEGER PRIMARY KEY AUTOINCREMENT, job_id INTEGER NOT NULL REFERENCES broadcast_jobs(id) ON DELETE CASCADE, telegram_id TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'pending', error TEXT, UNIQUE(job_id,telegram_id));
CREATE TABLE IF NOT EXISTS rate_limits (bucket TEXT NOT NULL, actor TEXT NOT NULL, window_start INTEGER NOT NULL, hits INTEGER NOT NULL DEFAULT 0, PRIMARY KEY(bucket,actor,window_start));
CREATE TABLE IF NOT EXISTS listing_history (id INTEGER PRIMARY KEY AUTOINCREMENT, listing_id INTEGER NOT NULL REFERENCES listings(id), actor_telegram_id TEXT NOT NULL, action TEXT NOT NULL, snapshot TEXT, note TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE INDEX IF NOT EXISTS idx_edit_requests_status ON edit_requests(status,created_at);
CREATE INDEX IF NOT EXISTS idx_buy_requests_listing ON buy_requests(listing_id,status);
CREATE INDEX IF NOT EXISTS idx_history_listing ON listing_history(listing_id,created_at);

INSERT OR IGNORE INTO settings(key,value) VALUES ('max_clan_members','50'),('mature_description','معنای این گزینه باید توسط مالک پروژه تعیین شود.');
