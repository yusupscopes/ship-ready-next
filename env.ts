import { z } from "zod";
import { createEnv } from "next-env-safe";

export const env = createEnv({
  server: {
    DATABASE_URL: z.string(),
    BETTER_AUTH_URL: z.string(),
    BETTER_AUTH_SECRET: z.string(),
    GOOGLE_CLIENT_ID: z.string(),
    GOOGLE_CLIENT_SECRET: z.string(),
    POLAR_ACCESS_TOKEN: z.string(),
    POLAR_WEBHOOK_SECRET: z.string(),
    POLAR_SUCCESS_URL: z.string(),
    CLOUDFLARE_ACCOUNT_ID: z.string(),
    R2_UPLOAD_IMAGE_ACCESS_KEY_ID: z.string(),
    R2_UPLOAD_IMAGE_SECRET_ACCESS_KEY: z.string(),
    R2_UPLOAD_IMAGE_BUCKET_NAME: z.string(),
    OPENAI_API_KEY: z.string(),
    RESEND_API_KEY: z.string(),
    RESEND_FROM_EMAIL: z.string(),
  },
  client: {
    NEXT_PUBLIC_APP_URL: z.string(),
    NEXT_PUBLIC_STARTER_TIER: z.string(),
    NEXT_PUBLIC_STARTER_SLUG: z.string(),
    NEXT_PUBLIC_POSTHOG_KEY: z.string(),
    NEXT_PUBLIC_POSTHOG_HOST: z.string(),
  },
  runtimeEnv: process.env,
});
