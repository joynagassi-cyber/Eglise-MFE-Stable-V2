// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_service_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChurchServiceModelCollection on Isar {
  IsarCollection<ChurchServiceModel> get churchServiceModels =>
      this.collection();
}

const ChurchServiceModelSchema = CollectionSchema(
  name: r'ChurchServiceModel',
  id: -3953394597416229458,
  properties: {
    r'attendanceCount': PropertySchema(
      id: 0,
      name: r'attendanceCount',
      type: IsarType.long,
    ),
    r'childrenCount': PropertySchema(
      id: 1,
      name: r'childrenCount',
      type: IsarType.long,
    ),
    r'childrenVisitorsCount': PropertySchema(
      id: 2,
      name: r'childrenVisitorsCount',
      type: IsarType.long,
    ),
    r'churchId': PropertySchema(
      id: 3,
      name: r'churchId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'date': PropertySchema(
      id: 5,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'isCompleted': PropertySchema(
      id: 6,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'isDeleted': PropertySchema(
      id: 7,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'isSynced': PropertySchema(
      id: 8,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'jsonData': PropertySchema(
      id: 9,
      name: r'jsonData',
      type: IsarType.string,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 10,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'menCount': PropertySchema(
      id: 11,
      name: r'menCount',
      type: IsarType.long,
    ),
    r'menVisitorsCount': PropertySchema(
      id: 12,
      name: r'menVisitorsCount',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(
      id: 13,
      name: r'notes',
      type: IsarType.stringList,
    ),
    r'preacherId': PropertySchema(
      id: 14,
      name: r'preacherId',
      type: IsarType.string,
    ),
    r'preacherName': PropertySchema(
      id: 15,
      name: r'preacherName',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 16,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'theme': PropertySchema(
      id: 17,
      name: r'theme',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 18,
      name: r'title',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 19,
      name: r'type',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 20,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'womenCount': PropertySchema(
      id: 21,
      name: r'womenCount',
      type: IsarType.long,
    ),
    r'womenVisitorsCount': PropertySchema(
      id: 22,
      name: r'womenVisitorsCount',
      type: IsarType.long,
    )
  },
  estimateSize: _churchServiceModelEstimateSize,
  serialize: _churchServiceModelSerialize,
  deserialize: _churchServiceModelDeserialize,
  deserializeProp: _churchServiceModelDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'remoteId': IndexSchema(
      id: 6301175856541681032,
      name: r'remoteId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'remoteId',
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _churchServiceModelGetId,
  getLinks: _churchServiceModelGetLinks,
  attach: _churchServiceModelAttach,
  version: '3.1.0+1',
);

int _churchServiceModelEstimateSize(
  ChurchServiceModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.churchId.length * 3;
  {
    final value = object.jsonData;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.notes.length * 3;
  {
    for (var i = 0; i < object.notes.length; i++) {
      final value = object.notes[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.preacherId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.preacherName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.remoteId.length * 3;
  {
    final value = object.theme;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.type.length * 3;
  return bytesCount;
}

void _churchServiceModelSerialize(
  ChurchServiceModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attendanceCount);
  writer.writeLong(offsets[1], object.childrenCount);
  writer.writeLong(offsets[2], object.childrenVisitorsCount);
  writer.writeString(offsets[3], object.churchId);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeDateTime(offsets[5], object.date);
  writer.writeBool(offsets[6], object.isCompleted);
  writer.writeBool(offsets[7], object.isDeleted);
  writer.writeBool(offsets[8], object.isSynced);
  writer.writeString(offsets[9], object.jsonData);
  writer.writeDateTime(offsets[10], object.lastSyncedAt);
  writer.writeLong(offsets[11], object.menCount);
  writer.writeLong(offsets[12], object.menVisitorsCount);
  writer.writeStringList(offsets[13], object.notes);
  writer.writeString(offsets[14], object.preacherId);
  writer.writeString(offsets[15], object.preacherName);
  writer.writeString(offsets[16], object.remoteId);
  writer.writeString(offsets[17], object.theme);
  writer.writeString(offsets[18], object.title);
  writer.writeString(offsets[19], object.type);
  writer.writeDateTime(offsets[20], object.updatedAt);
  writer.writeLong(offsets[21], object.womenCount);
  writer.writeLong(offsets[22], object.womenVisitorsCount);
}

ChurchServiceModel _churchServiceModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChurchServiceModel();
  object.attendanceCount = reader.readLong(offsets[0]);
  object.childrenCount = reader.readLong(offsets[1]);
  object.childrenVisitorsCount = reader.readLong(offsets[2]);
  object.churchId = reader.readString(offsets[3]);
  object.createdAt = reader.readDateTimeOrNull(offsets[4]);
  object.date = reader.readDateTime(offsets[5]);
  object.isCompleted = reader.readBool(offsets[6]);
  object.isDeleted = reader.readBool(offsets[7]);
  object.isSynced = reader.readBool(offsets[8]);
  object.isarId = id;
  object.jsonData = reader.readStringOrNull(offsets[9]);
  object.lastSyncedAt = reader.readDateTimeOrNull(offsets[10]);
  object.menCount = reader.readLong(offsets[11]);
  object.menVisitorsCount = reader.readLong(offsets[12]);
  object.notes = reader.readStringList(offsets[13]) ?? [];
  object.preacherId = reader.readStringOrNull(offsets[14]);
  object.preacherName = reader.readStringOrNull(offsets[15]);
  object.remoteId = reader.readString(offsets[16]);
  object.theme = reader.readStringOrNull(offsets[17]);
  object.title = reader.readStringOrNull(offsets[18]);
  object.type = reader.readString(offsets[19]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[20]);
  object.womenCount = reader.readLong(offsets[21]);
  object.womenVisitorsCount = reader.readLong(offsets[22]);
  return object;
}

P _churchServiceModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readStringList(offset) ?? []) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readString(offset)) as P;
    case 20:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    case 22:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _churchServiceModelGetId(ChurchServiceModel object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _churchServiceModelGetLinks(
    ChurchServiceModel object) {
  return [];
}

void _churchServiceModelAttach(
    IsarCollection<dynamic> col, Id id, ChurchServiceModel object) {
  object.isarId = id;
}

extension ChurchServiceModelByIndex on IsarCollection<ChurchServiceModel> {
  Future<ChurchServiceModel?> getByRemoteId(String remoteId) {
    return getByIndex(r'remoteId', [remoteId]);
  }

  ChurchServiceModel? getByRemoteIdSync(String remoteId) {
    return getByIndexSync(r'remoteId', [remoteId]);
  }

  Future<bool> deleteByRemoteId(String remoteId) {
    return deleteByIndex(r'remoteId', [remoteId]);
  }

  bool deleteByRemoteIdSync(String remoteId) {
    return deleteByIndexSync(r'remoteId', [remoteId]);
  }

  Future<List<ChurchServiceModel?>> getAllByRemoteId(
      List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'remoteId', values);
  }

  List<ChurchServiceModel?> getAllByRemoteIdSync(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'remoteId', values);
  }

  Future<int> deleteAllByRemoteId(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'remoteId', values);
  }

  int deleteAllByRemoteIdSync(List<String> remoteIdValues) {
    final values = remoteIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'remoteId', values);
  }

  Future<Id> putByRemoteId(ChurchServiceModel object) {
    return putByIndex(r'remoteId', object);
  }

  Id putByRemoteIdSync(ChurchServiceModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'remoteId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByRemoteId(List<ChurchServiceModel> objects) {
    return putAllByIndex(r'remoteId', objects);
  }

  List<Id> putAllByRemoteIdSync(List<ChurchServiceModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'remoteId', objects, saveLinks: saveLinks);
  }
}

extension ChurchServiceModelQueryWhereSort
    on QueryBuilder<ChurchServiceModel, ChurchServiceModel, QWhere> {
  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ChurchServiceModelQueryWhere
    on QueryBuilder<ChurchServiceModel, ChurchServiceModel, QWhereClause> {
  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterWhereClause>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterWhereClause>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterWhereClause>
      remoteIdEqualTo(String remoteId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'remoteId',
        value: [remoteId],
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterWhereClause>
      remoteIdNotEqualTo(String remoteId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [remoteId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'remoteId',
              lower: [],
              upper: [remoteId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterWhereClause>
      churchIdEqualTo(String churchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'churchId',
        value: [churchId],
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterWhereClause>
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
}

extension ChurchServiceModelQueryFilter
    on QueryBuilder<ChurchServiceModel, ChurchServiceModel, QFilterCondition> {
  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      attendanceCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attendanceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      attendanceCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attendanceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      attendanceCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attendanceCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      attendanceCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attendanceCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      childrenCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'childrenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      childrenCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'childrenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      childrenCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'childrenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      childrenCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'childrenCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      childrenVisitorsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'childrenVisitorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      childrenVisitorsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'childrenVisitorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      childrenVisitorsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'childrenVisitorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      childrenVisitorsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'childrenVisitorsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      churchIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      churchIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'churchId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      churchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      churchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      jsonDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'jsonData',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      jsonDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'jsonData',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      jsonDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'jsonData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      jsonDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'jsonData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      jsonDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jsonData',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      jsonDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'jsonData',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      lastSyncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      lastSyncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSyncedAt',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      lastSyncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      menCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'menCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      menCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'menCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      menCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'menCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      menCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'menCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      menVisitorsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'menVisitorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      menVisitorsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'menVisitorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      menVisitorsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'menVisitorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      menVisitorsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'menVisitorsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'notes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'notes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'notes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'notes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'notes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      notesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'notes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'preacherId',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'preacherId',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preacherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preacherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preacherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preacherId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preacherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preacherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preacherId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preacherId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preacherId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preacherId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'preacherName',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'preacherName',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preacherName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'preacherName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'preacherName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'preacherName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'preacherName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'preacherName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'preacherName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'preacherName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'preacherName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      preacherNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'preacherName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      remoteIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      remoteIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      remoteIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      remoteIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      remoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      remoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      remoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      remoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'theme',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'theme',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'theme',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'theme',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'theme',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      themeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'theme',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      typeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      typeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      typeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      typeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
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

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      womenCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'womenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      womenCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'womenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      womenCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'womenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      womenCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'womenCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      womenVisitorsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'womenVisitorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      womenVisitorsCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'womenVisitorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      womenVisitorsCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'womenVisitorsCount',
        value: value,
      ));
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterFilterCondition>
      womenVisitorsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'womenVisitorsCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChurchServiceModelQueryObject
    on QueryBuilder<ChurchServiceModel, ChurchServiceModel, QFilterCondition> {}

extension ChurchServiceModelQueryLinks
    on QueryBuilder<ChurchServiceModel, ChurchServiceModel, QFilterCondition> {}

extension ChurchServiceModelQuerySortBy
    on QueryBuilder<ChurchServiceModel, ChurchServiceModel, QSortBy> {
  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByAttendanceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByAttendanceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByChildrenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'childrenCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByChildrenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'childrenCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByChildrenVisitorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'childrenVisitorsCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByChildrenVisitorsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'childrenVisitorsCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByJsonData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByJsonDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByMenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByMenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByMenVisitorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menVisitorsCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByMenVisitorsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menVisitorsCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByPreacherId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preacherId', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByPreacherIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preacherId', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByPreacherName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preacherName', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByPreacherNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preacherName', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByWomenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'womenCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByWomenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'womenCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByWomenVisitorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'womenVisitorsCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      sortByWomenVisitorsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'womenVisitorsCount', Sort.desc);
    });
  }
}

extension ChurchServiceModelQuerySortThenBy
    on QueryBuilder<ChurchServiceModel, ChurchServiceModel, QSortThenBy> {
  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByAttendanceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByAttendanceCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attendanceCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByChildrenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'childrenCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByChildrenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'childrenCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByChildrenVisitorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'childrenVisitorsCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByChildrenVisitorsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'childrenVisitorsCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByJsonData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByJsonDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jsonData', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByMenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByMenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByMenVisitorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menVisitorsCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByMenVisitorsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'menVisitorsCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByPreacherId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preacherId', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByPreacherIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preacherId', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByPreacherName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preacherName', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByPreacherNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preacherName', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'theme', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByWomenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'womenCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByWomenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'womenCount', Sort.desc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByWomenVisitorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'womenVisitorsCount', Sort.asc);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QAfterSortBy>
      thenByWomenVisitorsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'womenVisitorsCount', Sort.desc);
    });
  }
}

extension ChurchServiceModelQueryWhereDistinct
    on QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct> {
  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByAttendanceCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attendanceCount');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByChildrenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'childrenCount');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByChildrenVisitorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'childrenVisitorsCount');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByChurchId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'churchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByJsonData({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jsonData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByMenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'menCount');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByMenVisitorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'menVisitorsCount');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByPreacherId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preacherId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByPreacherName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'preacherName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByRemoteId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByTheme({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'theme', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByWomenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'womenCount');
    });
  }

  QueryBuilder<ChurchServiceModel, ChurchServiceModel, QDistinct>
      distinctByWomenVisitorsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'womenVisitorsCount');
    });
  }
}

