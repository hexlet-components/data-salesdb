DROP TABLE IF EXISTS user_leads_payments;
CREATE TABLE user_leads_payments (
	visitor_id VARCHAR(255) PRIMARY KEY,
	amount NUMERIC,
	created_at VARCHAR(255),
	closing_reason VARCHAR(255),
	learning_format VARCHAR(255),
	status_id BIGINT
);

DROP TABLE IF EXISTS user_sessions;
CREATE TABLE user_sessions (
	visitor_id VARCHAR(255),
	datetime VARCHAR(255),
	landing_page VARCHAR(255),
	source VARCHAR(255),
	medium VARCHAR(255),
	campaign VARCHAR(255),
	content VARCHAR(255),
	term VARCHAR(255)
);

DROP TABLE IF EXISTS vk_ads;
CREATE TABLE vk_ads (
	id VARCHAR(255),
	ad_name VARCHAR(255),
	campaign_id BIGINT,
	campaign_name VARCHAR(255),
	date VARCHAR(255),
	spent NUMERIC,
	utm_source VARCHAR(255),
	utm_medium VARCHAR(255),
	utm_campaign VARCHAR(255),
	utm_content VARCHAR(255),
	utm_term VARCHAR(255)
);

DROP TABLE IF EXISTS yandex_ads;
CREATE TABLE yandex_ads (
	id VARCHAR(255),
	campaign_id BIGINT,
	campaign_name VARCHAR(255),
	utm_source VARCHAR(255),
	utm_medium VARCHAR(255),
	utm_campaign VARCHAR(255),
	utm_content VARCHAR(255),
	utm_term VARCHAR(255),
	date VARCHAR(255),
	cost NUMERIC
);
