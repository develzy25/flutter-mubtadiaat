import { betterAuth } from 'better-auth';
import { drizzleAdapter } from 'better-auth/adapters/drizzle';
import { drizzle } from 'drizzle-orm/d1';
import * as schema from '../db/schema';

// This function returns the betterAuth instance configured with the D1 database binding
export const getAuth = (env: { DB: D1Database, BETTER_AUTH_SECRET: string, BETTER_AUTH_URL: string }) => {
  const db = drizzle(env.DB, { schema });
  
  return betterAuth({
    database: drizzleAdapter(db, {
      provider: 'sqlite', // using d1 sqlite
      usePlural: true,
    }),
    emailAndPassword: {
      enabled: true, // We enable standard email/password login
    },
    trustedOrigins: ['http://localhost:5173'],
    secret: env.BETTER_AUTH_SECRET,
    baseURL: env.BETTER_AUTH_URL,
    // Add additional settings (JWT, etc.) here
  });
};
