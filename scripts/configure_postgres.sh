#!/bin/sh
set -e

: "${PGDATA:?PGDATA is not set}"

cp /etc/postgresql/postgresql.conf "$PGDATA/postgresql.conf"
cp /etc/postgresql/pg_hba.conf "$PGDATA/pg_hba.conf"
chmod 600 "$PGDATA/postgresql.conf" "$PGDATA/pg_hba.conf"
