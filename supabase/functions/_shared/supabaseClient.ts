import { createClient } from "https://esm.sh/@supabase/supabase-js@2.43.0/dist/supabase-deno.js";

const supabaseUrl = Deno.env.get("SUPABASE_URL");
const anonKey = Deno.env.get("SUPABASE_ANON_KEY");

if (!supabaseUrl || !anonKey) {
  throw new Error(
    "SUPABASE_URL and SUPABASE_ANON_KEY must be configured for Edge Functions",
  );
}

export const supabaseClient = createClient(supabaseUrl, anonKey, {
  auth: { persistSession: false },
});
