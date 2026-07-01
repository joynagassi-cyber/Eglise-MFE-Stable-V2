import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

interface SealRequest {
  file_id: string;
}

serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) throw new Error('Missing authorization');
    
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    );
    
    const { data: { user }, error: authError } = await supabase.auth.getUser(
      authHeader.replace('Bearer ', '')
    );
    if (authError || !user) throw new Error('Unauthorized');
    
    const hasPermission = await checkRole(supabase, user.id, ['admin', 'treasurer']);
    if (!hasPermission) throw new Error('Forbidden');
    
    const { file_id }: SealRequest = await req.json();
    
    const { data: file, error } = await supabase
      .from('drive_files')
      .select('*')
      .eq('id', file_id)
      .eq('status', 'validated')
      .eq('entity_type', 'invoice')
      .single();
    
    if (error || !file) throw new Error('File not found or not validated');
    
    const signature = await generateSignature(file.checksum_sha256);
    
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const newPath = `02_FINANCE/FACTURES/VALIDEES/${year}/${month}`;
    
    const { error: updateError } = await supabase
      .from('drive_files')
      .update({
        status: 'sealed',
        signature_ecdsa: signature,
        sealed_at: now.toISOString(),
        sealed_by: user.id,
        drive_folder_path: newPath
      })
      .eq('id', file_id);
    
    if (updateError) throw updateError;
    
    await supabase.from('drive_audit_logs').insert({
      file_id,
      action: 'seal',
      actor_id: user.id,
      actor_ip: req.headers.get('x-forwarded-for'),
      metadata: { signature_length: signature.length }
    });
    
    return new Response(JSON.stringify({
      success: true,
      sealed: true,
      signature
    }), { status: 200, headers: { 'Content-Type': 'application/json' } });
    
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), 
      { status: 400, headers: { 'Content-Type': 'application/json' } });
  }
});

async function checkRole(supabase: any, userId: string, roles: string[]): Promise<boolean> {
  const { data } = await supabase.from('user_roles').select('role').eq('user_id', userId).in('role', roles).single();
  return !!data;
}

async function generateSignature(checksum: string): Promise<string> {
  const encoder = new TextEncoder();
  const data = encoder.encode(checksum);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return btoa(String.fromCharCode(...hashArray));
}
