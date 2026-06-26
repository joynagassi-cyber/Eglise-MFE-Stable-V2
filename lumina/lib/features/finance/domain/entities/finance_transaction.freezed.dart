// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finance_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FinanceTransaction _$FinanceTransactionFromJson(Map<String, dynamic> json) {
  return _FinanceTransaction.fromJson(json);
}

/// @nodoc
mixin _$FinanceTransaction {
  String get id => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  double get exchangeRate => throw _privateConstructorUsedError;
  double? get amountBaseCurrency => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get category =>
      throw _privateConstructorUsedError; // Ex: 'Dîme', 'Offrande', 'Loyer', 'Électricité'
  String? get categoryId => throw _privateConstructorUsedError;
  PaymentMethod get paymentMethod =>
      throw _privateConstructorUsedError; // Relations (IDs)
  String? get accountId =>
      throw _privateConstructorUsedError; // Compte débité/crédité
  String? get relatedMemberId =>
      throw _privateConstructorUsedError; // Membre lié (pour dîmes/dons)
  String? get createdByUserId =>
      throw _privateConstructorUsedError; // Utilisateur (Secrétaire/Trésorier) qui a saisi
// Pour les transferts
  String? get toAccountId => throw _privateConstructorUsedError; // Métadonnées
  String? get referenceNumber => throw _privateConstructorUsedError; // N° Reçu
  String? get notes => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get attachments =>
      throw _privateConstructorUsedError;
  List<String> get proofImages =>
      throw _privateConstructorUsedError; // URLs photos reçus/factures (legacy)
// ==========================================
// IMAGIR: Workflow & Compliance
// ==========================================
  TransactionStatus get status => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;
  String? get missionId => throw _privateConstructorUsedError;
  List<String> get complianceTags => throw _privateConstructorUsedError;
  bool get complianceChecked =>
      throw _privateConstructorUsedError; // Validation & Approbation
  DateTime? get validatedAt => throw _privateConstructorUsedError;
  String? get validatedBy => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError; // Timestamps
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError; // Audit Trail
  String? get lastModifiedBy => throw _privateConstructorUsedError;
  DateTime? get lastModifiedAt => throw _privateConstructorUsedError;
  String? get lastModifiedByName => throw _privateConstructorUsedError;
  String? get lastModifiedByRole =>
      throw _privateConstructorUsedError; // Reconciliation
  bool get isReconciled => throw _privateConstructorUsedError;
  DateTime? get reconciledAt => throw _privateConstructorUsedError;
  String? get reconciledBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinanceTransactionCopyWith<FinanceTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinanceTransactionCopyWith<$Res> {
  factory $FinanceTransactionCopyWith(
          FinanceTransaction value, $Res Function(FinanceTransaction) then) =
      _$FinanceTransactionCopyWithImpl<$Res, FinanceTransaction>;
  @useResult
  $Res call(
      {String id,
      double amount,
      String currency,
      double exchangeRate,
      double? amountBaseCurrency,
      TransactionType type,
      DateTime date,
      String description,
      String? category,
      String? categoryId,
      PaymentMethod paymentMethod,
      String? accountId,
      String? relatedMemberId,
      String? createdByUserId,
      String? toAccountId,
      String? referenceNumber,
      String? notes,
      List<String> tags,
      List<Map<String, dynamic>> attachments,
      List<String> proofImages,
      TransactionStatus status,
      String? groupId,
      String? missionId,
      List<String> complianceTags,
      bool complianceChecked,
      DateTime? validatedAt,
      String? validatedBy,
      String? approvedBy,
      DateTime? approvedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? lastModifiedBy,
      DateTime? lastModifiedAt,
      String? lastModifiedByName,
      String? lastModifiedByRole,
      bool isReconciled,
      DateTime? reconciledAt,
      String? reconciledBy});
}

/// @nodoc
class _$FinanceTransactionCopyWithImpl<$Res, $Val extends FinanceTransaction>
    implements $FinanceTransactionCopyWith<$Res> {
  _$FinanceTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? currency = null,
    Object? exchangeRate = null,
    Object? amountBaseCurrency = freezed,
    Object? type = null,
    Object? date = null,
    Object? description = null,
    Object? category = freezed,
    Object? categoryId = freezed,
    Object? paymentMethod = null,
    Object? accountId = freezed,
    Object? relatedMemberId = freezed,
    Object? createdByUserId = freezed,
    Object? toAccountId = freezed,
    Object? referenceNumber = freezed,
    Object? notes = freezed,
    Object? tags = null,
    Object? attachments = null,
    Object? proofImages = null,
    Object? status = null,
    Object? groupId = freezed,
    Object? missionId = freezed,
    Object? complianceTags = null,
    Object? complianceChecked = null,
    Object? validatedAt = freezed,
    Object? validatedBy = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastModifiedBy = freezed,
    Object? lastModifiedAt = freezed,
    Object? lastModifiedByName = freezed,
    Object? lastModifiedByRole = freezed,
    Object? isReconciled = null,
    Object? reconciledAt = freezed,
    Object? reconciledBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      exchangeRate: null == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as double,
      amountBaseCurrency: freezed == amountBaseCurrency
          ? _value.amountBaseCurrency
          : amountBaseCurrency // ignore: cast_nullable_to_non_nullable
              as double?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedMemberId: freezed == relatedMemberId
          ? _value.relatedMemberId
          : relatedMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByUserId: freezed == createdByUserId
          ? _value.createdByUserId
          : createdByUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      toAccountId: freezed == toAccountId
          ? _value.toAccountId
          : toAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attachments: null == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      proofImages: null == proofImages
          ? _value.proofImages
          : proofImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransactionStatus,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      missionId: freezed == missionId
          ? _value.missionId
          : missionId // ignore: cast_nullable_to_non_nullable
              as String?,
      complianceTags: null == complianceTags
          ? _value.complianceTags
          : complianceTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      complianceChecked: null == complianceChecked
          ? _value.complianceChecked
          : complianceChecked // ignore: cast_nullable_to_non_nullable
              as bool,
      validatedAt: freezed == validatedAt
          ? _value.validatedAt
          : validatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      validatedBy: freezed == validatedBy
          ? _value.validatedBy
          : validatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastModifiedBy: freezed == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedAt: freezed == lastModifiedAt
          ? _value.lastModifiedAt
          : lastModifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastModifiedByName: freezed == lastModifiedByName
          ? _value.lastModifiedByName
          : lastModifiedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedByRole: freezed == lastModifiedByRole
          ? _value.lastModifiedByRole
          : lastModifiedByRole // ignore: cast_nullable_to_non_nullable
              as String?,
      isReconciled: null == isReconciled
          ? _value.isReconciled
          : isReconciled // ignore: cast_nullable_to_non_nullable
              as bool,
      reconciledAt: freezed == reconciledAt
          ? _value.reconciledAt
          : reconciledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reconciledBy: freezed == reconciledBy
          ? _value.reconciledBy
          : reconciledBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinanceTransactionImplCopyWith<$Res>
    implements $FinanceTransactionCopyWith<$Res> {
  factory _$$FinanceTransactionImplCopyWith(_$FinanceTransactionImpl value,
          $Res Function(_$FinanceTransactionImpl) then) =
      __$$FinanceTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double amount,
      String currency,
      double exchangeRate,
      double? amountBaseCurrency,
      TransactionType type,
      DateTime date,
      String description,
      String? category,
      String? categoryId,
      PaymentMethod paymentMethod,
      String? accountId,
      String? relatedMemberId,
      String? createdByUserId,
      String? toAccountId,
      String? referenceNumber,
      String? notes,
      List<String> tags,
      List<Map<String, dynamic>> attachments,
      List<String> proofImages,
      TransactionStatus status,
      String? groupId,
      String? missionId,
      List<String> complianceTags,
      bool complianceChecked,
      DateTime? validatedAt,
      String? validatedBy,
      String? approvedBy,
      DateTime? approvedAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? lastModifiedBy,
      DateTime? lastModifiedAt,
      String? lastModifiedByName,
      String? lastModifiedByRole,
      bool isReconciled,
      DateTime? reconciledAt,
      String? reconciledBy});
}

