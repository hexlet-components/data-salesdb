-- ads.csv starts with a header and orders utm_medium before utm_campaign,
-- so the column list maps CSV fields to table columns by name.
COPY ads (datetime, utm_source, utm_medium, utm_campaign, cost)
FROM '/scripts/chartsdb/data/ads.csv' DELIMITER ',' CSV HEADER;
