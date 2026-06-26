// lib/features/finance/domain/entities/proof_image.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/validation_status.dart';

part 'proof_image.freezed.dart';
part 'proof_image.g.dart';

/// Preuve photographique scellée cryptographiquement (IMAGIR)
/// Reflète la table `proof_images` Supabase
@freezed
class ProofImage with _$ProofImage {
  const ProofImage._();

  const factory ProofImage({
    required String id,
    required String transactionId,
    required String storagePath, // Chemin dans Supabase Storage
    String? originalFilename,

    // Scellement cryptographique ECDSA P-256
    String? sealHash, // SHA-256 du contenu
    String? sealSignature, // Signature ECDSA
    DateTime? sealedAt,
    String? signingKeyId, // ID de la clé utilisée
    // Validation
    @Default(ValidationStatus.pending) ValidationStatus status,
    String? validatedBy,
    DateTime? validatedAt,
    String? rejectionReason,

    // Métadonnées
    String? mimeType,
    int? fileSize,
    Map<String, dynamic>? metadata, // EXIF, GPS, etc.
    // Timestamps
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ProofImage;

  factory ProofImage.fromJson(Map<String, dynamic> json) =>
      _$ProofImageFromJson(json);

  /// La preuve est scellée cryptographiquement
  bool get isSealed => sealHash != null && sealSignature != null;

  /// La preuve est validée
  bool get isValidated => status == ValidationStatus.validated;

  /// URL publique de la preuve (à construire avec Storage)
  String getPublicUrl(String supabaseUrl) =>
      '$supabaseUrl/storage/v1/object/public/$storagePath';
}