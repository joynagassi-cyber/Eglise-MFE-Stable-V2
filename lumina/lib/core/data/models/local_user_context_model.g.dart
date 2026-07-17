// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_user_context_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalUserContextModelCollection on Isar {
  IsarCollection<LocalUserContextModel> get localUserContextModels =>
      this.collection();
}

const LocalUserContextModelSchema = CollectionSchema(
  name: r'LocalUserContextModel',
  id: 2483941161048153800,
  properties: {
    r'churchId': PropertySchema(
      id: 0,
      name: r'churchId',
      type: IsarType.string,
    ),
    r'groupId': PropertySchema(
      id: 1,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'initialRoute': PropertySchema(
      id: 2,
      name: r'initialRoute',
      type: IsarType.string,
    ),
    r'isSuper': PropertySchema(
      id: 3,
      name: r'isSuper',
      type: IsarType.bool,
    ),
    r'needsOnboarding': PropertySchema(
      id: 4,
      name: r'needsOnboarding',
      type: IsarType.bool,
    ),
    r'roleCode': PropertySchema(
      id: 5,
      name: r'roleCode',
      type: IsarType.string,
    ),
    r'roleHierarchyLevel': PropertySchema(
      id: 6,
      name: r'roleHierarchyLevel',
      type: IsarType.long,
    ),
    r'roleLabel': PropertySchema(
      id: 7,
      name: r'roleLabel',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 8,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 9,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _localUserContextModelEstimateSize,
  serialize: _localUserContextModelSerialize,
  deserialize: _localUserContextModelDeserialize,
  deserializeProp: _localUserContextModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _localUserContextModelGetId,
  getLinks: _localUserContextModelGetLinks,
  attach: _localUserContextModelAttach,
  version: '3.1.0+1',
);

int _localUserContextModelEstimateSize(
  LocalUserContextModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.churchId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.groupId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.initialRoute;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.roleCode.length * 3;
  bytesCount += 3 + object.roleLabel.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _localUserContextModelSerialize(
  LocalUserContextModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.churchId);
  writer.writeString(offsets[1], object.groupId);
  writer.writeString(offsets[2], object.initialRoute);
  writer.writeBool(offsets[3], object.isSuper);
  writer.writeBool(offsets[4], object.needsOnboarding);
  writer.writeString(offsets[5], object.roleCode);
  writer.writeLong(offsets[6], object.roleHierarchyLevel);
  writer.writeString(offsets[7], object.roleLabel);
  writer.writeDateTime(offsets[8], object.updatedAt);
  writer.writeString(offsets[9], object.userId);
}

LocalUserContextModel _localUserContextModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalUserContextModel();
  object.churchId = reader.readStringOrNull(offsets[0]);
  object.groupId = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.initialRoute = reader.readStringOrNull(offsets[2]);
  object.isSuper = reader.readBool(offsets[3]);
  object.needsOnboarding = reader.readBool(offsets[4]);
  object.roleCode = reader.readString(offsets[5]);
  object.roleHierarchyLevel = reader.readLong(offsets[6]);
  object.roleLabel = reader.readString(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  object.userId = reader.readString(offsets[9]);
  return object;
}

P _localUserContextModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localUserContextModelGetId(LocalUserContextModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localUserContextModelGetLinks(
    LocalUserContextModel object) {
  return [];
}

void _localUserContextModelAttach(
    IsarCollection<dynamic> col, Id id, LocalUserContextModel object) {
  object.id = id;
}

extension LocalUserContextModelQueryWhereSort
    on QueryBuilder<LocalUserContextModel, LocalUserContextModel, QWhere> {
  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhere>
      anyUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'userId'),
      );
    });
  }
}

