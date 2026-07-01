// ============================================================
// Edge Function : improve-post
// DESCRIPTION : Améliore le contenu d'un post utilisateur.
//               Corrige les fautes, reformule, préserve l'intention.
//               Pipeline : Llama 3.3 70B (OpenRouter) + Gemini 3.1 Flash Lite
// TRIGGER : Appelé depuis le bouton "Améliorer avec l'IA"
// ============================================================

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const OPENROUTER_API_KEY = Deno.env.get("OPENROUTER_API_KEY") || "";
const OPENROUTER_MODEL = "meta-llama/llama-3.3-70b-instruct"; // Gratuit, multilingue, fiable
const OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY") || "";
const GEMINI_MODEL = "gemini-3.1-flash-lite";
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent`;

// ── Prompts ────────────────────────────────────────────────

const IMPROVE_PROMPT = `Tu es un assistant d'écriture bienveillant pour l'application Lumina (réseau social chrétien).

Ta mission : Améliorer le texte de l'utilisateur tout en PRÉSERVANT FIDÈLEMENT son intention.

RÈGLES STRICTES :
1. Préserve l'intention originale et le message de l'utilisateur
2. Corrige les fautes d'orthographe et de grammaire
3. Améliore la clarté et la fluidité
4. Garde le ton personnel et authentique — ne rends pas le texte robotique
5. Ne change PAS le sens ou l'émotion du message
6. N'ajoute PAS de contenu qui n'était pas dans l'original
7. Limite-toi à 3-4 phrases max

RÉPONDS UNIQUEMENT EN JSON :
{
  "original": "Texte original",
  "improved": "Texte amélioré",
  "corrections": "Liste des corrections apportées (1 ligne max)",
  "intentionPreserved": true
}`;

Deno.serve(async (req: Request) => {
  try {
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const body = await req.json();
    const { content, post_id } = body;

    if (!content || content.trim().length === 0) {
      return new Response(
        JSON.stringify({ error: "Contenu requis" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    if (content.length > 2000) {
      return new Response(
        JSON.stringify({ error: "Contenu trop long (max 2000 caractères)" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    console.log(`[improve-post] Amélioration du post ${post_id || "nouveau"}...`);

    // Étape 1 : Llama 3.3 70B améliore le texte
    const response = await fetch(OPENROUTER_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
        "HTTP-Referer": "https://lumina.app",
        "X-Title": "Lumina AI Improve",
      },
      body: JSON.stringify({
        model: OPENROUTER_MODEL,
        messages: [
          { role: "system", content: IMPROVE_PROMPT },
          { role: "user", content: `Améliore ce texte :\n\n${content}` },
        ],
        temperature: 0.3,
        max_tokens: 500,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`OpenRouter error (${response.status}): ${errorText}`);
    }

    const data = await response.json();
    let rawResult = data.choices?.[0]?.message?.content || "";

    // Nettoyer le JSON
    let cleanJson = rawResult.trim();
    cleanJson = cleanJson.replace(/^```(?:json)?\s*/i, "");
    cleanJson = cleanJson.replace(/\s*```$/i, "");

    let result: {
      original: string;
      improved: string;
      corrections: string;
      intentionPreserved: boolean;
    };

    try {
      result = JSON.parse(cleanJson);
    } catch {
      // Fallback : retourner le texte original
      result = {
        original: content,
        improved: content,
        corrections: "Impossible d'analyser",
        intentionPreserved: true,
      };
    }

    // Étape 2 : Gemini vérifie que l'intention est préservée (si configuré)
    if (GEMINI_API_KEY) {
      try {
        const geminiResponse = await fetch(`${GEMINI_URL}?key=${GEMINI_API_KEY}`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            contents: [
              {
                role: "user",
                parts: [{
                  text: `Vérifie que l'intention du texte original est préservée dans la version améliorée. Réponds UNIQUEMENT par true ou false.\n\nOriginal: ${content}\n\nAmélioré: ${result.improved}`,
                }],
              },
            ],
            generationConfig: {
              temperature: 0.1,
              maxOutputTokens: 10,
            },
          }),
        });

        if (geminiResponse.ok) {
          const geminiData = await geminiResponse.json();
          const geminiText = geminiData.candidates?.[0]?.content?.parts?.[0]?.text || "true";
          result.intentionPreserved = geminiText.toLowerCase().includes("true");
        }
      } catch (e) {
        console.warn("[improve-post] Gemini check failed:", e);
      }
    }

    // Si l'intention n'est pas préservée, retourner le texte original
    if (!result.intentionPreserved) {
      console.warn("[improve-post] Intention non préservée, retour du texte original");
      result.improved = content;
      result.corrections = "Intention originale préservée";
    }

    // Journaliser
    if (post_id) {
      try {
        const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
        await supabase.from("ai_queue").insert({
          task_type: "improve_post",
          status: "done",
          payload: { post_id, original: content },
          result: { improved: result.improved, corrections: result.corrections },
          model_used: `${OPENROUTER_MODEL} + gemini-check`,
        });
      } catch {
        // Silence
      }
    }

    console.log(`[improve-post] ✅ Texte amélioré`);

    return new Response(
      JSON.stringify({
        improved: result.improved,
        corrections: result.corrections,
        intentionPreserved: result.intentionPreserved,
      }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("[improve-post] Error:", error);

    // En cas d'erreur, retourner le texte original inchangé
    return new Response(
      JSON.stringify({
        improved: body.content || "",
        corrections: "Service temporairement indisponible",
        intentionPreserved: true,
        error: String(error),
      }),
      { status: 200, headers: { "Content-Type": "application/json" } } // 200 même en erreur pour UX
    );
  }
});
