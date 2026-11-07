PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS users (
 id INTEGER PRIMARY KEY AUTOINCREMENT, telegram_id TEXT NOT NULL UNIQUE, username TEXT,
 first_name TEXT, last_name TEXT, is_blocked INTEGER NOT NULL DEFAULT 0 CHECK(is_blocked IN(0,1)),
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS admins (
 id INTEGER PRIMARY KEY AUTOINCREMENT, telegram_id TEXT NOT NULL UNIQUE, role TEXT NOT NULL CHECK(role IN('owner','admin','moderator')),
 is_active INTEGER NOT NULL DEFAULT 1 CHECK(is_active IN(0,1)), created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS user_sessions (
 id INTEGER PRIMARY KEY AUTOINCREMENT, telegram_id TEXT NOT NULL UNIQUE, form_type TEXT NOT NULL,
 current_step TEXT NOT NULL, draft_data TEXT NOT NULL DEFAULT '{}', session_status TEXT NOT NULL DEFAULT 'active' CHECK(session_status IN('active','closed')),
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS listings (
 id INTEGER PRIMARY KEY AUTOINCREMENT, ad_code TEXT NOT NULL UNIQUE, seller_telegram_id TEXT NOT NULL,
 listing_type TEXT NOT NULL CHECK(listing_type IN('account','clan')), status TEXT NOT NULL,
 price_toman INTEGER NOT NULL CHECK(price_toman > 0), description TEXT,
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 submitted_at TEXT, approved_at TEXT, published_at TEXT, FOREIGN KEY(seller_telegram_id) REFERENCES users(telegram_id)
);
CREATE INDEX IF NOT EXISTS idx_listings_seller ON listings(seller_telegram_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_listings_status ON listings(status, created_at);
CREATE TABLE IF NOT EXISTS account_details (
 listing_id INTEGER PRIMARY KEY REFERENCES listings(id) ON DELETE CASCADE, account_name TEXT NOT NULL,
 account_level INTEGER NOT NULL CHECK(account_level > 0), gems_count INTEGER NOT NULL CHECK(gems_count >= 0),
 barbarian_king_level INTEGER NOT NULL, archer_queen_level INTEGER NOT NULL, grand_warden_level INTEGER NOT NULL,
 royal_champion_level INTEGER NOT NULL, minion_prince_level INTEGER NOT NULL, dragon_duke_level INTEGER NOT NULL,
 email_change_status TEXT NOT NULL CHECK(email_change_status IN('yes','no')), mature_status TEXT NOT NULL CHECK(mature_status IN('yes','no')),
 account_tag TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS clan_details (
 listing_id INTEGER PRIMARY KEY REFERENCES listings(id) ON DELETE CASCADE, clan_name TEXT NOT NULL,
 clan_level INTEGER NOT NULL CHECK(clan_level > 0), capital_level INTEGER NOT NULL CHECK(capital_level >= 0),
 clan_league TEXT NOT NULL, member_count INTEGER NOT NULL CHECK(member_count > 0), clan_tag TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS listing_photos (
 id INTEGER PRIMARY KEY AUTOINCREMENT, listing_id INTEGER NOT NULL UNIQUE REFERENCES listings(id) ON DELETE CASCADE,
 photo_type TEXT NOT NULL DEFAULT 'main', telegram_file_id TEXT NOT NULL, telegram_file_unique_id TEXT NOT NULL,
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS channel_posts (
 id INTEGER PRIMARY KEY AUTOINCREMENT, listing_id INTEGER NOT NULL UNIQUE REFERENCES listings(id) ON DELETE CASCADE,
 channel_chat_id TEXT NOT NULL, message_id INTEGER NOT NULL, message_url TEXT, published_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 last_edit_at TEXT, sync_status TEXT NOT NULL DEFAULT 'synced', last_error TEXT
);
CREATE TABLE IF NOT EXISTS edit_requests (
 id INTEGER PRIMARY KEY AUTOINCREMENT, listing_id INTEGER NOT NULL REFERENCES listings(id), user_telegram_id TEXT NOT NULL,
 proposed_data TEXT NOT NULL, proposed_photo_file_id TEXT, status TEXT NOT NULL DEFAULT 'pending', admin_note TEXT,
 reviewed_by TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, reviewed_at TEXT
);
CREATE TABLE IF NOT EXISTS buy_requests (
 id INTEGER PRIMARY KEY AUTOINCREMENT, request_code TEXT NOT NULL UNIQUE, listing_id INTEGER NOT NULL REFERENCES listings(id),
 buyer_telegram_id TEXT NOT NULL, seller_telegram_id TEXT NOT NULL, status TEXT NOT NULL DEFAULT 'open',
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS admin_logs (
 id INTEGER PRIMARY KEY AUTOINCREMENT, admin_telegram_id TEXT NOT NULL, listing_id INTEGER,
 action TEXT NOT NULL, old_status TEXT, new_status TEXT, description TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS notifications (
 id INTEGER PRIMARY KEY AUTOINCREMENT, user_telegram_id TEXT NOT NULL, listing_id INTEGER,
 notification_type TEXT NOT NULL, payload TEXT NOT NULL DEFAULT '{}', status TEXT NOT NULL DEFAULT 'pending',
 attempts INTEGER NOT NULL DEFAULT 0, last_error TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_notifications_pending ON notifications(status, created_at);
CREATE TABLE IF NOT EXISTS settings (key TEXT PRIMARY KEY, value TEXT NOT NULL, updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP);
CREATE TABLE IF NOT EXISTS webhook_updates (update_id INTEGER PRIMARY KEY, processed_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, status TEXT NOT NULL);
INSERT OR IGNORE INTO admins(telegram_id, role, is_active) VALUES('8952746307','owner',1);
INSERT OR IGNORE INTO settings(key,value) VALUES
 ('mature_label','وضعیت Mature'),('mature_description','معنای این گزینه باید توسط مالک پروژه تعیین شود.'),
 ('account_levels','{}'),('clan_leagues','Bronze I|Bronze II|Silver I|Silver II|Gold I|Gold II|Crystal I|Crystal II|Master I|Master II|Champion I|Champion II|Titan I|Titan II|Legend League');