extension LocalUserContextModelQueryWhere on QueryBuilder<LocalUserContextModel,
    LocalUserContextModel, QWhereClause> {
  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [userId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'userId',
              lower: [],
              upper: [userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      userIdGreaterThan(
    String userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [userId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      userIdLessThan(
    String userId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [],
        upper: [userId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      userIdBetween(
    String lowerUserId,
    String upperUserId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [lowerUserId],
        includeLower: includeLower,
        upper: [upperUserId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      userIdStartsWith(String UserIdPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'userId',
        lower: [UserIdPrefix],
        upper: ['$UserIdPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [''],
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterWhereClause>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'userId',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'userId',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'userId',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'userId',
              upper: [''],
            ));
      }
    });
  }
}

extension LocalUserContextModelQueryFilter on QueryBuilder<
    LocalUserContextModel, LocalUserContextModel, QFilterCondition> {
  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> churchIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'churchId',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> churchIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'churchId',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> churchIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> churchIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> churchIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> churchIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'churchId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> churchIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> churchIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      churchIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      churchIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'churchId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> churchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> churchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> groupIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> groupIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'groupId',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> groupIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> groupIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> groupIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> groupIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'groupId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> groupIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> groupIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> initialRouteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'initialRoute',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> initialRouteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'initialRoute',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> initialRouteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> initialRouteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'initialRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> initialRouteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'initialRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> initialRouteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'initialRoute',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> initialRouteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'initialRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> initialRouteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'initialRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      initialRouteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'initialRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      initialRouteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'initialRoute',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> initialRouteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialRoute',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> initialRouteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'initialRoute',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> isSuperEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSuper',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> needsOnboardingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'needsOnboarding',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roleCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'roleCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'roleCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'roleCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'roleCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'roleCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      roleCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'roleCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      roleCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'roleCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roleCode',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'roleCode',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleHierarchyLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roleHierarchyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleHierarchyLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'roleHierarchyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleHierarchyLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'roleHierarchyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleHierarchyLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'roleHierarchyLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'roleLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      roleLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'roleLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      roleLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'roleLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roleLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> roleLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'roleLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
          QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension LocalUserContextModelQueryObject on QueryBuilder<
    LocalUserContextModel, LocalUserContextModel, QFilterCondition> {}

extension LocalUserContextModelQueryLinks on QueryBuilder<LocalUserContextModel,
    LocalUserContextModel, QFilterCondition> {}

extension LocalUserContextModelQuerySortBy
    on QueryBuilder<LocalUserContextModel, LocalUserContextModel, QSortBy> {
  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByInitialRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRoute', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByInitialRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRoute', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByIsSuper() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSuper', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByIsSuperDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSuper', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByNeedsOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsOnboarding', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByNeedsOnboardingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsOnboarding', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByRoleCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleCode', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByRoleCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleCode', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByRoleHierarchyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleHierarchyLevel', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByRoleHierarchyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleHierarchyLevel', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByRoleLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleLabel', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByRoleLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleLabel', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension LocalUserContextModelQuerySortThenBy
    on QueryBuilder<LocalUserContextModel, LocalUserContextModel, QSortThenBy> {
  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByInitialRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRoute', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByInitialRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRoute', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByIsSuper() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSuper', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByIsSuperDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSuper', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByNeedsOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsOnboarding', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByNeedsOnboardingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsOnboarding', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByRoleCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleCode', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByRoleCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleCode', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByRoleHierarchyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleHierarchyLevel', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByRoleHierarchyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleHierarchyLevel', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByRoleLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleLabel', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByRoleLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleLabel', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension LocalUserContextModelQueryWhereDistinct
    on QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct> {
  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct>
      distinctByChurchId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'churchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct>
      distinctByGroupId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct>
      distinctByInitialRoute({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'initialRoute', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct>
      distinctByIsSuper() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSuper');
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct>
      distinctByNeedsOnboarding() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'needsOnboarding');
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct>
      distinctByRoleCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roleCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct>
      distinctByRoleHierarchyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roleHierarchyLevel');
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct>
      distinctByRoleLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roleLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<LocalUserContextModel, LocalUserContextModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension LocalUserContextModelQueryProperty on QueryBuilder<
    LocalUserContextModel, LocalUserContextModel, QQueryProperty> {
  QueryBuilder<LocalUserContextModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalUserContextModel, String?, QQueryOperations>
      churchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'churchId');
    });
  }

  QueryBuilder<LocalUserContextModel, String?, QQueryOperations>
      groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<LocalUserContextModel, String?, QQueryOperations>
      initialRouteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'initialRoute');
    });
  }

  QueryBuilder<LocalUserContextModel, bool, QQueryOperations>
      isSuperProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSuper');
    });
  }

  QueryBuilder<LocalUserContextModel, bool, QQueryOperations>
      needsOnboardingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'needsOnboarding');
    });
  }

  QueryBuilder<LocalUserContextModel, String, QQueryOperations>
      roleCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roleCode');
    });
  }

  QueryBuilder<LocalUserContextModel, int, QQueryOperations>
      roleHierarchyLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roleHierarchyLevel');
    });
  }

  QueryBuilder<LocalUserContextModel, String, QQueryOperations>
      roleLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roleLabel');
    });
  }

  QueryBuilder<LocalUserContextModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<LocalUserContextModel, String, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}
