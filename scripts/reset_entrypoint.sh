#!/bin/sh
# Start every container from a clean state: students get read-only access and
# nobody keeps data between starts. An empty PGDATA makes the stock entrypoint
# run the init scripts again, so a restart reloads the course databases too.
set -eu

: "${PGDATA:?PGDATA is not set}"

if [ -d "$PGDATA" ]; then
    find "$PGDATA" -mindepth 1 -delete
fi

# Directory of the student_tmp tablespace. In production it is a size-limited
# tmpfs, so temporary tables and spill files of students cannot fill the disk.
STUDENT_TMP=/var/lib/postgresql/tmp
mkdir -p "$STUDENT_TMP"
find "$STUDENT_TMP" -mindepth 1 -delete
chown postgres:postgres "$STUDENT_TMP"
chmod 700 "$STUDENT_TMP"

exec docker-entrypoint.sh "$@"
