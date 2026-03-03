#!/bin/sh
set -e

# Wait for Postgres when DATABASE_URL points at the db service (e.g. Docker Compose)
if echo "$DATABASE_URL" | grep -q '@db:'; then
  until node -e "
    const { Client } = require('pg');
    const c = new Client({ connectionString: process.env.DATABASE_URL });
    c.connect().then(() => c.end()).then(() => process.exit(0)).catch(() => process.exit(1));
  "; do
    echo "Waiting for Postgres..."
    sleep 2
  done
fi

# Run migrations (no-op if no migrations or already applied)
set +e
migrate_out=$(pnpm drizzle-kit migrate 2>&1)
migrate_ret=$?
set -e
if [ -n "$migrate_out" ] || [ "$migrate_ret" -ne 0 ]; then
  echo "drizzle-kit migrate produced output or failed (exit $migrate_ret); continuing anyway:" >&2
  echo "$migrate_out" >&2
fi

exec "$@"
