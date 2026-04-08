#!/usr/bin/env bash
set -euo pipefail

args=("$@")

handle_term() {
  if [[ -n "${postgres_pid:-}" ]] && kill -0 "$postgres_pid" 2>/dev/null; then
    kill -TERM "$postgres_pid" 2>/dev/null || true
  fi
}
trap handle_term TERM INT

# Run the image entrypoint (initdb + start postgres) in background.
/usr/local/bin/docker-entrypoint.sh "${args[@]}" &
postgres_pid="$!"

# Wait until postgres accepts connections, then ensure extensions exist.
for _ in $(seq 1 60); do
  if pg_isready -h localhost -p 5432 -U "${POSTGRES_USER:-postgres}" -d "${POSTGRES_DB:-postgres}" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

psql -v ON_ERROR_STOP=1 \
  --username "${POSTGRES_USER:-postgres}" \
  --dbname "${POSTGRES_DB:-postgres}" <<'SQL' || true
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS anon;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
SQL

wait "$postgres_pid"

