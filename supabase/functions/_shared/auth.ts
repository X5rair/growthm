import { supabaseAdmin } from "./supabaseAdmin.ts";
import { ApiError } from "./errorHandler.ts";

export function extractBearerToken(req: Request): string {
  const header = req.headers.get("Authorization");
  if (!header || !header.startsWith("Bearer ")) {
    throw new ApiError("Authorization token required", 401);
  }
  return header.replace("Bearer ", "").trim();
}

export async function requireAuthenticatedUser(token: string) {
  const { data, error } = await supabaseAdmin.auth.getUser(token);
  if (error || !data.user) {
    throw new ApiError("Invalid or expired session", 401);
  }
  return data.user;
}
