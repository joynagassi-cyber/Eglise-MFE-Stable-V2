// ============================================================
// Edge Function : generate-ai-post
// DESCRIPTION : Génère 2 posts bibliques quotidiens avec
//               des versets tirés de la Bible locale.
//               Pipeline : GPT-100B → Gemini 3.1 Flash Lite
// TRIGGER : pg_cron (08:00 et 19:00) ou appel manuel admin
// ============================================================

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

// ── Configuration des providers IA ─────────────────────────

const OPENROUTER_API_KEY = Deno.env.get("OPENROUTER_API_KEY") || "";
const OPENROUTER_MODEL = "meta-llama/llama-3.3-70b-instruct"; // Gratuit, multilingue (français), excellente qualité
const OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY") || "";
const GEMINI_MODEL = "gemini-3.1-flash-lite";
const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent`;

// ── Types ──────────────────────────────────────────────────

interface GeneratedPost {
  content: string;
  bibleVerse: string;
  bibleText: string;
  tone: "morning" | "evening";
  theme: string;
}

interface AIPrompt {
  systemPrompt: string;
  userPrompt: string;
}

const CHURCH_ID = Deno.env.get("DEFAULT_CHURCH_ID") || "default_church";

// ── Prompts système ───────────────────────────────────────

const SYSTEM_PROMPTS = {
  morning: `Tu es un pasteur qui rédige des publications encourageantes pour l'application Lumina de l'Église.

RÈGLES STRICTES :
1. Choisis UN verset biblique RÉEL (doit exister dans la Bible Louis Segond 1910)
2. Format de réponse UNIQUEMENT en JSON :
{
  "bookId": "PSA",
  "chapter": 23,
  "verse": 4,
  "bibleText": "Texte exact du verset",
  "postContent": "Message d'encouragement (2-3 phrases max)",
  "theme": "thème principal"
}
3. Le post doit être en français, chaleureux, encourageant
4. Thèmes : espérance, force, paix, amour de Dieu, persévérance
5. TON : Doux, matinal, édifiant — "Le Seigneur est ma lumière"
6. NE PAS inventer de verset. Utilise des versets BIEN CONNUS.
7. Pour les Psaumes, utilise le livre PSA`,

  evening: `Tu es un pasteur qui rédige des publications de réflexion du soir pour l'application Lumina.

RÈGLES STRICTES :
1. Choisis UN verset biblique RÉEL pour la méditation du soir
2. Format de réponse UNIQUEMENT en JSON :
{
  "bookId": "PSA",
  "chapter": 4,
  "verse": 8,
  "bibleText": "Texte exact du verset",
  "postContent": "Message de réflexion du soir (2-3 phrases max)",
  "theme": "thème principal"
}
3. TON : Apaisant, contemplatif — "Je me couche et je dors en paix"
4. Thèmes : paix, confiance, protection divine, gratitude
5. NE PAS inventer de verset. Utilise des versets BIEN CONNUS.
6. Pour les Psaumes, utilise le livre PSA`
};

const CRITIC_PROMPT = `Tu es un réviseur théologique. Analyse cette publication et vérifie :
1. Le verset existe-t-il vraiment ? (livre, chapitre, verset)
2. Le texte du verset est-il exact ?
3. Le message est-il théologiquement correct ?
4. Le ton est-il approprié ?

Réponds UNIQUEMENT en JSON :
{
  "isValid": true/false,
  "bibleTextCorrect": true/false,
  "theologyCorrect": true/false,
  "toneAppropriate": true/false,
  "corrections": "modifications à apporter si nécessaire (sinon vide)",
  "finalContent": "version finale du post",
  "score": 0-100
}
`;

// ── Fonctions utilitaires ─────────────────────────────────

function getToneForTime(): "morning" | "evening" {
  const hour = new Date().getHours();
  return hour < 12 ? "morning" : "evening";
}

// ── Appels API ────────────────────────────────────────────

async function callOpenRouter(prompt: AIPrompt): Promise<string> {
  if (!OPENROUTER_API_KEY) {
    throw new Error("OPENROUTER_API_KEY non configurée");
  }

  const response = await fetch(OPENROUTER_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
      "HTTP-Referer": "https://lumina.app",
      "X-Title": "Lumina AI Posts",
    },
    body: JSON.stringify({
      model: OPENROUTER_MODEL,
      messages: [
        { role: "system", content: prompt.systemPrompt },
        { role: "user", content: prompt.userPrompt },
      ],
      temperature: 0.7,
      max_tokens: 500,
    }),
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`OpenRouter API error (${response.status}): ${errorText}`);
  }

  const data = await response.json();
  return data.choices?.[0]?.message?.content || "";
}

async function callGemini(prompt: string, content: string): Promise<string> {
  if (!GEMINI_API_KEY) {
    console.warn("GEMINI_API_KEY non configurée, fallback sur GPT seul");
    return content;
  }

  const response = await fetch(`${GEMINI_URL}?key=${GEMINI_API_KEY}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      contents: [
        {
          role: "user",
          parts: [{ text: prompt }],
        },
        {
          role: "user",
          parts: [{ text: content }],
        },
      ],
      generationConfig: {
        temperature: 0.3,
        maxOutputTokens: 500,
      },
    }),
  });

  if (!response.ok) {
    console.warn(`Gemini API error (${response.status}), fallback sur GPT`);
    return content;
  }

  const data = await response.json();
  return data.candidates?.[0]?.content?.parts?.[0]?.text || content;
}

