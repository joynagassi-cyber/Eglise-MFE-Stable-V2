/// <reference types="@cloudflare/workers-types" />

interface Env {
  AI: any;
  SUPABASE_URL: string;
  SUPABASE_SERVICE_ROLE_KEY: string;
  ALLOWED_ORIGINS: string;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders(request, env) });
    }

    if (request.method !== 'POST') {
      return jsonResponse({ error: 'Method not allowed' }, 405, env);
    }

    const auth = request.headers.get('Authorization');
    if (!auth) return jsonResponse({ error: 'Unauthorized' }, 401, env);

    const user = await verifyToken(auth, env);
    if (!user) return jsonResponse({ error: 'Invalid token' }, 401, env);

    try {
      const formData = await request.formData();
      const file = formData.get('file') as File;

      if (!file) {
        return jsonResponse({ error: 'No file provided' }, 400, env);
      }

      const imageBuffer = await file.arrayBuffer();
      const imageArray = Array.from(new Uint8Array(imageBuffer));

      const result = await env.AI.run('@cf/meta/llama-3.2-11b-vision-instruct', {
        image: imageArray,
        prompt: `Extract invoice data in JSON format with these exact fields:
{
  "vendor": "vendor name",
  "date": "YYYY-MM-DD",
  "amount": 0.00,
  "currency": "CDF",
  "items": [{"description": "", "quantity": 0, "price": 0}],
  "tax": 0.00,
  "total": 0.00
}
Only return valid JSON, no additional text.`,
        max_tokens: 512
      });

      return jsonResponse({ success: true, data: result }, 200, env);
    } catch (error: any) {
      return jsonResponse({ error: error.message }, 500, env);
    }
  }
};

async function verifyToken(auth: string, env: Env) {
  const token = auth.replace('Bearer ', '');
  const res = await fetch(`${env.SUPABASE_URL}/auth/v1/user`, {
    headers: { Authorization: `Bearer ${token}` }
  });
  return res.ok ? await res.json() : null;
}

function corsHeaders(request?: Request, env?: Env) {
  if (!env || !request) {
    return {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Vary': 'Origin',
    };
  }

  const allowedOrigins = (env.ALLOWED_ORIGINS || '').split(',').map(o => o.trim());
  const origin = request.headers.get('Origin') || '';

  const finalOrigin = allowedOrigins.includes(origin) ? origin : (allowedOrigins[0] || '');

  return {
    'Access-Control-Allow-Origin': finalOrigin,
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Vary': 'Origin',
  };
}

function jsonResponse(data: any, status = 200, env?: Env) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json', ...corsHeaders(undefined, env) }
  });
}
