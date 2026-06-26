// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProofImageImpl _$$ProofImageImplFromJson(Map<String, dynamic> json) =>
    _$ProofImageImpl(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      storagePath: json['storage_path'] as String,
      originalFilename: json['original_filename'] as String?,
      sealHash: json['seal_hash'] as String?,
      sealSignature: json['seal_signature'] as String?,
      sealedAt: json['sealed_at'] == null
          ? null
          : DateTime.parse(json['sealed_at'] as String),
      signingKeyId: json['signing_key_id'] as String?,
      status: $enumDecodeNullable(_$ValidationStatusEnumMap, json['status']) ??
          ValidationStatus.pending,
      validatedBy: json['validated_by'] as String?,
      validatedAt: json['validated_at'] == null
          ? null
          : DateTime.parse(json['validated_at'] as String),
      rejectionReason: json['rejection_reason'] as String?,
      mimeType: json['mime_type'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ProofImageImplToJson(_$ProofImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaction_id': instance.transactionId,
      'storage_path': instance.storagePath,
      'original_filename': instance.originalFilename,
      'seal_hash': instance.sealHash,
      'seal_signature': instance.sealSignature,
      'sealed_at': instance.sealedAt?.toIso8601String(),
      'signing_key_id': instance.signingKeyId,
      'status': _$ValidationStatusEnumMap[instance.status]!,
      'validated_by': instance.validatedBy,
      'validated_at': instance.validatedAt?.toIso8601String(),
      'rejection_reason': instance.rejectionReason,
      'mime_type': instance.mimeType,
      'file_size': instance.fileSize,
      'metadata': instance.metadata,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$ValidationStatusEnumMap = {
  ValidationStatus.pending: 'pending',
  ValidationStatus.validated: 'validated',
  ValidationStatus.rejected: 'rejected',
};