function extractJson(text: string): Record<string, unknown> {
  // Nettoyer la réponse : enlever les ```json et ```
  let cleaned = text.trim();
  cleaned = cleaned.replace(/^```(?:json)?\s*/i, "");
  cleaned = cleaned.replace(/\s*```$/i, "");

  try {
    return JSON.parse(cleaned);
  } catch {
    // Essayer de trouver un objet JSON dans la réponse
    const match = cleaned.match(/\{[\s\S]*\}/);
    if (match) {
      return JSON.parse(match[0]);
    }
    throw new Error("Impossible d'extraire le JSON de la réponse");
  }
}

// ── OPTION C : Récupérer un verset réel depuis la base Bible existante ──

async function getRealBibleVerse(supabase: ReturnType<typeof createClient>): Promise<{
  bookId: string;
  bookName: string;
  chapter: number;
  verse: number;
  text: string;
  reference: string;
}> {
  // Liste des livres de la Bible avec leur nombre de chapitres
  const bibleMetadata: Record<string, { name: string; chapterCount: number }> = {
    GEN: { name: "Genèse", chapterCount: 50 },
    EXO: { name: "Exode", chapterCount: 40 },
    LEV: { name: "Lévitique", chapterCount: 27 },
    NUM: { name: "Nombres", chapterCount: 36 },
    DEU: { name: "Deutéronome", chapterCount: 34 },
    JOS: { name: "Josué", chapterCount: 24 },
    JDG: { name: "Juges", chapterCount: 21 },
    RUT: { name: "Ruth", chapterCount: 4 },
    "1SA": { name: "1 Samuel", chapterCount: 31 },
    "2SA": { name: "2 Samuel", chapterCount: 24 },
    PSA: { name: "Psaumes", chapterCount: 150 },
    PRO: { name: "Proverbes", chapterCount: 31 },
    ISA: { name: "Ésaïe", chapterCount: 66 },
    JER: { name: "Jérémie", chapterCount: 52 },
    MAT: { name: "Matthieu", chapterCount: 28 },
    MRK: { name: "Marc", chapterCount: 16 },
    LUK: { name: "Luc", chapterCount: 24 },
    JHN: { name: "Jean", chapterCount: 21 },
    ACT: { name: "Actes", chapterCount: 28 },
    ROM: { name: "Romains", chapterCount: 16 },
    "1CO": { name: "1 Corinthiens", chapterCount: 16 },
    "2CO": { name: "2 Corinthiens", chapterCount: 13 },
    GAL: { name: "Galates", chapterCount: 6 },
    EPH: { name: "Éphésiens", chapterCount: 6 },
    PHP: { name: "Philippiens", chapterCount: 4 },
    COL: { name: "Colossiens", chapterCount: 4 },
    "1TH": { name: "1 Thessaloniciens", chapterCount: 5 },
    "2TH": { name: "2 Thessaloniciens", chapterCount: 3 },
    "1TI": { name: "1 Timothée", chapterCount: 6 },
    "2TI": { name: "2 Timothée", chapterCount: 4 },
    HEB: { name: "Hébreux", chapterCount: 13 },
    JAS: { name: "Jacques", chapterCount: 5 },
    "1PE": { name: "1 Pierre", chapterCount: 5 },
    "2PE": { name: "2 Pierre", chapterCount: 3 },
    "1JN": { name: "1 Jean", chapterCount: 5 },
    REV: { name: "Apocalypse", chapterCount: 22 },
  };

  // Sélectionner un livre aléatoire pondéré (Psaumes et Évangiles plus souvent)
  const weightedBooks = ["PSA", "PSA", "PSA", "MAT", "JHN", "ROM", "PRO", "ISA", "PHP", "EPH", "GEN", "JER"];
  const bookId = weightedBooks[Math.floor(Math.random() * weightedBooks.length)];
  const bookInfo = bibleMetadata[bookId];
  
  if (!bookInfo) {
    return {
      bookId: "PSA",
      bookName: "Psaumes",
      chapter: 23,
      verse: 4,
      text: "L'Éternel est mon berger: je ne manquerai de rien.",
      reference: "Psaumes 23:4",
    };
  }

  const chapterNum = Math.floor(Math.random() * bookInfo.chapterCount) + 1;

  // OPTION C : Les versets bibliques sont stockés côté client (Isar), pas dans Supabase.
  // On utilise bible-api.com (Louis Segond 1910) comme source primaire de versets réels.
  try {
    const url = `https://bible-api.com/${bookId}+${chapterNum}?translation=ls1910`;
    const response = await fetch(url);
    if (response.ok) {
      const data = await response.json();
      const verses = data.verses as Array<{ text: string }> | undefined;
      if (verses && verses.length > 0) {
        const verseNum = Math.floor(Math.random() * verses.length) + 1;
        const verseText = verses[verseNum - 1].text;
        return {
          bookId,
          bookName: bookInfo.name,
          chapter: chapterNum,
          verse: verseNum,
          text: verseText,
          reference: `${bookInfo.name} ${chapterNum}:${verseNum}`,
        };
      }
    }
  } catch (e) {
    console.warn(`[generate-ai-post] Bible API fallback failed:`, e);
  }

  // Dernier fallback : verset connu
  return {
    bookId: "PSA",
    bookName: "Psaumes",
    chapter: 23,
    verse: 4,
    text: "Quand je marche dans la vallée de l'ombre de la mort, je ne crains aucun mal, car tu es avec moi.",
    reference: "Psaumes 23:4",
  };
}

