// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_lock_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncLockModelCollection on Isar {
  IsarCollection<SyncLockModel> get syncLockModels => this.collection();
}

const SyncLockModelSchema = CollectionSchema(
  name: r'SyncLockModel',
  id: 2134341347854032104,
  properties: {
    r'isActive': PropertySchema(
      id: 0,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isExpired': PropertySchema(
      id: 1,
      name: r'isExpired',
      type: IsarType.bool,
    ),
    r'lockedAt': PropertySchema(
      id: 2,
      name: r'lockedAt',
      type: IsarType.dateTime,
    ),
    r'lockedBy': PropertySchema(
      id: 3,
      name: r'lockedBy',
      type: IsarType.string,
    )
  },
  estimateSize: _syncLockModelEstimateSize,
  serialize: _syncLockModelSerialize,
  deserialize: _syncLockModelDeserialize,
  deserializeProp: _syncLockModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _syncLockModelGetId,
  getLinks: _syncLockModelGetLinks,
  attach: _syncLockModelAttach,
  version: '3.1.0+1',
);

int _syncLockModelEstimateSize(
  SyncLockModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.lockedBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _syncLockModelSerialize(
  SyncLockModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isActive);
  writer.writeBool(offsets[1], object.isExpired);
  writer.writeDateTime(offsets[2], object.lockedAt);
  writer.writeString(offsets[3], object.lockedBy);
}

SyncLockModel _syncLockModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncLockModel();
  object.id = id;
  object.isActive = reader.readBool(offsets[0]);
  object.lockedAt = reader.readDateTimeOrNull(offsets[2]);
  object.lockedBy = reader.readStringOrNull(offsets[3]);
  return object;
}

P _syncLockModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _syncLockModelGetId(SyncLockModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _syncLockModelGetLinks(SyncLockModel object) {
  return [];
}

void _syncLockModelAttach(
    IsarCollection<dynamic> col, Id id, SyncLockModel object) {
  object.id = id;
}

extension SyncLockModelQueryWhereSort
    on QueryBuilder<SyncLockModel, SyncLockModel, QWhere> {
  QueryBuilder<SyncLockModel, SyncLockModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncLockModelQueryWhere
    on QueryBuilder<SyncLockModel, SyncLockModel, QWhereClause> {
  QueryBuilder<SyncLockModel, SyncLockModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SyncLockModelQueryFilter
    on QueryBuilder<SyncLockModel, SyncLockModel, QFilterCondition> {
  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      isExpiredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isExpired',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lockedAt',
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lockedAt',
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lockedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lockedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lockedBy',
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lockedBy',
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lockedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lockedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lockedBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lockedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterFilterCondition>
      lockedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lockedBy',
        value: '',
      ));
    });
  }
}

extension SyncLockModelQueryObject
    on QueryBuilder<SyncLockModel, SyncLockModel, QFilterCondition> {}

extension SyncLockModelQueryLinks
    on QueryBuilder<SyncLockModel, SyncLockModel, QFilterCondition> {}

extension SyncLockModelQuerySortBy
    on QueryBuilder<SyncLockModel, SyncLockModel, QSortBy> {
  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy> sortByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.asc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy>
      sortByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.desc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy> sortByLockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy>
      sortByLockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedAt', Sort.desc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy> sortByLockedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedBy', Sort.asc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy>
      sortByLockedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedBy', Sort.desc);
    });
  }
}

extension SyncLockModelQuerySortThenBy
    on QueryBuilder<SyncLockModel, SyncLockModel, QSortThenBy> {
  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy> thenByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.asc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy>
      thenByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.desc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy> thenByLockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy>
      thenByLockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedAt', Sort.desc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy> thenByLockedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedBy', Sort.asc);
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QAfterSortBy>
      thenByLockedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockedBy', Sort.desc);
    });
  }
}

extension SyncLockModelQueryWhereDistinct
    on QueryBuilder<SyncLockModel, SyncLockModel, QDistinct> {
  QueryBuilder<SyncLockModel, SyncLockModel, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QDistinct> distinctByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isExpired');
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QDistinct> distinctByLockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lockedAt');
    });
  }

  QueryBuilder<SyncLockModel, SyncLockModel, QDistinct> distinctByLockedBy(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lockedBy', caseSensitive: caseSensitive);
    });
  }
}

extension SyncLockModelQueryProperty
    on QueryBuilder<SyncLockModel, SyncLockModel, QQueryProperty> {
  QueryBuilder<SyncLockModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SyncLockModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<SyncLockModel, bool, QQueryOperations> isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isExpired');
    });
  }

  QueryBuilder<SyncLockModel, DateTime?, QQueryOperations> lockedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lockedAt');
    });
  }

  QueryBuilder<SyncLockModel, String?, QQueryOperations> lockedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lockedBy');
    });
  }
}
