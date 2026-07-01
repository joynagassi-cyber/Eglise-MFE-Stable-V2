import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

const UPSTASH_URL = Deno.env.get('UPSTASH_REDIS_REST_URL')!;
const UPSTASH_TOKEN = Deno.env.get('UPSTASH_REDIS_REST_TOKEN')!;

interface RateLimitConfig {
  maxAttempts: number;
  windowSeconds: number;
}

const configs: Record<string, RateLimitConfig> = {
  login: { maxAttempts: 5, windowSeconds: 300 },
  register: { maxAttempts: 3, windowSeconds: 3600 },
};

async function checkRateLimit(
  key: string,
  config: RateLimitConfig
): Promise<{ allowed: boolean; remaining: number; resetAt: number }> {
  const redisKey = `ratelimit:${key}`;
  
  const incrResponse = await fetch(`${UPSTASH_URL}/incr/${redisKey}`, {
    headers: { Authorization: `Bearer ${UPSTASH_TOKEN}` },
  });
  const { result: count } = await incrResponse.json();
  
  if (count === 1) {
    await fetch(`${UPSTASH_URL}/expire/${redisKey}/${config.windowSeconds}`, {
      headers: { Authorization: `Bearer ${UPSTASH_TOKEN}` },
    });
  }
  
  const allowed = count <= config.maxAttempts;
  const remaining = Math.max(0, config.maxAttempts - count);
  
  const ttlResponse = await fetch(`${UPSTASH_URL}/ttl/${redisKey}`, {
    headers: { Authorization: `Bearer ${UPSTASH_TOKEN}` },
  });
  const { result: ttl } = await ttlResponse.json();
  const resetAt = Date.now() + (ttl * 1000);
  
  return { allowed, remaining, resetAt };
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      },
    });
  }

  try {
    const { action, identifier } = await req.json();
    
    const config = configs[action];
    if (!config) {
      return new Response(
        JSON.stringify({ error: 'Invalid action' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }
    
    const result = await checkRateLimit(`${action}:${identifier}`, config);
    
    if (!result.allowed) {
      return new Response(
        JSON.stringify({
          error: 'Too many attempts',
          message: `Trop de tentatives. Réessayez dans ${Math.ceil((result.resetAt - Date.now()) / 1000 / 60)} minutes.`,
          resetAt: result.resetAt,
        }),
        { 
          status: 429,
          headers: {
            'Content-Type': 'application/json',
            'X-RateLimit-Limit': config.maxAttempts.toString(),
            'X-RateLimit-Remaining': result.remaining.toString(),
            'X-RateLimit-Reset': result.resetAt.toString(),
          }
        }
      );
    }
    
    return new Response(
      JSON.stringify({
        allowed: true,
        remaining: result.remaining,
        resetAt: result.resetAt,
      }),
      { 
        status: 200,
        headers: {
          'Content-Type': 'application/json',
          'X-RateLimit-Limit': config.maxAttempts.toString(),
          'X-RateLimit-Remaining': result.remaining.toString(),
          'X-RateLimit-Reset': result.resetAt.toString(),
        }
      }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});