// ── Fonction principale ───────────────────────────────────

Deno.serve(async (req: Request) => {
  try {
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const body = await req.json().catch(() => ({}));
    const tone = body.tone || getToneForTime();
    const churchId = body.church_id || CHURCH_ID;

    // Créer le client Supabase
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

    // OPTION C : Récupérer un verset RÉEL depuis la base Bible existante
    console.log(`[generate-ai-post] Étape 0: Récupération d'un verset réel (Option C)`);
    const realVerse = await getRealBibleVerse(supabase);
    console.log(`[generate-ai-post] Verset choisi: ${realVerse.reference}`);

    // Étape 1 : GPT-100B génère le post À PARTIR du verset réel
    console.log(`[generate-ai-post] Étape 1: GPT-100B génération autour du verset réel (tone=${tone})`);
    
    const gptResult = await callOpenRouter({
      systemPrompt: SYSTEM_PROMPTS[tone as keyof typeof SYSTEM_PROMPTS],
      userPrompt: `Voici un verset biblique RÉEL à utiliser :

Référence: ${realVerse.reference}
Texte: "${realVerse.text}"

Rédige un post ${tone === "morning" ? "matinal d'encouragement" : "de réflexion du soir"} inspiré par CE verset.

RÉPONDS UNIQUEMENT EN JSON :
{
  "postContent": "Message (2-3 phrases max)",
  "theme": "thème principal"
}`,
    });

    const parsed = extractJson(gptResult);
    const postContent = parsed.postContent as string;
    const theme = parsed.theme as string;

    if (!postContent) {
      throw new Error("Réponse GPT incomplète");
    }

    // Étape 2 : Gemini critique et améliore
    console.log(`[generate-ai-post] Étape 2: Gemini critique`);
    const criticResult = await callGemini(
      CRITIC_PROMPT,
      `Publication à réviser :
Verset (RÉEL): ${realVerse.reference}
Texte: "${realVerse.text}"
Message: ${postContent}
Thème: ${theme}`
    );

    // Essayer de parser la réponse de Gemini
    let finalContent = postContent;
    let isValid = true;

    try {
      const criticParsed = extractJson(criticResult);
      if (criticParsed.finalContent && typeof criticParsed.finalContent === "string") {
        finalContent = criticParsed.finalContent;
      }
      isValid = criticParsed.isValid !== false;
    } catch {
      console.warn("[generate-ai-post] Impossible de parser la critique Gemini, utilisation du résultat GPT");
    }

    const verseRef = realVerse.reference;
    const finalBibleText = realVerse.text;

    // Étape 3 : Créer le post dans social_posts
    console.log(`[generate-ai-post] Étape 3: Création du post`);

    const aiAuthorId = "00000000-0000-0000-0000-000000000001"; // Compte système IA

    const { data: post, error: postError } = await supabase
      .from("social_posts")
      .insert({
        author_id: aiAuthorId,
        content: finalContent,
        media_urls: [],
        church_id: churchId,
        visibility: 'CHURCH',
        is_ai_generated: true,
        ai_bible_verse: verseRef,
        ai_bible_text: finalBibleText,
        status: "published",
        likes_count: 0,
        comments_count: 0,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .select()
      .single();

    if (postError) {
      throw new Error(`Erreur création post: ${postError.message}`);
    }

    console.log(`[generate-ai-post] ✅ Post créé: ${post.id} - ${verseRef}`);

    // Journaliser dans la table de queue
    await supabase.from("ai_queue").insert({
      task_type: "generate_post",
      status: "done",
      model_used: `${OPENROUTER_MODEL} + ${GEMINI_MODEL}`,
      result: {
        post_id: post.id,
        verse_ref: verseRef,
        tone,
        theme,
        validated_by_gemini: isValid,
      },
    });

    return new Response(
      JSON.stringify({
        success: true,
        post_id: post.id,
        verse: verseRef,
        content: finalContent,
        tone,
        theme,
      }),
      {
        headers: { "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error("[generate-ai-post] Error:", error);

    // Journaliser l'échec
    try {
      const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
      await supabase.from("ai_queue").insert({
        task_type: "generate_post",
        status: "failed",
        error: String(error),
        retry_count: 0,
      });
    } catch {
      // Silence
    }

    return new Response(
      JSON.stringify({
        success: false,
        error: String(error),
      }),
      {
        headers: { "Content-Type": "application/json" },
        status: 500,
      }
    );
  }
});
