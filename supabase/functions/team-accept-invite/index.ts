// Supabase Edge Function: team-accept-invite
// Accepte une invitation d'équipe via token ou code
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const APP_DEEP_LINK = Deno.env.get("APP_DEEP_LINK") || "lumina://";

interface RequestBody {
    code: string;
    device_fingerprint?: string;
    device_name?: string;
}

interface AcceptInviteResult {
    success: boolean;
    error?: string;
    team_id?: string;
    team_name?: string;
    role_name?: string;
    already_member?: boolean;
}

Deno.serve(async (req: Request): Promise<Response> => {
    const corsHeaders = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    };

    if (req.method === "OPTIONS") {
        return new Response(null, { headers: corsHeaders });
    }

    // Gérer les requêtes GET (clics sur liens email)
    if (req.method === "GET") {
        const url = new URL(req.url);
        const code = url.searchParams.get("code");

        if (!code) {
            return Response.redirect(`${APP_DEEP_LINK}teams/invite-error?message=missing_code`, 302);
        }

        // Rediriger vers l'app avec le code pour que l'utilisateur se connecte d'abord
        return Response.redirect(`${APP_DEEP_LINK}teams/accept?code=${encodeURIComponent(code)}`, 302);
    }

    try {
        // Vérifier l'authentification
        const authHeader = req.headers.get("Authorization");
        if (!authHeader) {
            return new Response(
                JSON.stringify({
                    success: false,
                    error: "UNAUTHORIZED",
                    message: "Vous devez être connecté pour accepter une invitation"
                }),
                { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

        // Vérifier l'utilisateur
        const { data: { user }, error: authError } = await supabase.auth.getUser(
            authHeader.replace("Bearer ", "")
        );

        if (authError || !user) {
            return new Response(
                JSON.stringify({ success: false, error: "INVALID_TOKEN", message: "Token invalide" }),
                { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        const body: RequestBody = await req.json();
        const { code, device_fingerprint, device_name } = body;

        if (!code) {
            return new Response(
                JSON.stringify({ success: false, error: "MISSING_CODE", message: "Code d'invitation requis" }),
                { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        // Accepter l'invitation via la fonction PostgreSQL
        const { data: result, error: acceptError } = await supabase.rpc("accept_team_invite", {
            p_token: code,
            p_user_id: user.id,
        });

        if (acceptError) {
            console.error("Accept invite error:", acceptError);
            return new Response(
                JSON.stringify({
                    success: false,
                    error: "ACCEPT_FAILED",
                    message: acceptError.message
                }),
                { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        const acceptResult = result as AcceptInviteResult;

        if (!acceptResult.success) {
            const errorMessages: Record<string, string> = {
                INVITE_NOT_FOUND: "Invitation non trouvée. Vérifiez le code.",
                INVITE_EXPIRED_OR_USED: "Cette invitation a expiré ou a déjà été utilisée.",
            };

            return new Response(
                JSON.stringify({
                    success: false,
                    error: acceptResult.error,
                    message: errorMessages[acceptResult.error || ""] || "Erreur lors de l'acceptation",
                }),
                { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        // Optionnel: créer un dispositif de confiance si fourni
        if (device_fingerprint) {
            const ipAddress = req.headers.get("x-forwarded-for")?.split(",")[0]?.trim() || null;
            const userAgent = req.headers.get("user-agent") || null;

            await supabase.rpc("create_trusted_device", {
                p_user_id: user.id,
                p_device_fingerprint: device_fingerprint,
                p_device_name: device_name || "Invite Accept Device",
                p_device_type: "android",
                p_ip_address: ipAddress,
                p_user_agent: userAgent,
            });
        }

        return new Response(
            JSON.stringify({
                success: true,
                message: acceptResult.already_member
                    ? `Vous êtes déjà membre de ${acceptResult.team_name}`
                    : `Bienvenue dans l'équipe ${acceptResult.team_name} !`,
                team_id: acceptResult.team_id,
                team_name: acceptResult.team_name,
                role_name: acceptResult.role_name,
                already_member: acceptResult.already_member,
            }),
            { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
    } catch (error) {
        console.error("Unexpected error:", error);
        return new Response(
            JSON.stringify({ success: false, error: "INTERNAL_ERROR", message: "Erreur interne du serveur" }),
            { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
        );
    }
});
