DROP TABLE IF EXISTS leads;
CREATE TABLE leads(
   visitor_id      VARCHAR(255)
  ,lead_id         VARCHAR(255)
  ,amount          INTEGER
  ,created_at      TIMESTAMP
  ,closing_reason  VARCHAR(255)
  ,learning_format VARCHAR(255)
  ,status_id       BIGINT
);


DROP TABLE IF EXISTS new_sessions;
CREATE TABLE sessions(
   visitor_id   VARCHAR(255)
  ,visit_date   TIMESTAMP
  ,landing_page VARCHAR(255)
  ,source       VARCHAR(255)
  ,medium       VARCHAR(255)
  ,campaign     VARCHAR(255)
  ,content      VARCHAR(255)
);


DROP TABLE IF EXISTS vk_ads;
CREATE TABLE vk_ads(
   ad_id         VARCHAR(255)
  ,ad_name       VARCHAR(255)
  ,campaign_id   VARCHAR(255)
  ,campaign_name VARCHAR(255)
  ,campaign_date TIMESTAMP
  ,daily_spent   INTEGER
  ,utm_source    VARCHAR(255)
  ,utm_medium    VARCHAR(255)
  ,utm_campaign  VARCHAR(255)
  ,utm_content   VARCHAR(255)
);


DROP TABLE IF EXISTS ya_ads;
CREATE TABLE ya_ads(
   ad_id         VARCHAR(255)
  ,campaign_id   VARCHAR(255)
  ,campaign_name VARCHAR(255)
  ,utm_source    VARCHAR(255)
  ,utm_medium    VARCHAR(255)
  ,utm_campaign  VARCHAR(255)
  ,utm_content   VARCHAR(255)
  ,campaign_date TIMESTAMP
  ,daily_spent   INTEGER
);
