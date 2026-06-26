// ============================================================
// Edge Function : send-announcement-notification
// DESCRIPTION : Envoie des notifications push FCM aux membres
//               d'une église lorsqu'une annonce est publiée.
// TRIGGER : Database Webhook sur INSERT/UPDATE dans `annonces`
//           où is_published = true OU is_active = true
// ============================================================

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

// Clé serveur FCM (configurée via supabase secrets set)
const FCM_SERVER_KEY = Deno.env.get("FCM_SERVER_KEY");

// Interface pour le payload du webhook
interface WebhookPayload {
  type: "INSERT" | "UPDATE" | "DELETE";
  table: string;
  record: Record<string, unknown>;
  old_record: Record<string, unknown> | null;
  schema: string;
}

Deno.serve(async (req: Request) => {
  try {
    // Vérifier la méthode
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const payload: WebhookPayload = await req.json();
    const { type, record, old_record } = payload;

    // Vérifier que c'est une annonce publiée/activée
    const isPublished = record.is_published === true || record.is_active === true;
    const wasPublished = old_record?.is_published === true || old_record?.is_active === true;

    // Envoyer uniquement quand une annonce DEVIENT publiée
    // (INSERT avec is_published=true, ou UPDATE de false → true)
    if (type === "INSERT" && !isPublished) {
      return new Response(JSON.stringify({ skipped: true, reason: "not published" }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    if (type === "UPDATE" && (wasPublished || !isPublished)) {
      return new Response(JSON.stringify({ skipped: true, reason: "already published or unpublished" }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    if (!FCM_SERVER_KEY) {
      console.error("FCM_SERVER_KEY not configured");
      return new Response(JSON.stringify({ error: "FCM not configured" }), {
        status: 500,
        headers: { "Content-Type": "application/json" },
      });
    }

    const churchId = record.church_id as string;
    const title = (record.title as string) || "Nouvelle annonce";
    const summary = (record.summary as string) || (record.content as string)?.substring(0, 100) || "";

    // Créer un client Supabase avec le service_role pour accéder à tous les tokens
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Récupérer les tokens FCM des membres de l'église
    const { data: tokens, error: tokensError } = await supabase
      .from("fcm_tokens")
      .select("token, user_id")
      .eq("church_id", churchId);

    if (tokensError) {
      console.error("Error fetching tokens:", tokensError);
      return new Response(JSON.stringify({ error: "Failed to fetch tokens" }), {
        status: 500,
        headers: { "Content-Type": "application/json" },
      });
    }

    if (!tokens || tokens.length === 0) {
      return new Response(JSON.stringify({ sent: 0, reason: "no tokens found" }), {
        headers: { "Content-Type": "application/json" },
      });
    }

    console.log(`Sending notifications to ${tokens.length} devices for church ${churchId}`);

    // Envoyer les notifications en batch (FCM Legacy HTTP API)
    const invalidTokens: string[] = [];
    let successCount = 0;

    // Traitement par lots de 500 (limite FCM)
    const batchSize = 500;
    for (let i = 0; i < tokens.length; i += batchSize) {
      const batch = tokens.slice(i, i + batchSize);
      const registrationIds = batch.map((t: { token: string }) => t.token);

      const fcmResponse = await fetch("https://fcm.googleapis.com/fcm/send", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `key=${FCM_SERVER_KEY}`,
        },
        body: JSON.stringify({
          registration_ids: registrationIds,
          notification: {
            title: `📢 ${title}`,
            body: summary,
            sound: "default",
            badge: "1",
          },
          data: {
            type: "announcement",
            announcement_id: record.id,
            church_id: churchId,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
          priority: "high",
        }),
      });

      if (fcmResponse.ok) {
        const result = await fcmResponse.json();
        successCount += result.success || 0;

        // Collecter les tokens invalides pour nettoyage
        if (result.results) {
          result.results.forEach((res: { error?: string }, idx: number) => {
            if (
              res.error === "NotRegistered" ||
              res.error === "InvalidRegistration"
            ) {
              invalidTokens.push(registrationIds[idx]);
            }
          });
        }
      } else {
        console.error(`FCM batch error: ${fcmResponse.status} ${await fcmResponse.text()}`);
      }
    }

    // Nettoyer les tokens invalides
    if (invalidTokens.length > 0) {
      console.log(`Cleaning up ${invalidTokens.length} invalid tokens`);
      const { error: deleteError } = await supabase
        .from("fcm_tokens")
        .delete()
        .in_("token", invalidTokens);

      if (deleteError) {
        console.error("Error cleaning tokens:", deleteError);
      }
    }

    // Créer une notification en base pour chaque membre de l'église
    // (pour les utilisateurs qui n'ont pas de token FCM)
    const { data: churchMembers } = await supabase
      .from("profiles")
      .select("id")
      .eq("church_id", churchId);

    if (churchMembers && churchMembers.length > 0) {
      const notifications = churchMembers.map((member: { id: string }) => ({
        user_id: member.id,
        title: `📢 ${title}`,
        body: summary,
        type: "announcement",
        data: JSON.stringify({ announcement_id: record.id }),
        is_read: false,
      }));

      // Insert en batch (ignorer les erreurs individuelles)
      await supabase.from("notifications").insert(notifications);
    }

    return new Response(
      JSON.stringify({
        sent: successCount,
        total_tokens: tokens.length,
        invalid_cleaned: invalidTokens.length,
        in_app_notifications: churchMembers?.length || 0,
      }),
      {
        headers: { "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Unexpected error:", error);
    return new Response(JSON.stringify({ error: String(error) }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
