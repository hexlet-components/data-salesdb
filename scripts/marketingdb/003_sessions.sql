-- 233 thousand rows load with COPY: a single multi-row INSERT of this size
-- took about 1.7 GB of server memory to parse. The CSV keeps the physical row
-- order of the table loaded by that INSERT, so queries without ORDER BY return
-- rows in the same order as before.
COPY sessions (visitor_id, visit_date, landing_page, source, medium, campaign, content)
FROM '/scripts/marketingdb/data/sessions.csv' WITH (FORMAT csv, HEADER);
