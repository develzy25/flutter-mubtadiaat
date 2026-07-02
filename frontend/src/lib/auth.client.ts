import { createAuthClient } from "better-auth/react"

export const authClient = createAuthClient({
    baseURL: import.meta.env.DEV 
      ? 'http://localhost:8787/api/auth' 
      : `${window.location.origin}/api/auth`
});

export const { signIn, signUp, signOut, useSession } = authClient;
