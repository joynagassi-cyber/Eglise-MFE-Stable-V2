import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/app_date_time.dart';

class SealRepository {
  final SupabaseClient _supabase;

  SealRepository(this._supabase);

  /// Scelle une transaction avec une signature cryptographique
  Future<void> sealTransaction({
    required String transactionId,
    required String payloadHash,
    required String signature,
  }) async {
    await _supabase.from('transaction_seals').insert({
      'transaction_id': transactionId,
      'payload_hash': payloadHash,
      'signature': signature,
      'algorithm': 'ECDSA-P256-SHA256',
      'signed_at': AppDateTime.nowIso(),
    });

    // Mettre à jour le statut de la transaction
    await _supabase.from('transactions').update({
      'status': 'sealed',
      'sealed_at': AppDateTime.nowIso(),
    }).eq('id', transactionId);
  }

  /// Récupère le sceau d'une transaction
  Future<Map<String, dynamic>?> getSeal(String transactionId) async {
    final data = await _supabase
        .from('transaction_seals')
        .select()
        .eq('transaction_id', transactionId)
        .maybeSingle();
    return data;
  }
}