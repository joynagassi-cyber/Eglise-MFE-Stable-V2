// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRoleModelCollection on Isar {
  IsarCollection<RoleModel> get roleModels => this.collection();
}

const RoleModelSchema = CollectionSchema(
  name: r'RoleModel',
  id: 5855428427370670480,
  properties: {
    r'churchId': PropertySchema(
      id: 0,
      name: r'churchId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'initialRoute': PropertySchema(
      id: 4,
      name: r'initialRoute',
      type: IsarType.string,
    ),
    r'isActive': PropertySchema(
      id: 5,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isSynced': PropertySchema(
      id: 6,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'isSystemRole': PropertySchema(
      id: 7,
      name: r'isSystemRole',
      type: IsarType.bool,
    ),
    r'jsonData': PropertySchema(
      id: 8,
      name: r'jsonData',
      type: IsarType.string,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 9,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'level': PropertySchema(
      id: 10,
      name: r'level',
      type: IsarType.string,
      enumMap: _RoleModellevelEnumValueMap,
    ),
    r'name': PropertySchema(
      id: 11,
      name: r'name',
      type: IsarType.string,
    ),
    r'pendingDeletion': PropertySchema(
      id: 12,
      name: r'pendingDeletion',
      type: IsarType.bool,
    ),
    r'permissions': PropertySchema(
      id: 13,
      name: r'permissions',
      type: IsarType.stringList,
    ),
    r'updatedAt': PropertySchema(
      id: 14,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _roleModelEstimateSize,
  serialize: _roleModelSerialize,
  deserialize: _roleModelDeserialize,
  deserializeProp: _roleModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'churchId': IndexSchema(
      id: 8423068024602774628,
      name: r'churchId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'churchId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'isSynced': IndexSchema(
      id: -39763503327887510,
      name: r'isSynced',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isSynced',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _roleModelGetId,
  getLinks: _roleModelGetLinks,
  attach: _roleModelAttach,
  version: '3.1.0+1',
);

int _roleModelEstimateSize(
  RoleModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.churchId.length * 3;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.initialRoute.length * 3;
  {
    final value = object.jsonData;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.level.name.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.permissions.length * 3;
  {
    for (var i = 0; i < object.permissions.length; i++) {
      final value = object.permissions[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _roleModelSerialize(
  RoleModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.churchId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.description);
  writer.writeString(offsets[3], object.id);
  writer.writeString(offsets[4], object.initialRoute);
  writer.writeBool(offsets[5], object.isActive);
  writer.writeBool(offsets[6], object.isSynced);
  writer.writeBool(offsets[7], object.isSystemRole);
  writer.writeString(offsets[8], object.jsonData);
  writer.writeDateTime(offsets[9], object.lastSyncedAt);
  writer.writeString(offsets[10], object.level.name);
  writer.writeString(offsets[11], object.name);
  writer.writeBool(offsets[12], object.pendingDeletion);
  writer.writeStringList(offsets[13], object.permissions);
  writer.writeDateTime(offsets[14], object.updatedAt);
}

RoleModel _roleModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RoleModel();
  object.churchId = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.description = reader.readStringOrNull(offsets[2]);
  object.id = reader.readString(offsets[3]);
  object.initialRoute = reader.readString(offsets[4]);
  object.isActive = reader.readBool(offsets[5]);
  object.isSynced = reader.readBool(offsets[6]);
  object.isSystemRole = reader.readBool(offsets[7]);
  object.isarId = id;
  object.jsonData = reader.readStringOrNull(offsets[8]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[9]);
  object.level =
      _RoleModellevelValueEnumMap[reader.readStringOrNull(offsets[10])] ??
          RoleLevel.adminTotal;
  object.name = reader.readString(offsets[11]);
  object.pendingDeletion = reader.readBool(offsets[12]);
  object.permissions = reader.readStringList(offsets[13]) ?? [];
  object.updatedAt = reader.readDateTimeOrNull(offsets[14]);
  return object;
}

P _roleModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (_RoleModellevelValueEnumMap[reader.readStringOrNull(offset)] ??
          RoleLevel.adminTotal) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readStringList(offset) ?? []) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _RoleModellevelEnumValueMap = {
  r'adminTotal': r'adminTotal',
  r'admin': r'admin',
  r'finance': r'finance',
  r'staff': r'staff',
  r'pastoral': r'pastoral',
  r'groupLeader': r'groupLeader',
  r'superadmin': r'superadmin',
  r'consultation': r'consultation',
  r'membre': r'membre',
  r'custom': r'custom',
};
const _RoleModellevelValueEnumMap = {
  r'adminTotal': RoleLevel.adminTotal,
  r'admin': RoleLevel.admin,
  r'finance': RoleLevel.finance,
  r'staff': RoleLevel.staff,
  r'pastoral': RoleLevel.pastoral,
  r'groupLeader': RoleLevel.groupLeader,
  r'superadmin': RoleLevel.superadmin,
  r'consultation': RoleLevel.consultation,
  r'membre': RoleLevel.membre,
  r'custom': RoleLevel.custom,
};

Id _roleModelGetId(RoleModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _roleModelGetLinks(RoleModel object) {
  return [];
}

void _roleModelAttach(IsarCollection<dynamic> col, Id id, RoleModel object) {
  object.isarId = id;
}

extension RoleModelQueryWhereSort
    on QueryBuilder<RoleModel, RoleModel, QWhere> {
  QueryBuilder<RoleModel, RoleModel, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhere> anyIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isSynced'),
      );
    });
  }
}

extension RoleModelQueryWhere
    on QueryBuilder<RoleModel, RoleModel, QWhereClause> {
  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> idNotEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> churchIdEqualTo(
      String churchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'churchId',
        value: [churchId],
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> churchIdNotEqualTo(
      String churchId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'churchId',
              lower: [],
              upper: [churchId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'churchId',
              lower: [churchId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'churchId',
              lower: [churchId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'churchId',
              lower: [],
              upper: [churchId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> isSyncedEqualTo(
      bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isSynced',
        value: [isSynced],
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterWhereClause> isSyncedNotEqualTo(
      bool isSynced) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [],
              upper: [isSynced],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [isSynced],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [isSynced],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isSynced',
              lower: [],
              upper: [isSynced],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RoleModelQueryFilter
    on QueryBuilder<RoleModel, RoleModel, QFilterCondition> {
  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> churchIdEqualTo(
    String value, {
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> churchIdGreaterThan(
    String value, {
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> churchIdLessThan(
    String value, {
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> churchIdBetween(
    String lower,
    String upper, {
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> churchIdStartsWith(
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> churchIdEndsWith(
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> churchIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> churchIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'churchId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> churchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      churchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> initialRouteEqualTo(
    String value, {
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      initialRouteGreaterThan(
    String value, {
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      initialRouteLessThan(
    String value, {
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> initialRouteBetween(
    String lower,
    String upper, {
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      initialRouteStartsWith(
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      initialRouteEndsWith(
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      initialRouteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'initialRoute',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> initialRouteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'initialRoute',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      initialRouteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialRoute',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      initialRouteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'initialRoute',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> isActiveEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> isSyncedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> isSystemRoleEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSystemRole',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> jsonDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jsonData',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      jsonDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jsonData',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> jsonDataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> jsonDataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jsonData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> jsonDataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jsonData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> jsonDataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jsonData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> jsonDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'jsonData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> jsonDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'jsonData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> jsonDataContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jsonData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> jsonDataMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jsonData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> jsonDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonData',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      jsonDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jsonData',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> lastSyncedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      lastSyncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      lastSyncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> lastSyncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> levelEqualTo(
    RoleLevel value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> levelGreaterThan(
    RoleLevel value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> levelLessThan(
    RoleLevel value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> levelBetween(
    RoleLevel lower,
    RoleLevel upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> levelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> levelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> levelContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> levelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'level',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> levelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> levelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'level',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      pendingDeletionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingDeletion',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'permissions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'permissions',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'permissions',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'permissions',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'permissions',
        value: '',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      permissionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'permissions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> updatedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime? value, {
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
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

  QueryBuilder<RoleModel, RoleModel, QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
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
}

extension RoleModelQueryObject
    on QueryBuilder<RoleModel, RoleModel, QFilterCondition> {}

extension RoleModelQueryLinks
    on QueryBuilder<RoleModel, RoleModel, QFilterCondition> {}

extension RoleModelQuerySortBy on QueryBuilder<RoleModel, RoleModel, QSortBy> {
  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByInitialRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRoute', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByInitialRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRoute', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByIsSystemRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystemRole', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByIsSystemRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystemRole', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByJsonData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByJsonDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByPendingDeletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDeletion', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByPendingDeletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDeletion', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension RoleModelQuerySortThenBy
    on QueryBuilder<RoleModel, RoleModel, QSortThenBy> {
  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByInitialRoute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRoute', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByInitialRouteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialRoute', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByIsSystemRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystemRole', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByIsSystemRoleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSystemRole', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByJsonData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByJsonDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByPendingDeletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDeletion', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByPendingDeletionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDeletion', Sort.desc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension RoleModelQueryWhereDistinct
    on QueryBuilder<RoleModel, RoleModel, QDistinct> {
  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByChurchId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'churchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByInitialRoute(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'initialRoute', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByIsSystemRole() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSystemRole');
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByJsonData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jsonData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByLevel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByPendingDeletion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingDeletion');
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByPermissions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'permissions');
    });
  }

  QueryBuilder<RoleModel, RoleModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension RoleModelQueryProperty
    on QueryBuilder<RoleModel, RoleModel, QQueryProperty> {
  QueryBuilder<RoleModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<RoleModel, String, QQueryOperations> churchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'churchId');
    });
  }

  QueryBuilder<RoleModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<RoleModel, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<RoleModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RoleModel, String, QQueryOperations> initialRouteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'initialRoute');
    });
  }

  QueryBuilder<RoleModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<RoleModel, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<RoleModel, bool, QQueryOperations> isSystemRoleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSystemRole');
    });
  }

  QueryBuilder<RoleModel, String?, QQueryOperations> jsonDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jsonData');
    });
  }

  QueryBuilder<RoleModel, DateTime?, QQueryOperations> lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<RoleModel, RoleLevel, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<RoleModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<RoleModel, bool, QQueryOperations> pendingDeletionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingDeletion');
    });
  }

  QueryBuilder<RoleModel, List<String>, QQueryOperations>
      permissionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'permissions');
    });
  }

  QueryBuilder<RoleModel, DateTime?, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
