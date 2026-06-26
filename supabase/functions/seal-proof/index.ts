// Supabase Edge Function: seal-proof
// Scellement cryptographique des preuves photographiques (ECDSA P-256)
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

interface SealRequest {
  proof_image_id: string;
}

interface SealPayload {
  image_id: string;
  sha256_hash: string;
  transaction_id: string | null;
  uploaded_by: string;
  sealed_at: string;
  algorithm: string;
}

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    );

    // Get user from JWT
    const { data: { user }, error: authError } = await supabaseClient.auth.getUser();
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const { proof_image_id }: SealRequest = await req.json();

    if (!proof_image_id) {
      return new Response(JSON.stringify({ error: 'proof_image_id is required' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // Fetch the proof image record
    const { data: proofImage, error: fetchError } = await supabaseClient
      .from('proof_images')
      .select('*')
      .eq('id', proof_image_id)
      .single();

    if (fetchError || !proofImage) {
      return new Response(JSON.stringify({ error: 'Proof image not found' }), {
        status: 404,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // Check if already sealed
    if (proofImage.seal_signature) {
      return new Response(JSON.stringify({ error: 'Image already sealed', sealed_at: proofImage.sealed_at }), {
        status: 409,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // Create Seal Payload
    const sealPayload: SealPayload = {
      image_id: proofImage.id,
      sha256_hash: proofImage.sha256_hash,
      transaction_id: proofImage.transaction_id,
      uploaded_by: proofImage.uploaded_by,
      sealed_at: new Date().toISOString(),
      algorithm: 'ECDSA-P256-SHA256',
    };

    // Generate ECDSA P-256 Signature
    const privateKeyPem = Deno.env.get('SEAL_PRIVATE_KEY_PEM');
    if (!privateKeyPem) {
      return new Response(JSON.stringify({ error: 'Signing key not configured' }), {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // Import private key
    const pemContents = privateKeyPem.replace(/-----BEGIN PRIVATE KEY-----|-----END PRIVATE KEY-----|\n/g, '');
    const binaryDer = Uint8Array.from(atob(pemContents), c => c.charCodeAt(0));

    const privateKey = await crypto.subtle.importKey(
      'pkcs8',
      binaryDer,
      { name: 'ECDSA', namedCurve: 'P-256' },
      false,
      ['sign']
    );

    // Sign the payload
    const encoder = new TextEncoder();
    const payloadBytes = encoder.encode(JSON.stringify(sealPayload));
    const signatureBytes = await crypto.subtle.sign(
      { name: 'ECDSA', hash: 'SHA-256' },
      privateKey,
      payloadBytes
    );

    // Convert to base64
    const signatureBase64 = btoa(String.fromCharCode(...new Uint8Array(signatureBytes)));

    // Get active signing key ID
    const { data: signingKey } = await supabaseClient
      .from('signing_keys')
      .select('id')
      .eq('is_active', true)
      .single();

    // Update the proof_images record
    const { error: updateError } = await supabaseClient
      .from('proof_images')
      .update({
        seal_signature: signatureBase64,
        seal_payload: sealPayload,
        seal_algorithm: 'ECDSA-P256-SHA256',
        seal_key_id: signingKey?.id || 'default_key',
        sealed_at: sealPayload.sealed_at,
      })
      .eq('id', proof_image_id);

    if (updateError) {
      return new Response(JSON.stringify({ error: 'Failed to save seal', details: updateError.message }), {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // Log the sealing action
    await supabaseClient.from('audit_logs').insert({
      actor_id: user.id,
      action: 'SEAL',
      entity_type: 'proof_image',
      entity_id: proof_image_id,
      new_value: sealPayload,
    });

    return new Response(JSON.stringify({
      success: true,
      seal: {
        signature: signatureBase64,
        payload: sealPayload,
        key_id: signingKey?.id || 'default_key',
      },
    }), {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });

  } catch (error) {
    return new Response(JSON.stringify({ error: 'Internal server error', message: (error as Error).message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }
});