/// @nodoc
class __$$FinanceTransactionImplCopyWithImpl<$Res>
    extends _$FinanceTransactionCopyWithImpl<$Res, _$FinanceTransactionImpl>
    implements _$$FinanceTransactionImplCopyWith<$Res> {
  __$$FinanceTransactionImplCopyWithImpl(_$FinanceTransactionImpl _value,
      $Res Function(_$FinanceTransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? amount = null,
    Object? currency = null,
    Object? exchangeRate = null,
    Object? amountBaseCurrency = freezed,
    Object? type = null,
    Object? date = null,
    Object? description = null,
    Object? category = freezed,
    Object? categoryId = freezed,
    Object? paymentMethod = null,
    Object? accountId = freezed,
    Object? relatedMemberId = freezed,
    Object? createdByUserId = freezed,
    Object? toAccountId = freezed,
    Object? referenceNumber = freezed,
    Object? notes = freezed,
    Object? tags = null,
    Object? attachments = null,
    Object? proofImages = null,
    Object? status = null,
    Object? groupId = freezed,
    Object? missionId = freezed,
    Object? complianceTags = null,
    Object? complianceChecked = null,
    Object? validatedAt = freezed,
    Object? validatedBy = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastModifiedBy = freezed,
    Object? lastModifiedAt = freezed,
    Object? lastModifiedByName = freezed,
    Object? lastModifiedByRole = freezed,
    Object? isReconciled = null,
    Object? reconciledAt = freezed,
    Object? reconciledBy = freezed,
  }) {
    return _then(_$FinanceTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      exchangeRate: null == exchangeRate
          ? _value.exchangeRate
          : exchangeRate // ignore: cast_nullable_to_non_nullable
              as double,
      amountBaseCurrency: freezed == amountBaseCurrency
          ? _value.amountBaseCurrency
          : amountBaseCurrency // ignore: cast_nullable_to_non_nullable
              as double?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod,
      accountId: freezed == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedMemberId: freezed == relatedMemberId
          ? _value.relatedMemberId
          : relatedMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdByUserId: freezed == createdByUserId
          ? _value.createdByUserId
          : createdByUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      toAccountId: freezed == toAccountId
          ? _value.toAccountId
          : toAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      referenceNumber: freezed == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attachments: null == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      proofImages: null == proofImages
          ? _value._proofImages
          : proofImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransactionStatus,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
      missionId: freezed == missionId
          ? _value.missionId
          : missionId // ignore: cast_nullable_to_non_nullable
              as String?,
      complianceTags: null == complianceTags
          ? _value._complianceTags
          : complianceTags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      complianceChecked: null == complianceChecked
          ? _value.complianceChecked
          : complianceChecked // ignore: cast_nullable_to_non_nullable
              as bool,
      validatedAt: freezed == validatedAt
          ? _value.validatedAt
          : validatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      validatedBy: freezed == validatedBy
          ? _value.validatedBy
          : validatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastModifiedBy: freezed == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedAt: freezed == lastModifiedAt
          ? _value.lastModifiedAt
          : lastModifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastModifiedByName: freezed == lastModifiedByName
          ? _value.lastModifiedByName
          : lastModifiedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedByRole: freezed == lastModifiedByRole
          ? _value.lastModifiedByRole
          : lastModifiedByRole // ignore: cast_nullable_to_non_nullable
              as String?,
      isReconciled: null == isReconciled
          ? _value.isReconciled
          : isReconciled // ignore: cast_nullable_to_non_nullable
              as bool,
      reconciledAt: freezed == reconciledAt
          ? _value.reconciledAt
          : reconciledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reconciledBy: freezed == reconciledBy
          ? _value.reconciledBy
          : reconciledBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinanceTransactionImpl extends _FinanceTransaction {
  const _$FinanceTransactionImpl(
      {required this.id,
      required this.amount,
      this.currency = 'XAF',
      this.exchangeRate = 1.0,
      this.amountBaseCurrency,
      required this.type,
      required this.date,
      required this.description,
      this.category,
      this.categoryId,
      required this.paymentMethod,
      this.accountId,
      this.relatedMemberId,
      this.createdByUserId,
      this.toAccountId,
      this.referenceNumber,
      this.notes,
      final List<String> tags = const [],
      final List<Map<String, dynamic>> attachments = const [],
      final List<String> proofImages = const [],
      this.status = TransactionStatus.draft,
      this.groupId,
      this.missionId,
      final List<String> complianceTags = const [],
      this.complianceChecked = false,
      this.validatedAt,
      this.validatedBy,
      this.approvedBy,
      this.approvedAt,
      this.createdAt,
      this.updatedAt,
      this.lastModifiedBy,
      this.lastModifiedAt,
      this.lastModifiedByName,
      this.lastModifiedByRole,
      this.isReconciled = false,
      this.reconciledAt,
      this.reconciledBy})
      : _tags = tags,
        _attachments = attachments,
        _proofImages = proofImages,
        _complianceTags = complianceTags,
        super._();

  factory _$FinanceTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinanceTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final double amount;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final double exchangeRate;
  @override
  final double? amountBaseCurrency;
  @override
  final TransactionType type;
  @override
  final DateTime date;
  @override
  final String description;
  @override
  final String? category;
// Ex: 'Dîme', 'Offrande', 'Loyer', 'Électricité'
  @override
  final String? categoryId;
  @override
  final PaymentMethod paymentMethod;
// Relations (IDs)
  @override
  final String? accountId;
// Compte débité/crédité
  @override
  final String? relatedMemberId;
// Membre lié (pour dîmes/dons)
  @override
  final String? createdByUserId;
// Utilisateur (Secrétaire/Trésorier) qui a saisi
// Pour les transferts
  @override
  final String? toAccountId;
// Métadonnées
  @override
  final String? referenceNumber;
// N° Reçu
  @override
  final String? notes;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<Map<String, dynamic>> _attachments;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get attachments {
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attachments);
  }

  final List<String> _proofImages;
  @override
  @JsonKey()
  List<String> get proofImages {
    if (_proofImages is EqualUnmodifiableListView) return _proofImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_proofImages);
  }

// URLs photos reçus/factures (legacy)
// ==========================================
// IMAGIR: Workflow & Compliance
// ==========================================
  @override
  @JsonKey()
  final TransactionStatus status;
  @override
  final String? groupId;
  @override
  final String? missionId;
  final List<String> _complianceTags;
  @override
  @JsonKey()
  List<String> get complianceTags {
    if (_complianceTags is EqualUnmodifiableListView) return _complianceTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_complianceTags);
  }

  @override
  @JsonKey()
  final bool complianceChecked;
// Validation & Approbation
  @override
  final DateTime? validatedAt;
  @override
  final String? validatedBy;
  @override
  final String? approvedBy;
  @override
  final DateTime? approvedAt;
// Timestamps
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
// Audit Trail
  @override
  final String? lastModifiedBy;
  @override
  final DateTime? lastModifiedAt;
  @override
  final String? lastModifiedByName;
  @override
  final String? lastModifiedByRole;
// Reconciliation
  @override
  @JsonKey()
  final bool isReconciled;
  @override
  final DateTime? reconciledAt;
  @override
  final String? reconciledBy;

  @override
  String toString() {
    return 'FinanceTransaction(id: $id, amount: $amount, currency: $currency, exchangeRate: $exchangeRate, amountBaseCurrency: $amountBaseCurrency, type: $type, date: $date, description: $description, category: $category, categoryId: $categoryId, paymentMethod: $paymentMethod, accountId: $accountId, relatedMemberId: $relatedMemberId, createdByUserId: $createdByUserId, toAccountId: $toAccountId, referenceNumber: $referenceNumber, notes: $notes, tags: $tags, attachments: $attachments, proofImages: $proofImages, status: $status, groupId: $groupId, missionId: $missionId, complianceTags: $complianceTags, complianceChecked: $complianceChecked, validatedAt: $validatedAt, validatedBy: $validatedBy, approvedBy: $approvedBy, approvedAt: $approvedAt, createdAt: $createdAt, updatedAt: $updatedAt, lastModifiedBy: $lastModifiedBy, lastModifiedAt: $lastModifiedAt, lastModifiedByName: $lastModifiedByName, lastModifiedByRole: $lastModifiedByRole, isReconciled: $isReconciled, reconciledAt: $reconciledAt, reconciledBy: $reconciledBy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinanceTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.amountBaseCurrency, amountBaseCurrency) ||
                other.amountBaseCurrency == amountBaseCurrency) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.relatedMemberId, relatedMemberId) ||
                other.relatedMemberId == relatedMemberId) &&
            (identical(other.createdByUserId, createdByUserId) ||
                other.createdByUserId == createdByUserId) &&
            (identical(other.toAccountId, toAccountId) ||
                other.toAccountId == toAccountId) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            const DeepCollectionEquality()
                .equals(other._proofImages, _proofImages) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.missionId, missionId) ||
                other.missionId == missionId) &&
            const DeepCollectionEquality()
                .equals(other._complianceTags, _complianceTags) &&
            (identical(other.complianceChecked, complianceChecked) ||
                other.complianceChecked == complianceChecked) &&
            (identical(other.validatedAt, validatedAt) ||
                other.validatedAt == validatedAt) &&
            (identical(other.validatedBy, validatedBy) ||
                other.validatedBy == validatedBy) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastModifiedBy, lastModifiedBy) ||
                other.lastModifiedBy == lastModifiedBy) &&
            (identical(other.lastModifiedAt, lastModifiedAt) ||
                other.lastModifiedAt == lastModifiedAt) &&
            (identical(other.lastModifiedByName, lastModifiedByName) ||
                other.lastModifiedByName == lastModifiedByName) &&
            (identical(other.lastModifiedByRole, lastModifiedByRole) ||
                other.lastModifiedByRole == lastModifiedByRole) &&
            (identical(other.isReconciled, isReconciled) ||
                other.isReconciled == isReconciled) &&
            (identical(other.reconciledAt, reconciledAt) ||
                other.reconciledAt == reconciledAt) &&
            (identical(other.reconciledBy, reconciledBy) ||
                other.reconciledBy == reconciledBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        amount,
        currency,
        exchangeRate,
        amountBaseCurrency,
        type,
        date,
        description,
        category,
        categoryId,
        paymentMethod,
        accountId,
        relatedMemberId,
        createdByUserId,
        toAccountId,
        referenceNumber,
        notes,
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_attachments),
        const DeepCollectionEquality().hash(_proofImages),
        status,
        groupId,
        missionId,
        const DeepCollectionEquality().hash(_complianceTags),
        complianceChecked,
        validatedAt,
        validatedBy,
        approvedBy,
        approvedAt,
        createdAt,
        updatedAt,
        lastModifiedBy,
        lastModifiedAt,
        lastModifiedByName,
        lastModifiedByRole,
        isReconciled,
        reconciledAt,
        reconciledBy
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinanceTransactionImplCopyWith<_$FinanceTransactionImpl> get copyWith =>
      __$$FinanceTransactionImplCopyWithImpl<_$FinanceTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinanceTransactionImplToJson(
      this,
    );
  }
}

