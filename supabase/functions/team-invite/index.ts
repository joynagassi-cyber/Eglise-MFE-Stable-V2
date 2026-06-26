// Supabase Edge Function: team-invite
// Crée une invitation d'équipe et envoie l'email via Resend
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const RESEND_API_KEY = Deno.env.get("RESEND_API_KEY")!;
const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const FROM_EMAIL = Deno.env.get("FROM_EMAIL") || "noreply@mfejc.org";
const APP_NAME = "Feu de l'Évangile";
const APP_URL = Deno.env.get("APP_URL") || "https://mfejc.org";

interface RequestBody {
    team_id: string;
    invited_email: string;
    role_name: string;
    message?: string;
}

Deno.serve(async (req: Request): Promise<Response> => {
    const corsHeaders = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
    };

    if (req.method === "OPTIONS") {
        return new Response(null, { headers: corsHeaders });
    }

    try {
        // Vérifier l'authentification
        const authHeader = req.headers.get("Authorization");
        if (!authHeader) {
            return new Response(
                JSON.stringify({ success: false, error: "UNAUTHORIZED", message: "Token d'authentification requis" }),
                { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

        // Vérifier l'utilisateur appelant
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
        const { team_id, invited_email, role_name, message } = body;

        if (!team_id || !invited_email || !role_name) {
            return new Response(
                JSON.stringify({
                    success: false,
                    error: "MISSING_FIELDS",
                    message: "team_id, invited_email et role_name sont requis"
                }),
                { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        // Vérifier que l'utilisateur a la permission d'inviter
        const { data: hasPermission } = await supabase.rpc("check_team_permission", {
            p_team_id: team_id,
            p_user_id: user.id,
            p_permission: "invites.create",
        });

        if (!hasPermission) {
            return new Response(
                JSON.stringify({
                    success: false,
                    error: "FORBIDDEN",
                    message: "Vous n'avez pas la permission d'inviter des membres"
                }),
                { status: 403, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        // Créer l'invitation via la fonction PostgreSQL
        const { data: inviteToken, error: inviteError } = await supabase.rpc("create_team_invite", {
            p_team_id: team_id,
            p_invited_email: invited_email,
            p_role_name: role_name,
            p_created_by: user.id,
            p_message: message || null,
        });

        if (inviteError) {
            const errorMessages: Record<string, string> = {
                ROLE_NOT_FOUND: "Le rôle spécifié n'existe pas",
                ALREADY_MEMBER: "Cette personne est déjà membre de l'équipe",
            };

            return new Response(
                JSON.stringify({
                    success: false,
                    error: inviteError.message,
                    message: errorMessages[inviteError.message] || inviteError.message
                }),
                { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
            );
        }

        // Récupérer les infos de l'équipe pour l'email
        const { data: team } = await supabase
            .from("teams")
            .select("name, slug")
            .eq("id", team_id)
            .single();

        // Récupérer le nom de l'inviteur
        const inviterName = user.user_metadata?.full_name || user.email || "Un administrateur";

        // Construire l'URL d'acceptation
        const acceptUrl = `${APP_URL}/teams/accept?code=${encodeURIComponent(inviteToken)}`;

        // Calculer la date d'expiration (7 jours)
        const expiryDate = new Date();
        expiryDate.setDate(expiryDate.getDate() + 7);
        const expiryDateStr = expiryDate.toLocaleDateString("fr-FR", {
            weekday: "long",
            year: "numeric",
            month: "long",
            day: "numeric",
        });

        // Construire l'email
        const emailHtml = buildInviteEmailHtml(
            team?.name || "Équipe",
            role_name,
            inviterName,
            inviteToken,
            acceptUrl,
            expiryDateStr,
            message
        );

        const emailText = buildInviteEmailText(
            team?.name || "Équipe",
            role_name,
            inviterName,
            inviteToken,
            acceptUrl,
            expiryDateStr,
            message
        );

        // Envoyer l'email via Resend
        const resendResponse = await fetch("https://api.resend.com/emails", {
            method: "POST",
            headers: {
                Authorization: `Bearer ${RESEND_API_KEY}`,
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                from: `${APP_NAME} <${FROM_EMAIL}>`,
                to: invited_email,
                subject: `Invitation à rejoindre l'équipe « ${team?.name} »`,
                html: emailHtml,
                text: emailText,
            }),
        });

        const resendData = await resendResponse.json();

        if (!resendResponse.ok) {
            console.error("Resend error:", resendData);
            // On ne fait pas échouer l'invitation, juste le log
        }

        return new Response(
            JSON.stringify({
                success: true,
                message: `Invitation envoyée à ${invited_email}`,
                invite_code: inviteToken, // Pour les tests/debug uniquement
                expires_at: expiryDate.toISOString(),
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

// ============================================================================
// EMAIL TEMPLATES
// ============================================================================

function buildInviteEmailHtml(
    teamName: string,
    roleName: string,
    inviterName: string,
    code: string,
    acceptUrl: string,
    expiryDate: string,
    message?: string
): string {
    const roleDisplayNames: Record<string, string> = {
        owner: "Propriétaire",
        admin: "Administrateur",
        member: "Membre",
    };

    const roleDisplay = roleDisplayNames[roleName] || roleName;

    return `
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Invitation à rejoindre ${teamName}</title>
</head>
<body style="margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; background-color: #f5f5f5;">
  <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="background-color: #f5f5f5;">
    <tr>
      <td style="padding: 40px 20px;">
        <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%" style="max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);">
          <!-- Header -->
          <tr>
            <td style="padding: 40px 40px 20px; text-align: center; background: linear-gradient(135deg, #1e40af 0%, #7c3aed 100%); border-radius: 12px 12px 0 0;">
              <h1 style="margin: 0; color: #ffffff; font-size: 24px; font-weight: 600;">🔥 Feu de l'Évangile</h1>
            </td>
          </tr>
          
          <!-- Content -->
          <tr>
            <td style="padding: 40px;">
              <h2 style="margin: 0 0 16px; color: #1f2937; font-size: 22px; font-weight: 600;">Vous avez été invité !</h2>
              
              <p style="margin: 0 0 24px; color: #4b5563; font-size: 16px; line-height: 1.6;">
                Vous avez reçu une invitation pour rejoindre l'équipe <strong style="color: #1e40af;">${teamName}</strong> sur Feu de l'Évangile.
              </p>
              
              <!-- Info Box -->
              <div style="background-color: #f3f4f6; border-radius: 8px; padding: 20px; margin-bottom: 24px;">
                <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
                  <tr>
                    <td style="padding: 8px 0; color: #6b7280; font-size: 14px;">Rôle proposé :</td>
                    <td style="padding: 8px 0; color: #1f2937; font-size: 14px; font-weight: 600; text-align: right;">${roleDisplay}</td>
                  </tr>
                  <tr>
                    <td style="padding: 8px 0; color: #6b7280; font-size: 14px;">Invité par :</td>
                    <td style="padding: 8px 0; color: #1f2937; font-size: 14px; font-weight: 600; text-align: right;">${inviterName}</td>
                  </tr>
                </table>
              </div>
              
              ${message ? `
              <div style="background-color: #fef3c7; border-left: 4px solid #f59e0b; padding: 16px; margin-bottom: 24px; border-radius: 0 8px 8px 0;">
                <p style="margin: 0; color: #92400e; font-size: 14px; font-style: italic;">"${message}"</p>
              </div>
              ` : ""}
              
              <!-- Accept Button -->
              <div style="text-align: center; margin-bottom: 24px;">
                <a href="${acceptUrl}" style="display: inline-block; padding: 14px 32px; background: linear-gradient(135deg, #1e40af 0%, #7c3aed 100%); color: #ffffff; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 16px;">Accepter l'invitation</a>
              </div>
              
              <!-- Divider -->
              <div style="text-align: center; margin: 24px 0;">
                <span style="color: #9ca3af; font-size: 14px;">ou saisissez ce code dans l'application</span>
              </div>
              
              <!-- Code Box -->
              <div style="background-color: #f3f4f6; border-radius: 8px; padding: 20px; text-align: center; margin-bottom: 24px;">
                <p style="margin: 0; color: #1f2937; font-size: 28px; font-weight: 700; letter-spacing: 4px; font-family: 'Courier New', monospace;">${code}</p>
              </div>
              
              <p style="margin: 0; color: #ef4444; font-size: 13px; text-align: center;">⏱️ Cette invitation expire le ${expiryDate}</p>
              
              <p style="margin: 24px 0 0; color: #9ca3af; font-size: 13px; text-align: center;">Si vous n'attendiez pas cette invitation, ignorez simplement cet email.</p>
            </td>
          </tr>
          
          <!-- Footer -->
          <tr>
            <td style="padding: 24px 40px; background-color: #f9fafb; border-radius: 0 0 12px 12px; border-top: 1px solid #e5e7eb;">
              <p style="margin: 0; color: #9ca3af; font-size: 12px; text-align: center;">
                © ${new Date().getFullYear()} Feu de l'Évangile. Tous droits réservés.
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
  `;
}

function buildInviteEmailText(
    teamName: string,
    roleName: string,
    inviterName: string,
    code: string,
    acceptUrl: string,
    expiryDate: string,
    message?: string
): string {
    const roleDisplayNames: Record<string, string> = {
        owner: "Propriétaire",
        admin: "Administrateur",
        member: "Membre",
    };

    return `
Vous avez été invité à rejoindre l'équipe "${teamName}" sur Feu de l'Évangile.

Rôle proposé : ${roleDisplayNames[roleName] || roleName}
Invité par : ${inviterName}

${message ? `Message : "${message}"\n` : ""}

Pour accepter l'invitation :
1. Cliquez sur ce lien : ${acceptUrl}
2. Ou saisissez ce code dans l'application : ${code}

Cette invitation expire le ${expiryDate}.

Si vous n'attendiez pas cette invitation, ignorez cet email.

--
Feu de l'Évangile
  `.trim();
}
