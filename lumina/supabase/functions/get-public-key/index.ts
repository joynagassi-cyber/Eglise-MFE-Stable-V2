// supabase/functions/get-public-key/index.ts
// Edge Function pour exposer la clé publique de vérification IMAGIR
// Permet la vérification publique des signatures cryptographiques

import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";

const corsHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req: Request) => {
    // Handle CORS preflight
    if (req.method === "OPTIONS") {
        return new Response(null, { headers: corsHeaders });
    }

    try {
        // Créer client Supabase service role
        const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
        const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
        const supabase = createClient(supabaseUrl, serviceRoleKey);

        // Récupérer la clé publique active depuis signing_keys
        const { data: keyData, error: keyError } = await supabase
            .from("signing_keys")
            .select("id, algorithm, public_key_pem, activated_at")
            .eq("is_active", true)
            .order("activated_at", { ascending: false })
            .limit(1)
            .single();

        if (keyError || !keyData) {
            return new Response(
                JSON.stringify({
                    error: "No active signing key found",
                    code: "KEY_NOT_FOUND",
                }),
                {
                    status: 404,
                    headers: { ...corsHeaders, "Content-Type": "application/json" },
                }
            );
        }

        // Retourner la clé publique au format standard
        const response = {
            keyId: keyData.id,
            algorithm: keyData.algorithm,
            publicKeyPem: keyData.public_key_pem,
            activatedAt: keyData.activated_at,
            usage: "verification",
            format: "PEM",
            // Instructions de vérification
            verificationGuide: {
                step1: "Récupérer le hash SHA-256 du document original",
                step2: "Récupérer la signature depuis proof_images.seal_signature",
                step3: "Vérifier avec la clé publique en utilisant ECDSA P-256",
                step4: "Comparer le timestamp sealed_at avec le payload",
            },
        };

        return new Response(JSON.stringify(response), {
            status: 200,
            headers: {
                ...corsHeaders,
                "Content-Type": "application/json",
                "Cache-Control": "public, max-age=3600", // Cache 1h
            },
        });
    } catch (error) {
        console.error("get-public-key error:", error);
        return new Response(
            JSON.stringify({
                error: "Internal server error",
                message: error.message,
            }),
            {
                status: 500,
                headers: { ...corsHeaders, "Content-Type": "application/json" },
            }
        );
    }
});