abstract class _FinanceTransaction extends FinanceTransaction {
  const factory _FinanceTransaction(
      {required final String id,
      required final double amount,
      final String currency,
      final double exchangeRate,
      final double? amountBaseCurrency,
      required final TransactionType type,
      required final DateTime date,
      required final String description,
      final String? category,
      final String? categoryId,
      required final PaymentMethod paymentMethod,
      final String? accountId,
      final String? relatedMemberId,
      final String? createdByUserId,
      final String? toAccountId,
      final String? referenceNumber,
      final String? notes,
      final List<String> tags,
      final List<Map<String, dynamic>> attachments,
      final List<String> proofImages,
      final TransactionStatus status,
      final String? groupId,
      final String? missionId,
      final List<String> complianceTags,
      final bool complianceChecked,
      final DateTime? validatedAt,
      final String? validatedBy,
      final String? approvedBy,
      final DateTime? approvedAt,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? lastModifiedBy,
      final DateTime? lastModifiedAt,
      final String? lastModifiedByName,
      final String? lastModifiedByRole,
      final bool isReconciled,
      final DateTime? reconciledAt,
      final String? reconciledBy}) = _$FinanceTransactionImpl;
  const _FinanceTransaction._() : super._();

  factory _FinanceTransaction.fromJson(Map<String, dynamic> json) =
      _$FinanceTransactionImpl.fromJson;

