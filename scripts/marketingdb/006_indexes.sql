-- Indexes for the queries of the data analytics project: sessions join leads
-- by visitor, the last paid click is looked up by visit time, dashboards
-- filter by date. marketingdb_v2 and marketingdb_codicala are copies of this
-- database, so they get the same indexes. The ad tables hold about ten
-- thousand rows and need none.
CREATE INDEX sessions_visitor_id_visit_date_idx ON sessions (visitor_id, visit_date);
CREATE INDEX sessions_visit_date_idx ON sessions (visit_date);
CREATE INDEX leads_visitor_id_idx ON leads (visitor_id);
ANALYZE sessions;
ANALYZE leads;
