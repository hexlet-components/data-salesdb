#!/bin/sh
# Smoke test of a built image: start it, wait for the init scripts and compare
# row counts of every table with test/expected_counts.tsv. Counts are read as
# the student role over TCP, so missing grants fail the test too.
#
# Usage: test/smoke.sh IMAGE
set -eu

image=${1:?usage: test/smoke.sh IMAGE}
expected="$(dirname "$0")/expected_counts.tsv"
name="data-salesdb-smoke-$$"
init_timeout=${SMOKE_TIMEOUT:-600}
tab=$(printf '\t')

trap 'docker rm -f "$name" > /dev/null 2>&1 || true' EXIT
trap 'exit 130' INT TERM

# Memory, tmpfs and shm match production, see ansible/release.yml in
# own-heroku. Init that outgrows the limit gets OOM-killed and fails the test.
docker run -d --name "$name" \
    -e POSTGRES_PASSWORD=smoke \
    --memory 1536m \
    --memory-swap 1536m \
    --shm-size 256m \
    --tmpfs /var/lib/postgresql/tmp:size=512m \
    "$image" > /dev/null

# -X skips psqlrc, -A -t -q print bare values for comparison.
student_psql() {
    docker exec -e PGPASSWORD=student "$name" \
        psql -h 127.0.0.1 -U student -XAtq "$@"
}

# During init the server listens on the socket only, TCP answers after it.
deadline=$(($(date +%s) + init_timeout))
until student_psql -d salesdb -c 'select 1' > /dev/null 2>&1; do
    if [ "$(docker inspect -f '{{.State.Running}}' "$name")" != true ]; then
        docker logs "$name" 2>&1 | tail -n 40
        echo "FAIL: container stopped during init" >&2
        exit 1
    fi
    if [ "$(date +%s)" -ge "$deadline" ]; then
        echo "FAIL: init did not finish in ${init_timeout}s" >&2
        exit 1
    fi
    sleep 2
done

status=0

errors=$(docker logs "$name" 2>&1 | grep 'ERROR:' || true)
if [ -n "$errors" ]; then
    echo "$errors"
    echo "FAIL: init log has errors" >&2
    status=1
fi

while IFS="$tab" read -r db table rows; do
    case "$db" in '#'* | '') continue ;; esac
    schema=${table%%.*}
    relation=${table#*.}
    actual=$(student_psql -d "$db" -c "select count(*) from \"$schema\".\"$relation\"" 2>&1) || true
    if [ "$actual" != "$rows" ]; then
        echo "FAIL: $db $table: expected $rows, got $actual" >&2
        status=1
    fi
done < "$expected"

if [ "$status" -eq 0 ]; then
    echo "OK: $(grep -vc '^#' "$expected") tables match"
fi
exit "$status"
