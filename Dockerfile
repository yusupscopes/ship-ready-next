# syntax=docker/dockerfile:1
# ---- Base ----
FROM node:24-alpine AS base
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app

# ---- Dependencies ----
FROM base AS deps
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile

# ---- Build ----
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN mkdir -p migrations
ENV NEXT_TELEMETRY_DISABLED=1
# server environment variables
ENV DATABASE_URL=postgresql://postgres:postgres@db:5432/shipready
ENV BETTER_AUTH_URL=http://localhost:3000
ENV BETTER_AUTH_SECRET=build-dummy
ENV GOOGLE_CLIENT_ID=build-dummy
ENV GOOGLE_CLIENT_SECRET=build-dummy
ENV POLAR_ACCESS_TOKEN=build-dummy
ENV POLAR_WEBHOOK_SECRET=build-dummy
ENV POLAR_SUCCESS_URL=http://localhost:3000
ENV CLOUDFLARE_ACCOUNT_ID=build-dummy
ENV R2_UPLOAD_IMAGE_ACCESS_KEY_ID=build-dummy
ENV R2_UPLOAD_IMAGE_SECRET_ACCESS_KEY=build-dummy
ENV R2_UPLOAD_IMAGE_BUCKET_NAME=build-dummy
ENV OPENAI_API_KEY=build-dummy
ENV RESEND_API_KEY=build-dummy
ENV RESEND_FROM_EMAIL=build-dummy
# client environment variables
ENV NEXT_PUBLIC_APP_URL=http://localhost:3000
ENV NEXT_PUBLIC_STARTER_TIER=build-dummy
ENV NEXT_PUBLIC_STARTER_SLUG=build-dummy
ENV NEXT_PUBLIC_POSTHOG_KEY=build-dummy
ENV NEXT_PUBLIC_POSTHOG_HOST=https://us.i.posthog.com
RUN pnpm build

# ---- Runner ----
FROM base AS runner
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Migrations and config for entrypoint (drizzle-kit migrate)
COPY --from=builder /app/env.ts ./env.ts
COPY --from=builder /app/migrations ./migrations
COPY --from=builder /app/drizzle.config.ts ./drizzle.config.ts
COPY --from=builder /app/db ./db
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/pnpm-lock.yaml ./pnpm-lock.yaml
RUN pnpm install --frozen-lockfile --prod && pnpm add drizzle-kit

COPY --chown=nextjs:nodejs scripts/docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER nextjs
EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["pnpm", "start"]
