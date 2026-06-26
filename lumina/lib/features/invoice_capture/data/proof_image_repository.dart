import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/proof_image.dart';

class ProofImageRepository {
  final SupabaseClient _supabase;

  ProofImageRepository(this._supabase);

  /// Sauvegarde les métadonnées d'une image de preuve
  Future<ProofImage> saveProofImage(ProofImage image) async {
    final response = await _supabase
        .from('proof_images')
        .insert(image.toJson())
        .select()
        .single();

    return ProofImage.fromJson(response);
  }

  /// Récupère toutes les images liées à une transaction
  Future<List<ProofImage>> getImagesForTransaction(String transactionId) async {
    final response = await _supabase
        .from('proof_images')
        .select()
        .eq('transaction_id', transactionId);

    return (response as List).map((e) => ProofImage.fromJson(e)).toList();
  }

  /// Supprime une image (métadonnées seulement, le fichier doit être géré via Storage)
  Future<void> deleteProofImage(String imageId) async {
    await _supabase.from('proof_images').delete().eq('id', imageId);
  }
}