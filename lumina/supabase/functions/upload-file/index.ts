import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

interface UploadRequest {
  entity_type: string;
  entity_id: string;
  file_base64: string;
  filename: string;
  mime_type: string;
  checksum_sha256: string;
  encryption_metadata?: { iv: string; algorithm: string; };
}

// Calcule la taille exacte en bytes d'une chaine Base64
// en tenant compte du padding (=) et du prefixe data URI eventuel.
function getBase64ByteSize(base64: string): number {
  const clean = base64.includes(',') ? base64.split(',')[1] : base64;
  const padding = (clean.match(/=/g) || []).length;
  return Math.floor((clean.length * 3) / 4) - padding;
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
    
    const body: UploadRequest = await req.json();
    
    const canUpload = await validateUploadPermission(supabase, user.id, body.entity_type);
    if (!canUpload) throw new Error('Forbidden');
    
    const { data: existing } = await supabase
      .from('drive_files')
      .select('id, drive_file_id')
      .eq('checksum_sha256', body.checksum_sha256)
      .eq('entity_id', body.entity_id)
      .single();
    
    if (existing) {
      return new Response(JSON.stringify({
        success: true,
        file_id: existing.id,
        drive_file_id: existing.drive_file_id,
        deduplicated: true
      }), { status: 200, headers: { 'Content-Type': 'application/json' } });
    }
    
    // Generer un ID de fichier cryptographiquement sur (crypto.randomUUID)
    const driveFileId = `DRIVE_${crypto.randomUUID().replace(/-/g, '').substring(0, 12).toUpperCase()}`;
    
    const { data: fileRecord, error: dbError } = await supabase
      .from('drive_files')
      .insert({
        entity_type: body.entity_type,
        entity_id: body.entity_id,
        drive_file_id: driveFileId,
        drive_folder_path: getFolderPath(body.entity_type),
        original_filename: body.filename,
        mime_type: body.mime_type,
        file_size_bytes: getBase64ByteSize(body.file_base64),
        checksum_sha256: body.checksum_sha256,
        uploaded_by: user.id,
        encryption_key_id: body.encryption_metadata?.iv,
        metadata: body.encryption_metadata || {}
      })
      .select()
      .single();
    
    if (dbError) throw dbError;
    
    await supabase.from('drive_audit_logs').insert({
      file_id: fileRecord.id,
      action: 'upload',
      actor_id: user.id,
      actor_ip: req.headers.get('x-forwarded-for'),
      metadata: { filename: body.filename }
    });
    
    return new Response(JSON.stringify({
      success: true,
      file_id: fileRecord.id,
      drive_file_id: driveFileId
    }), { status: 201, headers: { 'Content-Type': 'application/json' } });
    
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), 
      { status: 400, headers: { 'Content-Type': 'application/json' } });
  }
});

async function validateUploadPermission(
  supabase: any,
  userId: string,
  entityType: string,
  entityId: string
): Promise<boolean> {
  if (entityType === 'member_photo') {
    // L'utilisateur peut uploader uniquement sa propre photo
    if (userId === entityId) return true;
    // Ou s'il est admin / super_admin
    const { data } = await supabase
      .from('user_roles')
      .select('role')
      .eq('user_id', userId)
      .in('role', ['admin', 'super_admin'])
      .single();
    return !!data;
  }
  // Pour les autres types (invoice, justificatif) : admin ou treasurer
  const { data } = await supabase
    .from('user_roles')
    .select('role')
    .eq('user_id', userId)
    .in('role', ['admin', 'treasurer'])
    .single();
  return !!data;
}

function getFolderPath(entityType: string): string {
  const paths: Record<string, string> = {
    'member_photo': '01_MEMBRES/ACTIFS',
    'invoice': '02_FINANCE/FACTURES/BROUILLONS',
    'justificatif': '02_FINANCE/PIECES_JUSTIFICATIVES'
  };
  return paths[entityType] || '99_SYSTEM';
}
