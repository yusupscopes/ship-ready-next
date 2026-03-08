# Ship Ready Next

[![Publish Container](https://github.com/yusupscopes/ship-ready-next/actions/workflows/publish-container.yml/badge.svg)](https://github.com/yusupscopes/ship-ready-next/actions/workflows/publish-container.yml)

A production-ready Next.js starter with authentication, type-safe API layer, and database persistence. Built to demonstrate how to ship a full-stack app with modern tooling and deployment workflows.

## 🚀 Key Features & Learning Outcomes

This project was built to cover essential full-stack patterns:

- **App Router & React 19:** Next.js 16 App Router with server components, layouts, and streaming.
- **Type-Safe API (tRPC):** End-to-end typed procedures with Zod validation and TanStack Query integration.
- **Database Persistence (PostgreSQL):** Drizzle ORM with migrations; schema for users, sessions, accounts, and verification.
- **Authentication (Better Auth):** Email/password and Google OAuth, with Drizzle adapter and session handling.
- **Environment & Config:** Validated server and client env via `next-env-safe` and Zod.
- **Health Check:** `/api/health` endpoint for load balancers and CI container validation.
- **Production Deployment:** Multi-stage Dockerfile, Docker Compose (app + Postgres), and GitHub Actions to build, test the container, and deploy via SSH.

## 🛠️ Tech Stack

- **Framework:** Next.js 16 (App Router)
- **Language:** TypeScript
- **UI:** React 19, Tailwind CSS, Radix UI / Base UI
- **API:** tRPC v11, Zod
- **Data:** Drizzle ORM, PostgreSQL
- **Auth:** Better Auth (email/password + Google)
- **Containerization:** Docker & Docker Compose

## 📦 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (LTS) and [pnpm](https://pnpm.io/)
- [Docker](https://docs.docker.com/get-docker/) and Docker Compose (for running with Postgres)

### Running locally (with existing Postgres)

1. Clone this repository.
2. Copy `.env.example` to `.env` and set `DATABASE_URL`, `BETTER_AUTH_*`, and other required variables (see `env.ts`).
3. From the project root:
   ```bash
   pnpm install
   pnpm db:generate
   pnpm db:migrate
   pnpm dev
   ```
4. Open [http://localhost:3000](http://localhost:3000).

### Running with Docker Compose

1. Clone this repository and ensure you have a `.env` file (see `docker-compose.yml` for `POSTGRES_*` and app env vars).
2. From the project root:
   ```bash
   docker compose up --build
   ```
   This starts the Next.js app on port `3000` and Postgres on port `5432`, with the app waiting for the DB to be healthy.

## 💻 API Usage

### 1. Health Check (Public)

For load balancers or CI, call the health endpoint:

```bash
curl -s http://localhost:3000/api/health
```

**Response:** `OK` (plain text, 200)

### 2. tRPC: Hello procedure (example)

The app exposes tRPC at `/api/trpc`. Example procedure: `hello.sayHello`.

**Request (GET):**

```bash
curl "http://localhost:3000/api/trpc/hello.sayHello?input=%7B%22text%22%3A%22world%22%7D"
```

**Response (JSON):**

```json
{
  "result": {
    "data": {
      "json": {
        "greeting": "hello world"
      }
    }
  }
}
```

_(Use the tRPC client in the app for type-safe calls with TanStack Query.)_

### 3. Authentication

- **Sign up / Sign in:** Use the Better Auth routes under `/api/auth/*` (e.g. `/sign-in`, `/sign-up` in the app).
- **Session:** `auth.api.getSession({ headers })` in server components or API routes.

## 🧪 Quality Checks

Lint the codebase:

```bash
pnpm lint
```

Generate and run database migrations:

```bash
pnpm db:generate
pnpm db:migrate
```

Open Drizzle Studio to inspect data:

```bash
pnpm db:studio
```
