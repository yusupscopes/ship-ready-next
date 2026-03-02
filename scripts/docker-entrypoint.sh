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
npx drizzle-kit migrate 2>/dev/null || true

exec "$@"
