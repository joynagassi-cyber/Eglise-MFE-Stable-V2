import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";
import { crypto } from "https://deno.land/std@0.208.0/crypto/mod.ts";
import { encodeHex } from "https://deno.land/std@0.208.0/encoding/hex.ts";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const RATE_LIMIT_WINDOW_MS = 15 * 60 * 1000; // 15 minutes
const MAX_ATTEMPTS = 5;

// Helper to calculate SHA-256 hash
async function hashString(message: string): Promise<string> {
    const encoder = new TextEncoder();
    const data = encoder.encode(message);
    const hash = await crypto.subtle.digest("SHA-256", data);
    return encodeHex(hash);
}

Deno.serve(async (req: Request): Promise<Response> => {
    // 1. CORS
    if (req.method === "OPTIONS") {
        return new Response(null, {
            headers: {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
            },
        });
    }

    try {
        // 2. Auth Check (User must be logged in)
        const authHeader = req.headers.get("Authorization");
        if (!authHeader) {
            return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });
        }

        const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
        const { data: { user }, error: userError } = await supabase.auth.getUser(authHeader.replace("Bearer ", ""));

        if (userError || !user) {
            return new Response(JSON.stringify({ error: "Unauthorized" }), { status: 401 });
        }

        const userId = user.id;

        // 3. Rate Limiting Check
        // We query the recent failed attempts for this user
        const { count: failedAttempts } = await supabase
            .from("activity_log")
            .select("*", { count: "exact", head: true })
            .eq("user_id", userId)
            .eq("action", "admin.activation_failed")
            .gte("created_at", new Date(Date.now() - RATE_LIMIT_WINDOW_MS).toISOString());

        if ((failedAttempts || 0) >= MAX_ATTEMPTS) {
            return new Response(
                JSON.stringify({
                    error: "rate_limit_exceeded",
                    message: "Trop de tentatives échouées. Veuillez réessayer dans 15 minutes."
                }),
                { status: 429, headers: { "Content-Type": "application/json" } }
            );
        }

        // 4. Parse & Validate Input
        const { code } = await req.json();
        if (!code || typeof code !== "string") {
            return new Response(JSON.stringify({ error: "Code requis" }), { status: 400 });
        }

        // 5. Verify Code Hash
        const codeHash = await hashString(code);

        // Use RPC to verify against DB (ensures consistent logic)
        const { data: isValid, error: rpcError } = await supabase.rpc("verify_admin_code", {
            p_code_hash: codeHash,
            p_user_id: userId,
            p_ip_address: req.headers.get("x-forwarded-for") || "unknown",
            p_user_agent: req.headers.get("user-agent") || "unknown"
        });

        if (rpcError) {
            console.error("RPC Error:", rpcError);
            return new Response(JSON.stringify({ error: "Erreur serveur interne" }), { status: 500 });
        }

        if (!isValid) {
            // Log is handled by RPC, just return error
            return new Response(
                JSON.stringify({
                    error: "invalid_code",
                    message: "Code invalide"
                }),
                { status: 403, headers: { "Content-Type": "application/json" } }
            );
        }

        // 6. Upgrade User Role via app_metadata (sécurisé, non modifiable par l'utilisateur)
        const { error: updateError } = await supabase.auth.admin.updateUserById(
            userId,
            { app_metadata: { role: "superadmin" } }
        );

        if (updateError) {
            console.error("Role Update Error:", updateError);
            return new Response(JSON.stringify({ error: "Erreur lors de la mise à jour du rôle" }), {
                status: 500,
                headers: { ...corsHeaders, "Content-Type": "application/json" },
            });
        }

        // NOTE: Ne pas mettre à jour user_metadata — il est éditable par l'utilisateur
        // et ne doit pas être utilisé pour des décisions de sécurité.

        return new Response(
            JSON.stringify({
                success: true,
                message: "Félicitations ! Vous êtes maintenant Superadmin.",
                role: "superadmin"
            }),
            {
                headers: { "Content-Type": "application/json" },
                status: 200,
            }
        );

    } catch (err) {
        return new Response(
            JSON.stringify({ error: err.message }),
            { status: 500, headers: { "Content-Type": "application/json" } }
        );
    }
});