  @override
  String get id;
  @override
  double get amount;
  @override
  String get currency;
  @override
  double get exchangeRate;
  @override
  double? get amountBaseCurrency;
  @override
  TransactionType get type;
  @override
  DateTime get date;
  @override
  String get description;
  @override
  String? get category;
  @override // Ex: 'Dîme', 'Offrande', 'Loyer', 'Électricité'
  String? get categoryId;
  @override
  PaymentMethod get paymentMethod;
  @override // Relations (IDs)
  String? get accountId;
  @override // Compte débité/crédité
  String? get relatedMemberId;
  @override // Membre lié (pour dîmes/dons)
  String? get createdByUserId;
  @override // Utilisateur (Secrétaire/Trésorier) qui a saisi
// Pour les transferts
  String? get toAccountId;
  @override // Métadonnées
  String? get referenceNumber;
  @override // N° Reçu
  String? get notes;
  @override
  List<String> get tags;
  @override
  List<Map<String, dynamic>> get attachments;
  @override
  List<String> get proofImages;
  @override // URLs photos reçus/factures (legacy)
// ==========================================
// IMAGIR: Workflow & Compliance
// ==========================================
  TransactionStatus get status;
  @override
  String? get groupId;
  @override
  String? get missionId;
  @override
  List<String> get complianceTags;
  @override
  bool get complianceChecked;
  @override // Validation & Approbation
  DateTime? get validatedAt;
  @override
  String? get validatedBy;
  @override
  String? get approvedBy;
  @override
  DateTime? get approvedAt;
  @override // Timestamps
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override // Audit Trail
  String? get lastModifiedBy;
  @override
  DateTime? get lastModifiedAt;
  @override
  String? get lastModifiedByName;
  @override
  String? get lastModifiedByRole;
  @override // Reconciliation
  bool get isReconciled;
  @override
  DateTime? get reconciledAt;
  @override
  String? get reconciledBy;
  @override
  @JsonKey(ignore: true)
  _$$FinanceTransactionImplCopyWith<_$FinanceTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
