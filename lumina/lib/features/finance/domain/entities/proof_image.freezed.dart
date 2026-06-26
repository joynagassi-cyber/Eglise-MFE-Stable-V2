// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proof_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ProofImage _$ProofImageFromJson(Map<String, dynamic> json) {
  return _ProofImage.fromJson(json);
}

/// @nodoc
mixin _$ProofImage {
  String get id => throw _privateConstructorUsedError;
  String get transactionId => throw _privateConstructorUsedError;
  String get storagePath =>
      throw _privateConstructorUsedError; // Chemin dans Supabase Storage
  String? get originalFilename =>
      throw _privateConstructorUsedError; // Scellement cryptographique ECDSA P-256
  String? get sealHash =>
      throw _privateConstructorUsedError; // SHA-256 du contenu
  String? get sealSignature =>
      throw _privateConstructorUsedError; // Signature ECDSA
  DateTime? get sealedAt => throw _privateConstructorUsedError;
  String? get signingKeyId =>
      throw _privateConstructorUsedError; // ID de la clé utilisée
// Validation
  ValidationStatus get status => throw _privateConstructorUsedError;
  String? get validatedBy => throw _privateConstructorUsedError;
  DateTime? get validatedAt => throw _privateConstructorUsedError;
  String? get rejectionReason =>
      throw _privateConstructorUsedError; // Métadonnées
  String? get mimeType => throw _privateConstructorUsedError;
  int? get fileSize => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata =>
      throw _privateConstructorUsedError; // EXIF, GPS, etc.
// Timestamps
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProofImageCopyWith<ProofImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProofImageCopyWith<$Res> {
  factory $ProofImageCopyWith(
          ProofImage value, $Res Function(ProofImage) then) =
      _$ProofImageCopyWithImpl<$Res, ProofImage>;
  @useResult
  $Res call(
      {String id,
      String transactionId,
      String storagePath,
      String? originalFilename,
      String? sealHash,
      String? sealSignature,
      DateTime? sealedAt,
      String? signingKeyId,
      ValidationStatus status,
      String? validatedBy,
      DateTime? validatedAt,
      String? rejectionReason,
      String? mimeType,
      int? fileSize,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ProofImageCopyWithImpl<$Res, $Val extends ProofImage>
    implements $ProofImageCopyWith<$Res> {
  _$ProofImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? storagePath = null,
    Object? originalFilename = freezed,
    Object? sealHash = freezed,
    Object? sealSignature = freezed,
    Object? sealedAt = freezed,
    Object? signingKeyId = freezed,
    Object? status = null,
    Object? validatedBy = freezed,
    Object? validatedAt = freezed,
    Object? rejectionReason = freezed,
    Object? mimeType = freezed,
    Object? fileSize = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      storagePath: null == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      originalFilename: freezed == originalFilename
          ? _value.originalFilename
          : originalFilename // ignore: cast_nullable_to_non_nullable
              as String?,
      sealHash: freezed == sealHash
          ? _value.sealHash
          : sealHash // ignore: cast_nullable_to_non_nullable
              as String?,
      sealSignature: freezed == sealSignature
          ? _value.sealSignature
          : sealSignature // ignore: cast_nullable_to_non_nullable
              as String?,
      sealedAt: freezed == sealedAt
          ? _value.sealedAt
          : sealedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      signingKeyId: freezed == signingKeyId
          ? _value.signingKeyId
          : signingKeyId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ValidationStatus,
      validatedBy: freezed == validatedBy
          ? _value.validatedBy
          : validatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      validatedAt: freezed == validatedAt
          ? _value.validatedAt
          : validatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProofImageImplCopyWith<$Res>
    implements $ProofImageCopyWith<$Res> {
  factory _$$ProofImageImplCopyWith(
          _$ProofImageImpl value, $Res Function(_$ProofImageImpl) then) =
      __$$ProofImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String transactionId,
      String storagePath,
      String? originalFilename,
      String? sealHash,
      String? sealSignature,
      DateTime? sealedAt,
      String? signingKeyId,
      ValidationStatus status,
      String? validatedBy,
      DateTime? validatedAt,
      String? rejectionReason,
      String? mimeType,
      int? fileSize,
      Map<String, dynamic>? metadata,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ProofImageImplCopyWithImpl<$Res>
    extends _$ProofImageCopyWithImpl<$Res, _$ProofImageImpl>
    implements _$$ProofImageImplCopyWith<$Res> {
  __$$ProofImageImplCopyWithImpl(
      _$ProofImageImpl _value, $Res Function(_$ProofImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? storagePath = null,
    Object? originalFilename = freezed,
    Object? sealHash = freezed,
    Object? sealSignature = freezed,
    Object? sealedAt = freezed,
    Object? signingKeyId = freezed,
    Object? status = null,
    Object? validatedBy = freezed,
    Object? validatedAt = freezed,
    Object? rejectionReason = freezed,
    Object? mimeType = freezed,
    Object? fileSize = freezed,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProofImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      storagePath: null == storagePath
          ? _value.storagePath
          : storagePath // ignore: cast_nullable_to_non_nullable
              as String,
      originalFilename: freezed == originalFilename
          ? _value.originalFilename
          : originalFilename // ignore: cast_nullable_to_non_nullable
              as String?,
      sealHash: freezed == sealHash
          ? _value.sealHash
          : sealHash // ignore: cast_nullable_to_non_nullable
              as String?,
      sealSignature: freezed == sealSignature
          ? _value.sealSignature
          : sealSignature // ignore: cast_nullable_to_non_nullable
              as String?,
      sealedAt: freezed == sealedAt
          ? _value.sealedAt
          : sealedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      signingKeyId: freezed == signingKeyId
          ? _value.signingKeyId
          : signingKeyId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ValidationStatus,
      validatedBy: freezed == validatedBy
          ? _value.validatedBy
          : validatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      validatedAt: freezed == validatedAt
          ? _value.validatedAt
          : validatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProofImageImpl extends _ProofImage {
  const _$ProofImageImpl(
      {required this.id,
      required this.transactionId,
      required this.storagePath,
      this.originalFilename,
      this.sealHash,
      this.sealSignature,
      this.sealedAt,
      this.signingKeyId,
      this.status = ValidationStatus.pending,
      this.validatedBy,
      this.validatedAt,
      this.rejectionReason,
      this.mimeType,
      this.fileSize,
      final Map<String, dynamic>? metadata,
      required this.createdAt,
      this.updatedAt})
      : _metadata = metadata,
        super._();

  factory _$ProofImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProofImageImplFromJson(json);

  @override
  final String id;
  @override
  final String transactionId;
  @override
  final String storagePath;
// Chemin dans Supabase Storage
  @override
  final String? originalFilename;
// Scellement cryptographique ECDSA P-256
  @override
  final String? sealHash;
// SHA-256 du contenu
  @override
  final String? sealSignature;
// Signature ECDSA
  @override
  final DateTime? sealedAt;
  @override
  final String? signingKeyId;
// ID de la clé utilisée
// Validation
  @override
  @JsonKey()
  final ValidationStatus status;
  @override
  final String? validatedBy;
  @override
  final DateTime? validatedAt;
  @override
  final String? rejectionReason;
// Métadonnées
  @override
  final String? mimeType;
  @override
  final int? fileSize;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// EXIF, GPS, etc.
// Timestamps
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ProofImage(id: $id, transactionId: $transactionId, storagePath: $storagePath, originalFilename: $originalFilename, sealHash: $sealHash, sealSignature: $sealSignature, sealedAt: $sealedAt, signingKeyId: $signingKeyId, status: $status, validatedBy: $validatedBy, validatedAt: $validatedAt, rejectionReason: $rejectionReason, mimeType: $mimeType, fileSize: $fileSize, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProofImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath) &&
            (identical(other.originalFilename, originalFilename) ||
                other.originalFilename == originalFilename) &&
            (identical(other.sealHash, sealHash) ||
                other.sealHash == sealHash) &&
            (identical(other.sealSignature, sealSignature) ||
                other.sealSignature == sealSignature) &&
            (identical(other.sealedAt, sealedAt) ||
                other.sealedAt == sealedAt) &&
            (identical(other.signingKeyId, signingKeyId) ||
                other.signingKeyId == signingKeyId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.validatedBy, validatedBy) ||
                other.validatedBy == validatedBy) &&
            (identical(other.validatedAt, validatedAt) ||
                other.validatedAt == validatedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      transactionId,
      storagePath,
      originalFilename,
      sealHash,
      sealSignature,
      sealedAt,
      signingKeyId,
      status,
      validatedBy,
      validatedAt,
      rejectionReason,
      mimeType,
      fileSize,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProofImageImplCopyWith<_$ProofImageImpl> get copyWith =>
      __$$ProofImageImplCopyWithImpl<_$ProofImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProofImageImplToJson(
      this,
    );
  }
}

abstract class _ProofImage extends ProofImage {
  const factory _ProofImage(
      {required final String id,
      required final String transactionId,
      required final String storagePath,
      final String? originalFilename,
      final String? sealHash,
      final String? sealSignature,
      final DateTime? sealedAt,
      final String? signingKeyId,
      final ValidationStatus status,
      final String? validatedBy,
      final DateTime? validatedAt,
      final String? rejectionReason,
      final String? mimeType,
      final int? fileSize,
      final Map<String, dynamic>? metadata,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ProofImageImpl;
  const _ProofImage._() : super._();

  factory _ProofImage.fromJson(Map<String, dynamic> json) =
      _$ProofImageImpl.fromJson;

  @override
  String get id;
  @override
  String get transactionId;
  @override
  String get storagePath;
  @override // Chemin dans Supabase Storage
  String? get originalFilename;
  @override // Scellement cryptographique ECDSA P-256
  String? get sealHash;
  @override // SHA-256 du contenu
  String? get sealSignature;
  @override // Signature ECDSA
  DateTime? get sealedAt;
  @override
  String? get signingKeyId;
  @override // ID de la clé utilisée
// Validation
  ValidationStatus get status;
  @override
  String? get validatedBy;
  @override
  DateTime? get validatedAt;
  @override
  String? get rejectionReason;
  @override // Métadonnées
  String? get mimeType;
  @override
  int? get fileSize;
  @override
  Map<String, dynamic>? get metadata;
  @override // EXIF, GPS, etc.
// Timestamps
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProofImageImplCopyWith<_$ProofImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
