import { createAuthClient } from "better-auth/react"

export const authClient = createAuthClient({
    baseURL: "http://localhost:8787/api/auth" // Adjust based on your Hono backend URL
});

export const { signIn, signUp, signOut, useSession } = authClient;
