#!/bin/sh
# Start every container from a clean state: students get read-only access and
# nobody keeps data between starts. An empty PGDATA makes the stock entrypoint
# run the init scripts again, so a restart reloads the course databases too.
set -eu

: "${PGDATA:?PGDATA is not set}"

if [ -d "$PGDATA" ]; then
    find "$PGDATA" -mindepth 1 -delete
fi

exec docker-entrypoint.sh "$@"
