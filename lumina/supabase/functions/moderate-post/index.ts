// ============================================================
// Edge Function : moderate-post
// DESCRIPTION : Modère les posts via Llama 3.3 70B (OpenRouter).
//               Détecte : haine, méchanceté, colère, hors-chrétienté
//               Et signale aux admins via moderation_reports.
// TRIGGER : Appelé après création/édition d'un post
// ============================================================

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const OPENROUTER_API_KEY = Deno.env.get("OPENROUTER_API_KEY") || "";
const OPENROUTER_MODEL = "meta-llama/llama-3.3-70b-instruct"; // Gratuit, multilingue, fiable
const OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions";

// ── Interface pour le payload ─────────────────────────────

interface ModerationResult {
  isFlagged: boolean;
  category: "hate" | "malicious" | "anger" | "off_topic" | "none";
  confidence: number; // 0-1
  reason: string;
  severity: number; // 0-100
}

const MODERATION_PROMPT = `Tu es un modérateur chrétien pour l'application Lumina.
Analyse ce post et détermine s'il viole la charte chrétienne.

CATÉGORIES À DÉTECTER :
- hate : Discours haineux, attaques personnelles, racisme, discrimination
- malicious : Méchanceté, intimidation, moquerie, humiliation
- anger : Colère excessive, insultes, agressivité
- off_topic : Hors contexte chrétien, blasphème, contenu inapproprié
- none : Contenu acceptable

RÈGLES :
1. Sois indulgent avec les erreurs humaines et les émotions
2. Ne flague pas les critiques constructives ou les questions sincères
3. Pour les posts avec des versets bibliques (contenant des références), sois TRÈS indulgent
4. Un post qui parle de difficultés personnelles n'est PAS à flaguer
5. Seulement ce qui est clairement haineux, méchant, ou hors charte doit être signalé

RÉPONDS UNIQUEMENT EN JSON :
{
  "isFlagged": false,
  "category": "none",
  "confidence": 0.0,
  "reason": "",
  "severity": 0
}`;

Deno.serve(async (req: Request) => {
  try {
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const body = await req.json();
    const { post_id, content, author_name } = body;

    if (!post_id || !content) {
      return new Response(
        JSON.stringify({ error: "post_id et content requis" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Vérification : ne pas modérer les posts IA générés automatiquement
    if (body.is_ai_generated === true) {
      return new Response(
        JSON.stringify({ skipped: true, reason: "AI generated posts skip moderation" }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    }

    console.log(`[moderate-post] Analyse du post ${post_id}...`);

    // Appel à OpenRouter Llama 3.3 70B
    const response = await fetch(OPENROUTER_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
        "HTTP-Referer": "https://lumina.app",
        "X-Title": "Lumina Moderation",
      },
      body: JSON.stringify({
        model: OPENROUTER_MODEL,
        messages: [
          { role: "system", content: MODERATION_PROMPT },
          {
            role: "user",
            content: `Analyse ce post:\nAuteur: ${author_name || "Inconnu"}\nContenu: ${content}`,
          },
        ],
        temperature: 0.1, // Basse température pour cohérence
        max_tokens: 300,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`OpenRouter error (${response.status}): ${errorText}`);
    }

    const data = await response.json();
    const rawResult = data.choices?.[0]?.message?.content || "";

    // Extraire le JSON
    let cleanJson = rawResult.trim();
    cleanJson = cleanJson.replace(/^```(?:json)?\s*/i, "");
    cleanJson = cleanJson.replace(/\s*```$/i, "");

    let result: ModerationResult;
    try {
      result = JSON.parse(cleanJson);
    } catch {
      // Fallback safe
      result = {
        isFlagged: false,
        category: "none" as const,
        confidence: 0,
        reason: "Parse error",
        severity: 0,
      };
    }

    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // Si le post est signalé, créer un rapport de modération
    if (result.isFlagged && result.category !== "none") {
      console.log(`[moderate-post] 🚨 Post ${post_id} signalé: ${result.category} (${result.severity}%)`);

      // Mettre à jour le statut du post
      await supabase
        .from("social_posts")
        .update({
          status: "flagged",
          moderation_score: Math.round(result.severity),
          moderation_reason: result.reason,
          moderated_at: new Date().toISOString(),
        })
        .eq("id", post_id);

      // Créer le rapport
      const { data: report, error: reportError } = await supabase
        .from("moderation_reports")
        .insert({
          post_id,
          reported_by: "system",
          reason: result.reason,
          category: result.category,
          severity: result.severity,
          status: "pending",
        })
        .select()
        .single();

      if (reportError) {
        console.error("[moderate-post] Erreur création rapport:", reportError);
      }

      // Journaliser
      await supabase.from("ai_queue").insert({
        task_type: "moderate",
        status: "done",
        payload: { post_id, category: result.category, severity: result.severity },
        result: { flagged: true, report_id: report?.id },
        model_used: OPENROUTER_MODEL,
      });

      return new Response(
        JSON.stringify({
          flagged: true,
          category: result.category,
          severity: result.severity,
          reason: result.reason,
          report_id: report?.id,
        }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    }

    // Post propre
    console.log(`[moderate-post] ✅ Post ${post_id}: propre`);
    
    await supabase.from("ai_queue").insert({
      task_type: "moderate",
      status: "done",
      payload: { post_id },
      result: { flagged: false, confidence: result.confidence },
      model_used: OPENROUTER_MODEL,
    });

    return new Response(
      JSON.stringify({ flagged: false, confidence: result.confidence }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("[moderate-post] Error:", error);

    return new Response(
      JSON.stringify({
        success: false,
        error: String(error),
        // En cas d'erreur, on ne flague pas le post (safe fallback)
        flagged: false,
      }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});
