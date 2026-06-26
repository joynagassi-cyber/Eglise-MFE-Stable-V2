// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentorship_pair_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMentorshipPairModelCollection on Isar {
  IsarCollection<MentorshipPairModel> get mentorshipPairModels =>
      this.collection();
}

const MentorshipPairModelSchema = CollectionSchema(
  name: r'MentorshipPairModel',
  id: -2698313372524791540,
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
    r'groupId': PropertySchema(
      id: 2,
      name: r'groupId',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'isDeleted': PropertySchema(
      id: 4,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'jsonData': PropertySchema(
      id: 5,
      name: r'jsonData',
      type: IsarType.string,
    ),
    r'lastSessionAt': PropertySchema(
      id: 6,
      name: r'lastSessionAt',
      type: IsarType.dateTime,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 7,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'menteeId': PropertySchema(
      id: 8,
      name: r'menteeId',
      type: IsarType.string,
    ),
    r'mentorId': PropertySchema(
      id: 9,
      name: r'mentorId',
      type: IsarType.string,
    ),
    r'nextSessionAt': PropertySchema(
      id: 10,
      name: r'nextSessionAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 11,
      name: r'status',
      type: IsarType.byte,
      enumMap: _MentorshipPairModelstatusEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 12,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _mentorshipPairModelEstimateSize,
  serialize: _mentorshipPairModelSerialize,
  deserialize: _mentorshipPairModelDeserialize,
  deserializeProp: _mentorshipPairModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'groupId': IndexSchema(
      id: -8523216633229774932,
      name: r'groupId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'groupId',
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
    r'mentorId': IndexSchema(
      id: 1677932566909819611,
      name: r'mentorId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mentorId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'menteeId': IndexSchema(
      id: 4957300751883746901,
      name: r'menteeId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'menteeId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _mentorshipPairModelGetId,
  getLinks: _mentorshipPairModelGetLinks,
  attach: _mentorshipPairModelAttach,
  version: '3.1.0+1',
);

int _mentorshipPairModelEstimateSize(
  MentorshipPairModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.churchId.length * 3;
  bytesCount += 3 + object.groupId.length * 3;
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.jsonData;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.menteeId.length * 3;
  bytesCount += 3 + object.mentorId.length * 3;
  return bytesCount;
}

void _mentorshipPairModelSerialize(
  MentorshipPairModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.churchId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.groupId);
  writer.writeString(offsets[3], object.id);
  writer.writeBool(offsets[4], object.isDeleted);
  writer.writeString(offsets[5], object.jsonData);
  writer.writeDateTime(offsets[6], object.lastSessionAt);
  writer.writeDateTime(offsets[7], object.lastSyncedAt);
  writer.writeString(offsets[8], object.menteeId);
  writer.writeString(offsets[9], object.mentorId);
  writer.writeDateTime(offsets[10], object.nextSessionAt);
  writer.writeByte(offsets[11], object.status.index);
  writer.writeDateTime(offsets[12], object.updatedAt);
}

MentorshipPairModel _mentorshipPairModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MentorshipPairModel();
  object.churchId = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTimeOrNull(offsets[1]);
  object.groupId = reader.readString(offsets[2]);
  object.id = reader.readString(offsets[3]);
  object.isDeleted = reader.readBool(offsets[4]);
  object.isarId = id;
  object.jsonData = reader.readStringOrNull(offsets[5]);
  object.lastSessionAt = reader.readDateTimeOrNull(offsets[6]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[7]);
  object.menteeId = reader.readString(offsets[8]);
  object.mentorId = reader.readString(offsets[9]);
  object.nextSessionAt = reader.readDateTimeOrNull(offsets[10]);
  object.status = _MentorshipPairModelstatusValueEnumMap[
          reader.readByteOrNull(offsets[11])] ??
      MentorshipStatus.active;
  object.updatedAt = reader.readDateTimeOrNull(offsets[12]);
  return object;
}

P _mentorshipPairModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (_MentorshipPairModelstatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MentorshipStatus.active) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MentorshipPairModelstatusEnumValueMap = {
  'active': 0,
  'completed': 1,
  'terminated': 2,
};
const _MentorshipPairModelstatusValueEnumMap = {
  0: MentorshipStatus.active,
  1: MentorshipStatus.completed,
  2: MentorshipStatus.terminated,
};

Id _mentorshipPairModelGetId(MentorshipPairModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _mentorshipPairModelGetLinks(
    MentorshipPairModel object) {
  return [];
}

void _mentorshipPairModelAttach(
    IsarCollection<dynamic> col, Id id, MentorshipPairModel object) {
  object.isarId = id;
}

extension MentorshipPairModelByIndex on IsarCollection<MentorshipPairModel> {
  Future<MentorshipPairModel?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  MentorshipPairModel? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<MentorshipPairModel?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<MentorshipPairModel?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(MentorshipPairModel object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(MentorshipPairModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<MentorshipPairModel> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<MentorshipPairModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension MentorshipPairModelQueryWhereSort
    on QueryBuilder<MentorshipPairModel, MentorshipPairModel, QWhere> {
  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MentorshipPairModelQueryWhere
    on QueryBuilder<MentorshipPairModel, MentorshipPairModel, QWhereClause> {
  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      isarIdBetween(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      idNotEqualTo(String id) {
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      groupIdEqualTo(String groupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'groupId',
        value: [groupId],
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      groupIdNotEqualTo(String groupId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [groupId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'groupId',
              lower: [],
              upper: [groupId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      churchIdEqualTo(String churchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'churchId',
        value: [churchId],
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      churchIdNotEqualTo(String churchId) {
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      mentorIdEqualTo(String mentorId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mentorId',
        value: [mentorId],
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      mentorIdNotEqualTo(String mentorId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mentorId',
              lower: [],
              upper: [mentorId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mentorId',
              lower: [mentorId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mentorId',
              lower: [mentorId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mentorId',
              lower: [],
              upper: [mentorId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      menteeIdEqualTo(String menteeId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'menteeId',
        value: [menteeId],
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterWhereClause>
      menteeIdNotEqualTo(String menteeId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'menteeId',
              lower: [],
              upper: [menteeId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'menteeId',
              lower: [menteeId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'menteeId',
              lower: [menteeId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'menteeId',
              lower: [],
              upper: [menteeId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MentorshipPairModelQueryFilter on QueryBuilder<MentorshipPairModel,
    MentorshipPairModel, QFilterCondition> {
  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      churchIdEqualTo(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      churchIdGreaterThan(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      churchIdLessThan(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      churchIdBetween(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      churchIdStartsWith(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      churchIdEndsWith(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      churchIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      churchIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'churchId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      churchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      churchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      groupIdEqualTo(
    String value, {
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      groupIdGreaterThan(
    String value, {
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      groupIdLessThan(
    String value, {
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      groupIdBetween(
    String lower,
    String upper, {
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      groupIdStartsWith(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      groupIdEndsWith(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      groupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'groupId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      groupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'groupId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      groupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      groupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'groupId',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      idEqualTo(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      idStartsWith(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      idEndsWith(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      isarIdGreaterThan(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      isarIdLessThan(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      isarIdBetween(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jsonData',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jsonData',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataEqualTo(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataGreaterThan(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataLessThan(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataBetween(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataStartsWith(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataEndsWith(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jsonData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jsonData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonData',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      jsonDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jsonData',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      lastSessionAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSessionAt',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      lastSessionAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSessionAt',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      lastSessionAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSessionAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      lastSessionAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSessionAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      lastSessionAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSessionAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      lastSessionAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSessionAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      lastSyncedAtBetween(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      menteeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'menteeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      menteeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'menteeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      menteeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'menteeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      menteeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'menteeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      menteeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'menteeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      menteeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'menteeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      menteeIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'menteeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      menteeIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'menteeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      menteeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'menteeId',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      menteeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'menteeId',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      mentorIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mentorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      mentorIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mentorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      mentorIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mentorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      mentorIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mentorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      mentorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mentorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      mentorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mentorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      mentorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mentorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      mentorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mentorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      mentorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mentorId',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      mentorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mentorId',
        value: '',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      nextSessionAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextSessionAt',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      nextSessionAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextSessionAt',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      nextSessionAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextSessionAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      nextSessionAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextSessionAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      nextSessionAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextSessionAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      nextSessionAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextSessionAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      statusEqualTo(MentorshipStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      statusGreaterThan(
    MentorshipStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      statusLessThan(
    MentorshipStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      statusBetween(
    MentorshipStatus lower,
    MentorshipStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterFilterCondition>
      updatedAtBetween(
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

extension MentorshipPairModelQueryObject on QueryBuilder<MentorshipPairModel,
    MentorshipPairModel, QFilterCondition> {}

extension MentorshipPairModelQueryLinks on QueryBuilder<MentorshipPairModel,
    MentorshipPairModel, QFilterCondition> {}

extension MentorshipPairModelQuerySortBy
    on QueryBuilder<MentorshipPairModel, MentorshipPairModel, QSortBy> {
  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByJsonData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByJsonDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByLastSessionAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSessionAt', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByLastSessionAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSessionAt', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByMenteeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menteeId', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByMenteeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menteeId', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByMentorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mentorId', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByMentorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mentorId', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByNextSessionAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextSessionAt', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByNextSessionAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextSessionAt', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MentorshipPairModelQuerySortThenBy
    on QueryBuilder<MentorshipPairModel, MentorshipPairModel, QSortThenBy> {
  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'groupId', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByJsonData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByJsonDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByLastSessionAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSessionAt', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByLastSessionAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSessionAt', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByMenteeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menteeId', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByMenteeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menteeId', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByMentorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mentorId', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByMentorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mentorId', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByNextSessionAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextSessionAt', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByNextSessionAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextSessionAt', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension MentorshipPairModelQueryWhereDistinct
    on QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct> {
  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByChurchId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'churchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByGroupId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'groupId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByJsonData({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jsonData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByLastSessionAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSessionAt');
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByMenteeId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'menteeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByMentorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mentorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByNextSessionAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextSessionAt');
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipPairModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension MentorshipPairModelQueryProperty
    on QueryBuilder<MentorshipPairModel, MentorshipPairModel, QQueryProperty> {
  QueryBuilder<MentorshipPairModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<MentorshipPairModel, String, QQueryOperations>
      churchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'churchId');
    });
  }

  QueryBuilder<MentorshipPairModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MentorshipPairModel, String, QQueryOperations>
      groupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'groupId');
    });
  }

  QueryBuilder<MentorshipPairModel, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MentorshipPairModel, bool, QQueryOperations>
      isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<MentorshipPairModel, String?, QQueryOperations>
      jsonDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jsonData');
    });
  }

  QueryBuilder<MentorshipPairModel, DateTime?, QQueryOperations>
      lastSessionAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSessionAt');
    });
  }

  QueryBuilder<MentorshipPairModel, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<MentorshipPairModel, String, QQueryOperations>
      menteeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'menteeId');
    });
  }

  QueryBuilder<MentorshipPairModel, String, QQueryOperations>
      mentorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mentorId');
    });
  }

  QueryBuilder<MentorshipPairModel, DateTime?, QQueryOperations>
      nextSessionAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextSessionAt');
    });
  }

  QueryBuilder<MentorshipPairModel, MentorshipStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<MentorshipPairModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
