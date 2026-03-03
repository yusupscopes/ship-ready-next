import { config } from "dotenv";
import { drizzle as drizzleNeon } from "drizzle-orm/neon-http";
import { drizzle as drizzlePg } from "drizzle-orm/node-postgres";
import { Pool } from "pg";
import { env } from "@/env";

config({ path: ".env" }); // or .env.local

const databaseUrl = env.DATABASE_URL!;

// Use Neon serverless driver for Neon URLs; use node-postgres for standard Postgres (e.g. Docker, local)
const isNeon = databaseUrl.includes("neon.tech");

// Singleton Pool for node-postgres to avoid connection leaks during hot reload
const globalForPg = globalThis as unknown as { __pgPool?: Pool };
const pool =
  globalForPg.__pgPool ?? (globalForPg.__pgPool = new Pool({ connectionString: databaseUrl }));

export const db = isNeon
  ? drizzleNeon(databaseUrl)
  : drizzlePg(pool);
