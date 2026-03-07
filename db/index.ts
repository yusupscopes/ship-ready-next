import { config } from "dotenv";
import { drizzle as drizzlePg } from "drizzle-orm/node-postgres";
import { Pool } from "pg";
import { env } from "@/env";

config({ path: ".env" });

const databaseUrl = env.DATABASE_URL!;

const globalForPg = globalThis as unknown as { __pgPool?: Pool };
const pool =
  globalForPg.__pgPool ??
  (globalForPg.__pgPool = new Pool({ connectionString: databaseUrl }));

export const db = drizzlePg(pool);
