/// <reference types="@cloudflare/workers-types" />

interface Env {
  STORAGE: R2Bucket;
  SUPABASE_URL: string;
  SUPABASE_SERVICE_ROLE_KEY: string;
  SUPABASE_ANON_KEY: string;
  MAX_FILE_SIZE_MB: string;
  ALLOWED_MIME_TYPES: string;
  ALLOWED_ORIGINS: string;
}

interface User {
  id: string;
  email?: string;
  user_metadata?: {
    church_id?: string;
  };
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    if (request.method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders(request, env) });
    }

    try {
      if (url.pathname === '/upload' && request.method === 'POST') {
        return await handleUpload(request, env);
      }

      if (url.pathname.startsWith('/download/') && request.method === 'GET') {
        return await handleDownload(request, env);
      }

      if (url.pathname === '/delete' && request.method === 'DELETE') {
        return await handleDelete(request, env);
      }

      return jsonResponse({ error: 'Not found' }, 404, env);
    } catch (error: any) {
      return jsonResponse({ error: error.message }, 500, env);
    }
  }
};

async function handleUpload(request: Request, env: Env): Promise<Response> {
  const auth = request.headers.get('Authorization');
  if (!auth) return jsonResponse({ error: 'Unauthorized' }, 401, env);

  const user = await verifyToken(auth, env);
  if (!user) return jsonResponse({ error: 'Invalid token' }, 401, env);

  const formData = await request.formData();
  const file = formData.get('file') as File;
  const entityType = formData.get('entity_type') as string;
  const entityId = formData.get('entity_id') as string;
  const churchId = formData.get('church_id') as string;

  if (!file || !entityType || !entityId || !churchId) {
    return jsonResponse({ error: 'Missing required fields' }, 400, env);
  }

  // Security Check: Verify user belongs to the target church if church_id is present in metadata
  if (user.user_metadata?.church_id && user.user_metadata.church_id !== churchId) {
    return jsonResponse({ error: 'Forbidden: church_id mismatch' }, 403, env);
  }

  const maxSize = parseInt(env.MAX_FILE_SIZE_MB) * 1024 * 1024;
  if (file.size > maxSize) {
    return jsonResponse({ error: 'File too large' }, 413, env);
  }

  const r2Key = `${churchId}/${entityType}/${entityId}/${Date.now()}_${file.name}`;

  await env.STORAGE.put(r2Key, file.stream(), {
    httpMetadata: {
      contentType: file.type,
    },
    customMetadata: {
      uploadedBy: user.id,
      entityType,
      entityId,
      originalName: file.name,
    }
  });

  const fileUrl = `${new URL(request.url).origin}/download/${r2Key}`;

  try {
    await saveMetadata(env, {
      r2_key: r2Key,
      entity_type: entityType,
      entity_id: entityId,
      original_filename: file.name,
      mime_type: file.type,
      file_size_bytes: file.size,
      uploaded_by: user.id,
      church_id: churchId,
    });
  } catch (error: any) {
    // Rollback the uploaded file if metadata failed
    await env.STORAGE.delete(r2Key);
    return jsonResponse({ error: `Metadata save failed: ${error.message}` }, 500, env);
  }

  return jsonResponse({ success: true, r2_key: r2Key, file_url: fileUrl }, 201, env);
}

async function handleDownload(request: Request, env: Env): Promise<Response> {
  const auth = request.headers.get('Authorization');
  if (!auth) return jsonResponse({ error: 'Unauthorized' }, 401, env);

  const user = await verifyToken(auth, env);
  if (!user) return jsonResponse({ error: 'Invalid token' }, 401, env);

  const url = new URL(request.url);
  const r2Key = url.pathname.replace('/download/', '');

  const object = await env.STORAGE.get(r2Key);
  if (!object) return jsonResponse({ error: 'File not found' }, 404, env);

  return new Response(object.body, {
    headers: {
      'Content-Type': object.httpMetadata?.contentType || 'application/octet-stream',
      'Cache-Control': 'public, max-age=31536000',
      ...corsHeaders(request, env),
    }
  });
}

async function handleDelete(request: Request, env: Env): Promise<Response> {
  const auth = request.headers.get('Authorization');
  if (!auth) return jsonResponse({ error: 'Unauthorized' }, 401, env);

  const user = await verifyToken(auth, env);
  if (!user) return jsonResponse({ error: 'Invalid token' }, 401, env);

  const { r2_key } = await request.json() as { r2_key: string };
  await env.STORAGE.delete(r2_key);

  return jsonResponse({ success: true }, 200, env);
}

async function verifyToken(auth: string, env: Env): Promise<User | null> {
  const token = auth.replace('Bearer ', '');
  const res = await fetch(`${env.SUPABASE_URL}/auth/v1/user`, {
    headers: { Authorization: `Bearer ${token}` }
  });
  return res.ok ? await res.json() as User : null;
}

async function saveMetadata(env: Env, data: any) {
  const response = await fetch(`${env.SUPABASE_URL}/rest/v1/drive_files`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'apikey': env.SUPABASE_ANON_KEY,
      'Authorization': `Bearer ${env.SUPABASE_SERVICE_ROLE_KEY}`,
      'Prefer': 'return=minimal'
    },
    body: JSON.stringify(data)
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`Supabase API responded with ${response.status}: ${errorText}`);
  }
}

function corsHeaders(request?: Request, env?: Env) {
  if (!env || !request) {
    return {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Vary': 'Origin',
    };
  }

  const allowedOrigins = (env.ALLOWED_ORIGINS || '').split(',').map(o => o.trim());
  const origin = request.headers.get('Origin') || '';

  const finalOrigin = allowedOrigins.includes(origin) ? origin : (allowedOrigins[0] || '');

  return {
    'Access-Control-Allow-Origin': finalOrigin,
    'Access-Control-Allow-Methods': 'GET, POST, DELETE, OPTIONS',
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
