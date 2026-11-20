DO
$$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'student') THEN
        CREATE ROLE student
            WITH LOGIN PASSWORD 'student'
            NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
    END IF;
END;
$$;

-- Limits keep an experiment from filling the disk of the shared host.
-- temp_file_limit covers sort and hash spill files only. Temporary tables are
-- bounded by the size of the student_tmp tablespace (see student_tmp.sql).
-- ALTER ROLE is cluster-wide, repeating it for every database is harmless.
ALTER ROLE student SET statement_timeout = '60s';
ALTER ROLE student SET idle_in_transaction_session_timeout = '5min';
ALTER ROLE student SET temp_file_limit = '256MB';

REVOKE ALL ON SCHEMA public FROM public;

GRANT USAGE ON SCHEMA public TO student;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO student;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO student;

DO
$$
DECLARE
    dbname text := current_database();
BEGIN
    EXECUTE format('GRANT CONNECT ON DATABASE %I TO student', dbname);
    -- Analytics students may experiment in temporary tables: they live for one
    -- session and the container starts from a clean state anyway.
    EXECUTE format('GRANT TEMP ON DATABASE %I TO student', dbname);
END;
$$;
