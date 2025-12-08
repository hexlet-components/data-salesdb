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
    EXECUTE format('GRANT TEMP ON DATABASE %I TO student', dbname);
END;
$$;