extension ChurchServiceModelQueryProperty
    on QueryBuilder<ChurchServiceModel, ChurchServiceModel, QQueryProperty> {
  QueryBuilder<ChurchServiceModel, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<ChurchServiceModel, int, QQueryOperations>
      attendanceCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attendanceCount');
    });
  }

  QueryBuilder<ChurchServiceModel, int, QQueryOperations>
      childrenCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'childrenCount');
    });
  }

  QueryBuilder<ChurchServiceModel, int, QQueryOperations>
      childrenVisitorsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'childrenVisitorsCount');
    });
  }

  QueryBuilder<ChurchServiceModel, String, QQueryOperations>
      churchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'churchId');
    });
  }

  QueryBuilder<ChurchServiceModel, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<ChurchServiceModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ChurchServiceModel, bool, QQueryOperations>
      isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<ChurchServiceModel, bool, QQueryOperations> isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<ChurchServiceModel, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<ChurchServiceModel, String?, QQueryOperations>
      jsonDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jsonData');
    });
  }

  QueryBuilder<ChurchServiceModel, DateTime?, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<ChurchServiceModel, int, QQueryOperations> menCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'menCount');
    });
  }

  QueryBuilder<ChurchServiceModel, int, QQueryOperations>
      menVisitorsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'menVisitorsCount');
    });
  }

  QueryBuilder<ChurchServiceModel, List<String>, QQueryOperations>
      notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<ChurchServiceModel, String?, QQueryOperations>
      preacherIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preacherId');
    });
  }

  QueryBuilder<ChurchServiceModel, String?, QQueryOperations>
      preacherNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preacherName');
    });
  }

  QueryBuilder<ChurchServiceModel, String, QQueryOperations>
      remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<ChurchServiceModel, String?, QQueryOperations> themeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'theme');
    });
  }

  QueryBuilder<ChurchServiceModel, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<ChurchServiceModel, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<ChurchServiceModel, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ChurchServiceModel, int, QQueryOperations> womenCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'womenCount');
    });
  }

  QueryBuilder<ChurchServiceModel, int, QQueryOperations>
      womenVisitorsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'womenVisitorsCount');
    });
  }
}
