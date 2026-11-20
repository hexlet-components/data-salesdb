-- Temporary tables and spill files of students go to a separate tablespace.
-- reset_entrypoint.sh prepares its directory, production mounts a tmpfs of
-- fixed size there, so an experiment fails with "No space left on device"
-- instead of filling the disk of the host.
CREATE ROLE student
WITH LOGIN PASSWORD 'student'
NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;

CREATE TABLESPACE student_tmp LOCATION '/var/lib/postgresql/tmp';
GRANT CREATE ON TABLESPACE student_tmp TO student;
ALTER ROLE student SET temp_tablespaces = 'student_tmp';
