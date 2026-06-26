// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBibleBookModelCollection on Isar {
  IsarCollection<BibleBookModel> get bibleBookModels => this.collection();
}

const BibleBookModelSchema = CollectionSchema(
  name: r'BibleBookModel',
  id: -6465227077662278236,
  properties: {
    r'identifier': PropertySchema(
      id: 0,
      name: r'identifier',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 1,
      name: r'name',
      type: IsarType.string,
    ),
    r'translationId': PropertySchema(
      id: 2,
      name: r'translationId',
      type: IsarType.string,
    )
  },
  estimateSize: _bibleBookModelEstimateSize,
  serialize: _bibleBookModelSerialize,
  deserialize: _bibleBookModelDeserialize,
  deserializeProp: _bibleBookModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'identifier': IndexSchema(
      id: -1091831983288130400,
      name: r'identifier',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'identifier',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'translationId': IndexSchema(
      id: -4010061285611426888,
      name: r'translationId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'translationId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bibleBookModelGetId,
  getLinks: _bibleBookModelGetLinks,
  attach: _bibleBookModelAttach,
  version: '3.1.0+1',
);

int _bibleBookModelEstimateSize(
  BibleBookModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.identifier.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.translationId.length * 3;
  return bytesCount;
}

void _bibleBookModelSerialize(
  BibleBookModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.identifier);
  writer.writeString(offsets[1], object.name);
  writer.writeString(offsets[2], object.translationId);
}

BibleBookModel _bibleBookModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BibleBookModel();
  object.id = id;
  object.identifier = reader.readString(offsets[0]);
  object.name = reader.readString(offsets[1]);
  object.translationId = reader.readString(offsets[2]);
  return object;
}

P _bibleBookModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bibleBookModelGetId(BibleBookModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bibleBookModelGetLinks(BibleBookModel object) {
  return [];
}

void _bibleBookModelAttach(
    IsarCollection<dynamic> col, Id id, BibleBookModel object) {
  object.id = id;
}

extension BibleBookModelByIndex on IsarCollection<BibleBookModel> {
  Future<BibleBookModel?> getByIdentifier(String identifier) {
    return getByIndex(r'identifier', [identifier]);
  }

  BibleBookModel? getByIdentifierSync(String identifier) {
    return getByIndexSync(r'identifier', [identifier]);
  }

  Future<bool> deleteByIdentifier(String identifier) {
    return deleteByIndex(r'identifier', [identifier]);
  }

  bool deleteByIdentifierSync(String identifier) {
    return deleteByIndexSync(r'identifier', [identifier]);
  }

  Future<List<BibleBookModel?>> getAllByIdentifier(
      List<String> identifierValues) {
    final values = identifierValues.map((e) => [e]).toList();
    return getAllByIndex(r'identifier', values);
  }

  List<BibleBookModel?> getAllByIdentifierSync(List<String> identifierValues) {
    final values = identifierValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'identifier', values);
  }

  Future<int> deleteAllByIdentifier(List<String> identifierValues) {
    final values = identifierValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'identifier', values);
  }

  int deleteAllByIdentifierSync(List<String> identifierValues) {
    final values = identifierValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'identifier', values);
  }

  Future<Id> putByIdentifier(BibleBookModel object) {
    return putByIndex(r'identifier', object);
  }

  Id putByIdentifierSync(BibleBookModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'identifier', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByIdentifier(List<BibleBookModel> objects) {
    return putAllByIndex(r'identifier', objects);
  }

  List<Id> putAllByIdentifierSync(List<BibleBookModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'identifier', objects, saveLinks: saveLinks);
  }
}

extension BibleBookModelQueryWhereSort
    on QueryBuilder<BibleBookModel, BibleBookModel, QWhere> {
  QueryBuilder<BibleBookModel, BibleBookModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BibleBookModelQueryWhere
    on QueryBuilder<BibleBookModel, BibleBookModel, QWhereClause> {
  QueryBuilder<BibleBookModel, BibleBookModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterWhereClause>
      identifierEqualTo(String identifier) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'identifier',
        value: [identifier],
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterWhereClause>
      identifierNotEqualTo(String identifier) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'identifier',
              lower: [],
              upper: [identifier],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'identifier',
              lower: [identifier],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'identifier',
              lower: [identifier],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'identifier',
              lower: [],
              upper: [identifier],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterWhereClause>
      translationIdEqualTo(String translationId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'translationId',
        value: [translationId],
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterWhereClause>
      translationIdNotEqualTo(String translationId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'translationId',
              lower: [],
              upper: [translationId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'translationId',
              lower: [translationId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'translationId',
              lower: [translationId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'translationId',
              lower: [],
              upper: [translationId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BibleBookModelQueryFilter
    on QueryBuilder<BibleBookModel, BibleBookModel, QFilterCondition> {
  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      identifierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      identifierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      identifierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      identifierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'identifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      identifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      identifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      identifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'identifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      identifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'identifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      identifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'identifier',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      identifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'identifier',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      translationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      translationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      translationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      translationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      translationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      translationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      translationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      translationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      translationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterFilterCondition>
      translationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translationId',
        value: '',
      ));
    });
  }
}

extension BibleBookModelQueryObject
    on QueryBuilder<BibleBookModel, BibleBookModel, QFilterCondition> {}

extension BibleBookModelQueryLinks
    on QueryBuilder<BibleBookModel, BibleBookModel, QFilterCondition> {}

extension BibleBookModelQuerySortBy
    on QueryBuilder<BibleBookModel, BibleBookModel, QSortBy> {
  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy>
      sortByIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifier', Sort.asc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy>
      sortByIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifier', Sort.desc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy>
      sortByTranslationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.asc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy>
      sortByTranslationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.desc);
    });
  }
}

extension BibleBookModelQuerySortThenBy
    on QueryBuilder<BibleBookModel, BibleBookModel, QSortThenBy> {
  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy>
      thenByIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifier', Sort.asc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy>
      thenByIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'identifier', Sort.desc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy>
      thenByTranslationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.asc);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QAfterSortBy>
      thenByTranslationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.desc);
    });
  }
}

extension BibleBookModelQueryWhereDistinct
    on QueryBuilder<BibleBookModel, BibleBookModel, QDistinct> {
  QueryBuilder<BibleBookModel, BibleBookModel, QDistinct> distinctByIdentifier(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'identifier', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleBookModel, BibleBookModel, QDistinct>
      distinctByTranslationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translationId',
          caseSensitive: caseSensitive);
    });
  }
}

extension BibleBookModelQueryProperty
    on QueryBuilder<BibleBookModel, BibleBookModel, QQueryProperty> {
  QueryBuilder<BibleBookModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BibleBookModel, String, QQueryOperations> identifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'identifier');
    });
  }

  QueryBuilder<BibleBookModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<BibleBookModel, String, QQueryOperations>
      translationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translationId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBibleChapterModelCollection on Isar {
  IsarCollection<BibleChapterModel> get bibleChapterModels => this.collection();
}

const BibleChapterModelSchema = CollectionSchema(
  name: r'BibleChapterModel',
  id: 8444113716308082417,
  properties: {
    r'bookIdentifier': PropertySchema(
      id: 0,
      name: r'bookIdentifier',
      type: IsarType.string,
    ),
    r'chapterNumber': PropertySchema(
      id: 1,
      name: r'chapterNumber',
      type: IsarType.long,
    ),
    r'lastReadAt': PropertySchema(
      id: 2,
      name: r'lastReadAt',
      type: IsarType.dateTime,
    ),
    r'translationId': PropertySchema(
      id: 3,
      name: r'translationId',
      type: IsarType.string,
    ),
    r'verses': PropertySchema(
      id: 4,
      name: r'verses',
      type: IsarType.stringList,
    )
  },
  estimateSize: _bibleChapterModelEstimateSize,
  serialize: _bibleChapterModelSerialize,
  deserialize: _bibleChapterModelDeserialize,
  deserializeProp: _bibleChapterModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'bookIdentifier_chapterNumber': IndexSchema(
      id: -6697624827111398908,
      name: r'bookIdentifier_chapterNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bookIdentifier',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'chapterNumber',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'lastReadAt': IndexSchema(
      id: 1842310439171066335,
      name: r'lastReadAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastReadAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bibleChapterModelGetId,
  getLinks: _bibleChapterModelGetLinks,
  attach: _bibleChapterModelAttach,
  version: '3.1.0+1',
);

int _bibleChapterModelEstimateSize(
  BibleChapterModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookIdentifier.length * 3;
  bytesCount += 3 + object.translationId.length * 3;
  bytesCount += 3 + object.verses.length * 3;
  {
    for (var i = 0; i < object.verses.length; i++) {
      final value = object.verses[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _bibleChapterModelSerialize(
  BibleChapterModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bookIdentifier);
  writer.writeLong(offsets[1], object.chapterNumber);
  writer.writeDateTime(offsets[2], object.lastReadAt);
  writer.writeString(offsets[3], object.translationId);
  writer.writeStringList(offsets[4], object.verses);
}

BibleChapterModel _bibleChapterModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BibleChapterModel();
  object.bookIdentifier = reader.readString(offsets[0]);
  object.chapterNumber = reader.readLong(offsets[1]);
  object.id = id;
  object.lastReadAt = reader.readDateTime(offsets[2]);
  object.translationId = reader.readString(offsets[3]);
  object.verses = reader.readStringList(offsets[4]) ?? [];
  return object;
}

P _bibleChapterModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bibleChapterModelGetId(BibleChapterModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bibleChapterModelGetLinks(
    BibleChapterModel object) {
  return [];
}

void _bibleChapterModelAttach(
    IsarCollection<dynamic> col, Id id, BibleChapterModel object) {
  object.id = id;
}

extension BibleChapterModelQueryWhereSort
    on QueryBuilder<BibleChapterModel, BibleChapterModel, QWhere> {
  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhere>
      anyLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastReadAt'),
      );
    });
  }
}

extension BibleChapterModelQueryWhere
    on QueryBuilder<BibleChapterModel, BibleChapterModel, QWhereClause> {
  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
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

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
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

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      bookIdentifierEqualToAnyChapterNumber(String bookIdentifier) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapterNumber',
        value: [bookIdentifier],
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      bookIdentifierNotEqualToAnyChapterNumber(String bookIdentifier) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapterNumber',
              lower: [],
              upper: [bookIdentifier],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapterNumber',
              lower: [bookIdentifier],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapterNumber',
              lower: [bookIdentifier],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapterNumber',
              lower: [],
              upper: [bookIdentifier],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      bookIdentifierChapterNumberEqualTo(
          String bookIdentifier, int chapterNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapterNumber',
        value: [bookIdentifier, chapterNumber],
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      bookIdentifierEqualToChapterNumberNotEqualTo(
          String bookIdentifier, int chapterNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapterNumber',
              lower: [bookIdentifier],
              upper: [bookIdentifier, chapterNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapterNumber',
              lower: [bookIdentifier, chapterNumber],
              includeLower: false,
              upper: [bookIdentifier],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapterNumber',
              lower: [bookIdentifier, chapterNumber],
              includeLower: false,
              upper: [bookIdentifier],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapterNumber',
              lower: [bookIdentifier],
              upper: [bookIdentifier, chapterNumber],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      bookIdentifierEqualToChapterNumberGreaterThan(
    String bookIdentifier,
    int chapterNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapterNumber',
        lower: [bookIdentifier, chapterNumber],
        includeLower: include,
        upper: [bookIdentifier],
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      bookIdentifierEqualToChapterNumberLessThan(
    String bookIdentifier,
    int chapterNumber, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapterNumber',
        lower: [bookIdentifier],
        upper: [bookIdentifier, chapterNumber],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      bookIdentifierEqualToChapterNumberBetween(
    String bookIdentifier,
    int lowerChapterNumber,
    int upperChapterNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapterNumber',
        lower: [bookIdentifier, lowerChapterNumber],
        includeLower: includeLower,
        upper: [bookIdentifier, upperChapterNumber],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      lastReadAtEqualTo(DateTime lastReadAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastReadAt',
        value: [lastReadAt],
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      lastReadAtNotEqualTo(DateTime lastReadAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [],
              upper: [lastReadAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [lastReadAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [lastReadAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [],
              upper: [lastReadAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      lastReadAtGreaterThan(
    DateTime lastReadAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastReadAt',
        lower: [lastReadAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      lastReadAtLessThan(
    DateTime lastReadAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastReadAt',
        lower: [],
        upper: [lastReadAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterWhereClause>
      lastReadAtBetween(
    DateTime lowerLastReadAt,
    DateTime upperLastReadAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastReadAt',
        lower: [lowerLastReadAt],
        includeLower: includeLower,
        upper: [upperLastReadAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BibleChapterModelQueryFilter
    on QueryBuilder<BibleChapterModel, BibleChapterModel, QFilterCondition> {
  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      bookIdentifierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      bookIdentifierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      bookIdentifierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      bookIdentifierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookIdentifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      bookIdentifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      bookIdentifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      bookIdentifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      bookIdentifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookIdentifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      bookIdentifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      bookIdentifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      chapterNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapterNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      chapterNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapterNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      chapterNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapterNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      chapterNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapterNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
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

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      lastReadAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      lastReadAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      lastReadAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      lastReadAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      translationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      translationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      translationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      translationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      translationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      translationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      translationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      translationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      translationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      translationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translationId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verses',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'verses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'verses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'verses',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'verses',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verses',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'verses',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'verses',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'verses',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'verses',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'verses',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'verses',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterFilterCondition>
      versesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'verses',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension BibleChapterModelQueryObject
    on QueryBuilder<BibleChapterModel, BibleChapterModel, QFilterCondition> {}

extension BibleChapterModelQueryLinks
    on QueryBuilder<BibleChapterModel, BibleChapterModel, QFilterCondition> {}

extension BibleChapterModelQuerySortBy
    on QueryBuilder<BibleChapterModel, BibleChapterModel, QSortBy> {
  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      sortByBookIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.asc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      sortByBookIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.desc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      sortByChapterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterNumber', Sort.asc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      sortByChapterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterNumber', Sort.desc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      sortByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      sortByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      sortByTranslationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.asc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      sortByTranslationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.desc);
    });
  }
}

extension BibleChapterModelQuerySortThenBy
    on QueryBuilder<BibleChapterModel, BibleChapterModel, QSortThenBy> {
  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      thenByBookIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.asc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      thenByBookIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.desc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      thenByChapterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterNumber', Sort.asc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      thenByChapterNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapterNumber', Sort.desc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      thenByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      thenByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      thenByTranslationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.asc);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QAfterSortBy>
      thenByTranslationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.desc);
    });
  }
}

extension BibleChapterModelQueryWhereDistinct
    on QueryBuilder<BibleChapterModel, BibleChapterModel, QDistinct> {
  QueryBuilder<BibleChapterModel, BibleChapterModel, QDistinct>
      distinctByBookIdentifier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookIdentifier',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QDistinct>
      distinctByChapterNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapterNumber');
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QDistinct>
      distinctByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadAt');
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QDistinct>
      distinctByTranslationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleChapterModel, BibleChapterModel, QDistinct>
      distinctByVerses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verses');
    });
  }
}

extension BibleChapterModelQueryProperty
    on QueryBuilder<BibleChapterModel, BibleChapterModel, QQueryProperty> {
  QueryBuilder<BibleChapterModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BibleChapterModel, String, QQueryOperations>
      bookIdentifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookIdentifier');
    });
  }

  QueryBuilder<BibleChapterModel, int, QQueryOperations>
      chapterNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapterNumber');
    });
  }

  QueryBuilder<BibleChapterModel, DateTime, QQueryOperations>
      lastReadAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadAt');
    });
  }

  QueryBuilder<BibleChapterModel, String, QQueryOperations>
      translationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translationId');
    });
  }

  QueryBuilder<BibleChapterModel, List<String>, QQueryOperations>
      versesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verses');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBibleVerseModelCollection on Isar {
  IsarCollection<BibleVerseModel> get bibleVerseModels => this.collection();
}

const BibleVerseModelSchema = CollectionSchema(
  name: r'BibleVerseModel',
  id: 6638869181675762595,
  properties: {
    r'bookIdentifier': PropertySchema(
      id: 0,
      name: r'bookIdentifier',
      type: IsarType.string,
    ),
    r'chapter': PropertySchema(
      id: 1,
      name: r'chapter',
      type: IsarType.long,
    ),
    r'text': PropertySchema(
      id: 2,
      name: r'text',
      type: IsarType.string,
    ),
    r'translationId': PropertySchema(
      id: 3,
      name: r'translationId',
      type: IsarType.string,
    ),
    r'verse': PropertySchema(
      id: 4,
      name: r'verse',
      type: IsarType.long,
    )
  },
  estimateSize: _bibleVerseModelEstimateSize,
  serialize: _bibleVerseModelSerialize,
  deserialize: _bibleVerseModelDeserialize,
  deserializeProp: _bibleVerseModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'bookIdentifier_chapter_verse': IndexSchema(
      id: 8860188430652174293,
      name: r'bookIdentifier_chapter_verse',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bookIdentifier',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'chapter',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'verse',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'text': IndexSchema(
      id: 5145922347574273553,
      name: r'text',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'text',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'translationId': IndexSchema(
      id: -4010061285611426888,
      name: r'translationId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'translationId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bibleVerseModelGetId,
  getLinks: _bibleVerseModelGetLinks,
  attach: _bibleVerseModelAttach,
  version: '3.1.0+1',
);

int _bibleVerseModelEstimateSize(
  BibleVerseModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookIdentifier.length * 3;
  bytesCount += 3 + object.text.length * 3;
  bytesCount += 3 + object.translationId.length * 3;
  return bytesCount;
}

void _bibleVerseModelSerialize(
  BibleVerseModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bookIdentifier);
  writer.writeLong(offsets[1], object.chapter);
  writer.writeString(offsets[2], object.text);
  writer.writeString(offsets[3], object.translationId);
  writer.writeLong(offsets[4], object.verse);
}

BibleVerseModel _bibleVerseModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BibleVerseModel();
  object.bookIdentifier = reader.readString(offsets[0]);
  object.chapter = reader.readLong(offsets[1]);
  object.id = id;
  object.text = reader.readString(offsets[2]);
  object.translationId = reader.readString(offsets[3]);
  object.verse = reader.readLong(offsets[4]);
  return object;
}

P _bibleVerseModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bibleVerseModelGetId(BibleVerseModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bibleVerseModelGetLinks(BibleVerseModel object) {
  return [];
}

void _bibleVerseModelAttach(
    IsarCollection<dynamic> col, Id id, BibleVerseModel object) {
  object.id = id;
}

extension BibleVerseModelQueryWhereSort
    on QueryBuilder<BibleVerseModel, BibleVerseModel, QWhere> {
  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhere> anyText() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'text'),
      );
    });
  }
}

extension BibleVerseModelQueryWhere
    on QueryBuilder<BibleVerseModel, BibleVerseModel, QWhereClause> {
  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
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

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierEqualToAnyChapterVerse(String bookIdentifier) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapter_verse',
        value: [bookIdentifier],
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierNotEqualToAnyChapterVerse(String bookIdentifier) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [],
              upper: [bookIdentifier],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [],
              upper: [bookIdentifier],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierChapterEqualToAnyVerse(String bookIdentifier, int chapter) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapter_verse',
        value: [bookIdentifier, chapter],
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierEqualToChapterNotEqualToAnyVerse(
          String bookIdentifier, int chapter) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              upper: [bookIdentifier, chapter],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              includeLower: false,
              upper: [bookIdentifier],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              includeLower: false,
              upper: [bookIdentifier],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              upper: [bookIdentifier, chapter],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierEqualToChapterGreaterThanAnyVerse(
    String bookIdentifier,
    int chapter, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter],
        includeLower: include,
        upper: [bookIdentifier],
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierEqualToChapterLessThanAnyVerse(
    String bookIdentifier,
    int chapter, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier],
        upper: [bookIdentifier, chapter],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierEqualToChapterBetweenAnyVerse(
    String bookIdentifier,
    int lowerChapter,
    int upperChapter, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, lowerChapter],
        includeLower: includeLower,
        upper: [bookIdentifier, upperChapter],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierChapterVerseEqualTo(
          String bookIdentifier, int chapter, int verse) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapter_verse',
        value: [bookIdentifier, chapter, verse],
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseNotEqualTo(
          String bookIdentifier, int chapter, int verse) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              upper: [bookIdentifier, chapter, verse],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter, verse],
              includeLower: false,
              upper: [bookIdentifier, chapter],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter, verse],
              includeLower: false,
              upper: [bookIdentifier, chapter],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              upper: [bookIdentifier, chapter, verse],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseGreaterThan(
    String bookIdentifier,
    int chapter,
    int verse, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter, verse],
        includeLower: include,
        upper: [bookIdentifier, chapter],
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseLessThan(
    String bookIdentifier,
    int chapter,
    int verse, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter],
        upper: [bookIdentifier, chapter, verse],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseBetween(
    String bookIdentifier,
    int chapter,
    int lowerVerse,
    int upperVerse, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter, lowerVerse],
        includeLower: includeLower,
        upper: [bookIdentifier, chapter, upperVerse],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause> textEqualTo(
      String text) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'text',
        value: [text],
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      textNotEqualTo(String text) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'text',
              lower: [],
              upper: [text],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'text',
              lower: [text],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'text',
              lower: [text],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'text',
              lower: [],
              upper: [text],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      textGreaterThan(
    String text, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'text',
        lower: [text],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      textLessThan(
    String text, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'text',
        lower: [],
        upper: [text],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause> textBetween(
    String lowerText,
    String upperText, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'text',
        lower: [lowerText],
        includeLower: includeLower,
        upper: [upperText],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      textStartsWith(String TextPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'text',
        lower: [TextPrefix],
        upper: ['$TextPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'text',
        value: [''],
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'text',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'text',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'text',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'text',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      translationIdEqualTo(String translationId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'translationId',
        value: [translationId],
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterWhereClause>
      translationIdNotEqualTo(String translationId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'translationId',
              lower: [],
              upper: [translationId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'translationId',
              lower: [translationId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'translationId',
              lower: [translationId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'translationId',
              lower: [],
              upper: [translationId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BibleVerseModelQueryFilter
    on QueryBuilder<BibleVerseModel, BibleVerseModel, QFilterCondition> {
  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      bookIdentifierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      bookIdentifierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      bookIdentifierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      bookIdentifierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookIdentifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      bookIdentifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      bookIdentifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      bookIdentifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      bookIdentifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookIdentifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      bookIdentifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      bookIdentifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      chapterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      chapterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      chapterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      chapterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
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

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      translationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      translationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      translationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      translationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      translationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      translationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      translationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      translationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      translationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      translationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translationId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      verseEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      verseGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      verseLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterFilterCondition>
      verseBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BibleVerseModelQueryObject
    on QueryBuilder<BibleVerseModel, BibleVerseModel, QFilterCondition> {}

extension BibleVerseModelQueryLinks
    on QueryBuilder<BibleVerseModel, BibleVerseModel, QFilterCondition> {}

extension BibleVerseModelQuerySortBy
    on QueryBuilder<BibleVerseModel, BibleVerseModel, QSortBy> {
  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      sortByBookIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      sortByBookIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.desc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy> sortByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      sortByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      sortByTranslationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      sortByTranslationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.desc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy> sortByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      sortByVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.desc);
    });
  }
}

extension BibleVerseModelQuerySortThenBy
    on QueryBuilder<BibleVerseModel, BibleVerseModel, QSortThenBy> {
  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      thenByBookIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      thenByBookIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.desc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy> thenByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      thenByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      thenByTranslationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      thenByTranslationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.desc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy> thenByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.asc);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QAfterSortBy>
      thenByVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.desc);
    });
  }
}

extension BibleVerseModelQueryWhereDistinct
    on QueryBuilder<BibleVerseModel, BibleVerseModel, QDistinct> {
  QueryBuilder<BibleVerseModel, BibleVerseModel, QDistinct>
      distinctByBookIdentifier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookIdentifier',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QDistinct>
      distinctByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter');
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QDistinct> distinctByText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QDistinct>
      distinctByTranslationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleVerseModel, BibleVerseModel, QDistinct> distinctByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verse');
    });
  }
}

extension BibleVerseModelQueryProperty
    on QueryBuilder<BibleVerseModel, BibleVerseModel, QQueryProperty> {
  QueryBuilder<BibleVerseModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BibleVerseModel, String, QQueryOperations>
      bookIdentifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookIdentifier');
    });
  }

  QueryBuilder<BibleVerseModel, int, QQueryOperations> chapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter');
    });
  }

  QueryBuilder<BibleVerseModel, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<BibleVerseModel, String, QQueryOperations>
      translationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translationId');
    });
  }

  QueryBuilder<BibleVerseModel, int, QQueryOperations> verseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verse');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBibleAnnotationModelCollection on Isar {
  IsarCollection<BibleAnnotationModel> get bibleAnnotationModels =>
      this.collection();
}

const BibleAnnotationModelSchema = CollectionSchema(
  name: r'BibleAnnotationModel',
  id: 8674622544196110663,
  properties: {
    r'bookIdentifier': PropertySchema(
      id: 0,
      name: r'bookIdentifier',
      type: IsarType.string,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'chapter': PropertySchema(
      id: 2,
      name: r'chapter',
      type: IsarType.long,
    ),
    r'churchId': PropertySchema(
      id: 3,
      name: r'churchId',
      type: IsarType.string,
    ),
    r'color': PropertySchema(
      id: 4,
      name: r'color',
      type: IsarType.string,
    ),
    r'content': PropertySchema(
      id: 5,
      name: r'content',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 6,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'supabaseId': PropertySchema(
      id: 7,
      name: r'supabaseId',
      type: IsarType.string,
    ),
    r'translationId': PropertySchema(
      id: 8,
      name: r'translationId',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 9,
      name: r'type',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 10,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 11,
      name: r'userId',
      type: IsarType.string,
    ),
    r'verse': PropertySchema(
      id: 12,
      name: r'verse',
      type: IsarType.long,
    )
  },
  estimateSize: _bibleAnnotationModelEstimateSize,
  serialize: _bibleAnnotationModelSerialize,
  deserialize: _bibleAnnotationModelDeserialize,
  deserializeProp: _bibleAnnotationModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'bookIdentifier_chapter_verse': IndexSchema(
      id: 8860188430652174293,
      name: r'bookIdentifier_chapter_verse',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bookIdentifier',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'chapter',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'verse',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'type': IndexSchema(
      id: 5117122708147080838,
      name: r'type',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'type',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'category': IndexSchema(
      id: -7560358558326323820,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
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
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bibleAnnotationModelGetId,
  getLinks: _bibleAnnotationModelGetLinks,
  attach: _bibleAnnotationModelAttach,
  version: '3.1.0+1',
);

int _bibleAnnotationModelEstimateSize(
  BibleAnnotationModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookIdentifier.length * 3;
  {
    final value = object.category;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.churchId.length * 3;
  {
    final value = object.color;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.content;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.supabaseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.translationId.length * 3;
  bytesCount += 3 + object.type.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _bibleAnnotationModelSerialize(
  BibleAnnotationModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bookIdentifier);
  writer.writeString(offsets[1], object.category);
  writer.writeLong(offsets[2], object.chapter);
  writer.writeString(offsets[3], object.churchId);
  writer.writeString(offsets[4], object.color);
  writer.writeString(offsets[5], object.content);
  writer.writeDateTime(offsets[6], object.createdAt);
  writer.writeString(offsets[7], object.supabaseId);
  writer.writeString(offsets[8], object.translationId);
  writer.writeString(offsets[9], object.type);
  writer.writeDateTime(offsets[10], object.updatedAt);
  writer.writeString(offsets[11], object.userId);
  writer.writeLong(offsets[12], object.verse);
}

BibleAnnotationModel _bibleAnnotationModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BibleAnnotationModel();
  object.bookIdentifier = reader.readString(offsets[0]);
  object.category = reader.readStringOrNull(offsets[1]);
  object.chapter = reader.readLong(offsets[2]);
  object.churchId = reader.readString(offsets[3]);
  object.color = reader.readStringOrNull(offsets[4]);
  object.content = reader.readStringOrNull(offsets[5]);
  object.createdAt = reader.readDateTime(offsets[6]);
  object.id = id;
  object.supabaseId = reader.readStringOrNull(offsets[7]);
  object.translationId = reader.readString(offsets[8]);
  object.type = reader.readString(offsets[9]);
  object.updatedAt = reader.readDateTime(offsets[10]);
  object.userId = reader.readString(offsets[11]);
  object.verse = reader.readLong(offsets[12]);
  return object;
}

P _bibleAnnotationModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bibleAnnotationModelGetId(BibleAnnotationModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bibleAnnotationModelGetLinks(
    BibleAnnotationModel object) {
  return [];
}

void _bibleAnnotationModelAttach(
    IsarCollection<dynamic> col, Id id, BibleAnnotationModel object) {
  object.id = id;
}

extension BibleAnnotationModelQueryWhereSort
    on QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QWhere> {
  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhere>
      anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhere>
      anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension BibleAnnotationModelQueryWhere
    on QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QWhereClause> {
  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierEqualToAnyChapterVerse(String bookIdentifier) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapter_verse',
        value: [bookIdentifier],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierNotEqualToAnyChapterVerse(String bookIdentifier) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [],
              upper: [bookIdentifier],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [],
              upper: [bookIdentifier],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierChapterEqualToAnyVerse(String bookIdentifier, int chapter) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapter_verse',
        value: [bookIdentifier, chapter],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierEqualToChapterNotEqualToAnyVerse(
          String bookIdentifier, int chapter) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              upper: [bookIdentifier, chapter],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              includeLower: false,
              upper: [bookIdentifier],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              includeLower: false,
              upper: [bookIdentifier],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              upper: [bookIdentifier, chapter],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierEqualToChapterGreaterThanAnyVerse(
    String bookIdentifier,
    int chapter, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter],
        includeLower: include,
        upper: [bookIdentifier],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierEqualToChapterLessThanAnyVerse(
    String bookIdentifier,
    int chapter, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier],
        upper: [bookIdentifier, chapter],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierEqualToChapterBetweenAnyVerse(
    String bookIdentifier,
    int lowerChapter,
    int upperChapter, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, lowerChapter],
        includeLower: includeLower,
        upper: [bookIdentifier, upperChapter],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierChapterVerseEqualTo(
          String bookIdentifier, int chapter, int verse) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapter_verse',
        value: [bookIdentifier, chapter, verse],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseNotEqualTo(
          String bookIdentifier, int chapter, int verse) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              upper: [bookIdentifier, chapter, verse],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter, verse],
              includeLower: false,
              upper: [bookIdentifier, chapter],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter, verse],
              includeLower: false,
              upper: [bookIdentifier, chapter],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              upper: [bookIdentifier, chapter, verse],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseGreaterThan(
    String bookIdentifier,
    int chapter,
    int verse, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter, verse],
        includeLower: include,
        upper: [bookIdentifier, chapter],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseLessThan(
    String bookIdentifier,
    int chapter,
    int verse, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter],
        upper: [bookIdentifier, chapter, verse],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseBetween(
    String bookIdentifier,
    int chapter,
    int lowerVerse,
    int upperVerse, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter, lowerVerse],
        includeLower: includeLower,
        upper: [bookIdentifier, chapter, upperVerse],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      typeEqualTo(String type) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'type',
        value: [type],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      typeNotEqualTo(String type) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [],
              upper: [type],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [type],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [type],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'type',
              lower: [],
              upper: [type],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'category',
        value: [null],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'category',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      categoryEqualTo(String? category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'category',
        value: [category],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      categoryNotEqualTo(String? category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      churchIdEqualTo(String churchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'churchId',
        value: [churchId],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterWhereClause>
      updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BibleAnnotationModelQueryFilter on QueryBuilder<BibleAnnotationModel,
    BibleAnnotationModel, QFilterCondition> {
  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> bookIdentifierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> bookIdentifierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> bookIdentifierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> bookIdentifierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookIdentifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> bookIdentifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> bookIdentifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      bookIdentifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      bookIdentifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookIdentifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> bookIdentifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> bookIdentifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'category',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> categoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> categoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> categoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> categoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> chapterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> chapterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> chapterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> chapterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> churchIdEqualTo(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> churchIdGreaterThan(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> churchIdLessThan(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> churchIdBetween(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> churchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> churchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> colorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> colorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'color',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> colorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> colorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> colorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> colorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'color',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      colorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'color',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      colorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'color',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'color',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> contentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'content',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> contentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'content',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> contentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> contentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> contentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> contentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'content',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> contentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> contentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      contentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'content',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      contentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'content',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> contentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> contentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'content',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> supabaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> supabaseIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> supabaseIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> supabaseIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> supabaseIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supabaseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> supabaseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> supabaseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      supabaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      supabaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supabaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> supabaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> supabaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> translationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> translationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> translationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> translationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> translationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> translationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      translationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      translationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> translationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> translationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translationId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> typeEqualTo(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> typeGreaterThan(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> typeLessThan(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> typeBetween(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> typeStartsWith(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
          QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
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

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> verseEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> verseGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> verseLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel,
      QAfterFilterCondition> verseBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BibleAnnotationModelQueryObject on QueryBuilder<BibleAnnotationModel,
    BibleAnnotationModel, QFilterCondition> {}

extension BibleAnnotationModelQueryLinks on QueryBuilder<BibleAnnotationModel,
    BibleAnnotationModel, QFilterCondition> {}

extension BibleAnnotationModelQuerySortBy
    on QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QSortBy> {
  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByBookIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByBookIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByTranslationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByTranslationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      sortByVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.desc);
    });
  }
}

extension BibleAnnotationModelQuerySortThenBy
    on QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QSortThenBy> {
  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByBookIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByBookIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'color', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByContent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByContentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'content', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByTranslationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByTranslationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.asc);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QAfterSortBy>
      thenByVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.desc);
    });
  }
}

extension BibleAnnotationModelQueryWhereDistinct
    on QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct> {
  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByBookIdentifier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookIdentifier',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter');
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByChurchId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'churchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByColor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'color', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByContent({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'content', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctBySupabaseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supabaseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByTranslationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleAnnotationModel, BibleAnnotationModel, QDistinct>
      distinctByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verse');
    });
  }
}

extension BibleAnnotationModelQueryProperty on QueryBuilder<
    BibleAnnotationModel, BibleAnnotationModel, QQueryProperty> {
  QueryBuilder<BibleAnnotationModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BibleAnnotationModel, String, QQueryOperations>
      bookIdentifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookIdentifier');
    });
  }

  QueryBuilder<BibleAnnotationModel, String?, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<BibleAnnotationModel, int, QQueryOperations> chapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter');
    });
  }

  QueryBuilder<BibleAnnotationModel, String, QQueryOperations>
      churchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'churchId');
    });
  }

  QueryBuilder<BibleAnnotationModel, String?, QQueryOperations>
      colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'color');
    });
  }

  QueryBuilder<BibleAnnotationModel, String?, QQueryOperations>
      contentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'content');
    });
  }

  QueryBuilder<BibleAnnotationModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BibleAnnotationModel, String?, QQueryOperations>
      supabaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supabaseId');
    });
  }

  QueryBuilder<BibleAnnotationModel, String, QQueryOperations>
      translationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translationId');
    });
  }

  QueryBuilder<BibleAnnotationModel, String, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<BibleAnnotationModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<BibleAnnotationModel, String, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<BibleAnnotationModel, int, QQueryOperations> verseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verse');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBibleReadingPlanModelCollection on Isar {
  IsarCollection<BibleReadingPlanModel> get bibleReadingPlanModels =>
      this.collection();
}

const BibleReadingPlanModelSchema = CollectionSchema(
  name: r'BibleReadingPlanModel',
  id: 3523518459851641722,
  properties: {
    r'days': PropertySchema(
      id: 0,
      name: r'days',
      type: IsarType.objectList,
      target: r'PlanDayModel',
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'durationInDays': PropertySchema(
      id: 2,
      name: r'durationInDays',
      type: IsarType.long,
    ),
    r'imageUrl': PropertySchema(
      id: 3,
      name: r'imageUrl',
      type: IsarType.string,
    ),
    r'planId': PropertySchema(
      id: 4,
      name: r'planId',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 5,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _bibleReadingPlanModelEstimateSize,
  serialize: _bibleReadingPlanModelSerialize,
  deserialize: _bibleReadingPlanModelDeserialize,
  deserializeProp: _bibleReadingPlanModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'planId': IndexSchema(
      id: 7282644713036731817,
      name: r'planId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'planId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'PlanDayModel': PlanDayModelSchema},
  getId: _bibleReadingPlanModelGetId,
  getLinks: _bibleReadingPlanModelGetLinks,
  attach: _bibleReadingPlanModelAttach,
  version: '3.1.0+1',
);

int _bibleReadingPlanModelEstimateSize(
  BibleReadingPlanModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.days.length * 3;
  {
    final offsets = allOffsets[PlanDayModel]!;
    for (var i = 0; i < object.days.length; i++) {
      final value = object.days[i];
      bytesCount += PlanDayModelSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.description.length * 3;
  {
    final value = object.imageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.planId.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _bibleReadingPlanModelSerialize(
  BibleReadingPlanModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<PlanDayModel>(
    offsets[0],
    allOffsets,
    PlanDayModelSchema.serialize,
    object.days,
  );
  writer.writeString(offsets[1], object.description);
  writer.writeLong(offsets[2], object.durationInDays);
  writer.writeString(offsets[3], object.imageUrl);
  writer.writeString(offsets[4], object.planId);
  writer.writeString(offsets[5], object.title);
}

BibleReadingPlanModel _bibleReadingPlanModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BibleReadingPlanModel();
  object.days = reader.readObjectList<PlanDayModel>(
        offsets[0],
        PlanDayModelSchema.deserialize,
        allOffsets,
        PlanDayModel(),
      ) ??
      [];
  object.description = reader.readString(offsets[1]);
  object.durationInDays = reader.readLong(offsets[2]);
  object.id = id;
  object.imageUrl = reader.readStringOrNull(offsets[3]);
  object.planId = reader.readString(offsets[4]);
  object.title = reader.readString(offsets[5]);
  return object;
}

P _bibleReadingPlanModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<PlanDayModel>(
            offset,
            PlanDayModelSchema.deserialize,
            allOffsets,
            PlanDayModel(),
          ) ??
          []) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bibleReadingPlanModelGetId(BibleReadingPlanModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bibleReadingPlanModelGetLinks(
    BibleReadingPlanModel object) {
  return [];
}

void _bibleReadingPlanModelAttach(
    IsarCollection<dynamic> col, Id id, BibleReadingPlanModel object) {
  object.id = id;
}

extension BibleReadingPlanModelByIndex
    on IsarCollection<BibleReadingPlanModel> {
  Future<BibleReadingPlanModel?> getByPlanId(String planId) {
    return getByIndex(r'planId', [planId]);
  }

  BibleReadingPlanModel? getByPlanIdSync(String planId) {
    return getByIndexSync(r'planId', [planId]);
  }

  Future<bool> deleteByPlanId(String planId) {
    return deleteByIndex(r'planId', [planId]);
  }

  bool deleteByPlanIdSync(String planId) {
    return deleteByIndexSync(r'planId', [planId]);
  }

  Future<List<BibleReadingPlanModel?>> getAllByPlanId(
      List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'planId', values);
  }

  List<BibleReadingPlanModel?> getAllByPlanIdSync(List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'planId', values);
  }

  Future<int> deleteAllByPlanId(List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'planId', values);
  }

  int deleteAllByPlanIdSync(List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'planId', values);
  }

  Future<Id> putByPlanId(BibleReadingPlanModel object) {
    return putByIndex(r'planId', object);
  }

  Id putByPlanIdSync(BibleReadingPlanModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'planId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPlanId(List<BibleReadingPlanModel> objects) {
    return putAllByIndex(r'planId', objects);
  }

  List<Id> putAllByPlanIdSync(List<BibleReadingPlanModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'planId', objects, saveLinks: saveLinks);
  }
}

extension BibleReadingPlanModelQueryWhereSort
    on QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QWhere> {
  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BibleReadingPlanModelQueryWhere on QueryBuilder<BibleReadingPlanModel,
    BibleReadingPlanModel, QWhereClause> {
  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterWhereClause>
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterWhereClause>
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterWhereClause>
      planIdEqualTo(String planId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'planId',
        value: [planId],
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterWhereClause>
      planIdNotEqualTo(String planId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId',
              lower: [],
              upper: [planId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId',
              lower: [planId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId',
              lower: [planId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId',
              lower: [],
              upper: [planId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BibleReadingPlanModelQueryFilter on QueryBuilder<
    BibleReadingPlanModel, BibleReadingPlanModel, QFilterCondition> {
  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> daysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> daysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> daysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> daysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> daysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> daysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'days',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> descriptionEqualTo(
    String value, {
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> descriptionGreaterThan(
    String value, {
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> descriptionLessThan(
    String value, {
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> descriptionBetween(
    String lower,
    String upper, {
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> descriptionStartsWith(
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> descriptionEndsWith(
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
          QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
          QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> durationInDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationInDays',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> durationInDaysGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationInDays',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> durationInDaysLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationInDays',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> durationInDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationInDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> imageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> imageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imageUrl',
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> imageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> imageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> imageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> imageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> imageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> imageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
          QAfterFilterCondition>
      imageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
          QAfterFilterCondition>
      imageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> imageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> imageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> planIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> planIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> planIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> planIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> planIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> planIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
          QAfterFilterCondition>
      planIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
          QAfterFilterCondition>
      planIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'planId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> planIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> planIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> titleEqualTo(
    String value, {
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> titleGreaterThan(
    String value, {
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> titleLessThan(
    String value, {
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension BibleReadingPlanModelQueryObject on QueryBuilder<
    BibleReadingPlanModel, BibleReadingPlanModel, QFilterCondition> {
  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel,
      QAfterFilterCondition> daysElement(FilterQuery<PlanDayModel> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'days');
    });
  }
}

extension BibleReadingPlanModelQueryLinks on QueryBuilder<BibleReadingPlanModel,
    BibleReadingPlanModel, QFilterCondition> {}

extension BibleReadingPlanModelQuerySortBy
    on QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QSortBy> {
  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      sortByDurationInDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInDays', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      sortByDurationInDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInDays', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      sortByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      sortByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      sortByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      sortByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension BibleReadingPlanModelQuerySortThenBy
    on QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QSortThenBy> {
  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByDurationInDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInDays', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByDurationInDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInDays', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imageUrl', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension BibleReadingPlanModelQueryWhereDistinct
    on QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QDistinct> {
  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QDistinct>
      distinctByDurationInDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInDays');
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QDistinct>
      distinctByImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imageUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QDistinct>
      distinctByPlanId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleReadingPlanModel, BibleReadingPlanModel, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension BibleReadingPlanModelQueryProperty on QueryBuilder<
    BibleReadingPlanModel, BibleReadingPlanModel, QQueryProperty> {
  QueryBuilder<BibleReadingPlanModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BibleReadingPlanModel, List<PlanDayModel>, QQueryOperations>
      daysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'days');
    });
  }

  QueryBuilder<BibleReadingPlanModel, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<BibleReadingPlanModel, int, QQueryOperations>
      durationInDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInDays');
    });
  }

  QueryBuilder<BibleReadingPlanModel, String?, QQueryOperations>
      imageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imageUrl');
    });
  }

  QueryBuilder<BibleReadingPlanModel, String, QQueryOperations>
      planIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planId');
    });
  }

  QueryBuilder<BibleReadingPlanModel, String, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBiblePlanProgressModelCollection on Isar {
  IsarCollection<BiblePlanProgressModel> get biblePlanProgressModels =>
      this.collection();
}

const BiblePlanProgressModelSchema = CollectionSchema(
  name: r'BiblePlanProgressModel',
  id: -2983429521691605600,
  properties: {
    r'chaptersReadJson': PropertySchema(
      id: 0,
      name: r'chaptersReadJson',
      type: IsarType.string,
    ),
    r'churchId': PropertySchema(
      id: 1,
      name: r'churchId',
      type: IsarType.string,
    ),
    r'completedDays': PropertySchema(
      id: 2,
      name: r'completedDays',
      type: IsarType.longList,
    ),
    r'currentDay': PropertySchema(
      id: 3,
      name: r'currentDay',
      type: IsarType.long,
    ),
    r'lastReadAt': PropertySchema(
      id: 4,
      name: r'lastReadAt',
      type: IsarType.dateTime,
    ),
    r'planId': PropertySchema(
      id: 5,
      name: r'planId',
      type: IsarType.string,
    ),
    r'startDate': PropertySchema(
      id: 6,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 7,
      name: r'status',
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
  estimateSize: _biblePlanProgressModelEstimateSize,
  serialize: _biblePlanProgressModelSerialize,
  deserialize: _biblePlanProgressModelDeserialize,
  deserializeProp: _biblePlanProgressModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'planId_userId_churchId': IndexSchema(
      id: 8944026747091887729,
      name: r'planId_userId_churchId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'planId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'churchId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'lastReadAt': IndexSchema(
      id: 1842310439171066335,
      name: r'lastReadAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastReadAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _biblePlanProgressModelGetId,
  getLinks: _biblePlanProgressModelGetLinks,
  attach: _biblePlanProgressModelAttach,
  version: '3.1.0+1',
);

int _biblePlanProgressModelEstimateSize(
  BiblePlanProgressModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.chaptersReadJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.churchId.length * 3;
  bytesCount += 3 + object.completedDays.length * 8;
  bytesCount += 3 + object.planId.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _biblePlanProgressModelSerialize(
  BiblePlanProgressModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.chaptersReadJson);
  writer.writeString(offsets[1], object.churchId);
  writer.writeLongList(offsets[2], object.completedDays);
  writer.writeLong(offsets[3], object.currentDay);
  writer.writeDateTime(offsets[4], object.lastReadAt);
  writer.writeString(offsets[5], object.planId);
  writer.writeDateTime(offsets[6], object.startDate);
  writer.writeString(offsets[7], object.status);
  writer.writeDateTime(offsets[8], object.updatedAt);
  writer.writeString(offsets[9], object.userId);
}

BiblePlanProgressModel _biblePlanProgressModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BiblePlanProgressModel();
  object.chaptersReadJson = reader.readStringOrNull(offsets[0]);
  object.churchId = reader.readString(offsets[1]);
  object.completedDays = reader.readLongList(offsets[2]) ?? [];
  object.currentDay = reader.readLong(offsets[3]);
  object.id = id;
  object.lastReadAt = reader.readDateTime(offsets[4]);
  object.planId = reader.readString(offsets[5]);
  object.startDate = reader.readDateTime(offsets[6]);
  object.status = reader.readString(offsets[7]);
  object.updatedAt = reader.readDateTime(offsets[8]);
  object.userId = reader.readString(offsets[9]);
  return object;
}

P _biblePlanProgressModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongList(offset) ?? []) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
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

Id _biblePlanProgressModelGetId(BiblePlanProgressModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _biblePlanProgressModelGetLinks(
    BiblePlanProgressModel object) {
  return [];
}

void _biblePlanProgressModelAttach(
    IsarCollection<dynamic> col, Id id, BiblePlanProgressModel object) {
  object.id = id;
}

extension BiblePlanProgressModelQueryWhereSort
    on QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QWhere> {
  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterWhere>
      anyLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastReadAt'),
      );
    });
  }
}

extension BiblePlanProgressModelQueryWhere on QueryBuilder<
    BiblePlanProgressModel, BiblePlanProgressModel, QWhereClause> {
  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> planIdEqualToAnyUserIdChurchId(String planId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'planId_userId_churchId',
        value: [planId],
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> planIdNotEqualToAnyUserIdChurchId(String planId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [],
              upper: [planId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [planId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [planId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [],
              upper: [planId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
          QAfterWhereClause>
      planIdUserIdEqualToAnyChurchId(String planId, String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'planId_userId_churchId',
        value: [planId, userId],
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
          QAfterWhereClause>
      planIdEqualToUserIdNotEqualToAnyChurchId(String planId, String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [planId],
              upper: [planId, userId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [planId, userId],
              includeLower: false,
              upper: [planId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [planId, userId],
              includeLower: false,
              upper: [planId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [planId],
              upper: [planId, userId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
          QAfterWhereClause>
      planIdUserIdChurchIdEqualTo(
          String planId, String userId, String churchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'planId_userId_churchId',
        value: [planId, userId, churchId],
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
          QAfterWhereClause>
      planIdUserIdEqualToChurchIdNotEqualTo(
          String planId, String userId, String churchId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [planId, userId],
              upper: [planId, userId, churchId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [planId, userId, churchId],
              includeLower: false,
              upper: [planId, userId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [planId, userId, churchId],
              includeLower: false,
              upper: [planId, userId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'planId_userId_churchId',
              lower: [planId, userId],
              upper: [planId, userId, churchId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> lastReadAtEqualTo(DateTime lastReadAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastReadAt',
        value: [lastReadAt],
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> lastReadAtNotEqualTo(DateTime lastReadAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [],
              upper: [lastReadAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [lastReadAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [lastReadAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastReadAt',
              lower: [],
              upper: [lastReadAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> lastReadAtGreaterThan(
    DateTime lastReadAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastReadAt',
        lower: [lastReadAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> lastReadAtLessThan(
    DateTime lastReadAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastReadAt',
        lower: [],
        upper: [lastReadAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterWhereClause> lastReadAtBetween(
    DateTime lowerLastReadAt,
    DateTime upperLastReadAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastReadAt',
        lower: [lowerLastReadAt],
        includeLower: includeLower,
        upper: [upperLastReadAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BiblePlanProgressModelQueryFilter on QueryBuilder<
    BiblePlanProgressModel, BiblePlanProgressModel, QFilterCondition> {
  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> chaptersReadJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chaptersReadJson',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> chaptersReadJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chaptersReadJson',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> chaptersReadJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chaptersReadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> chaptersReadJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chaptersReadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> chaptersReadJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chaptersReadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> chaptersReadJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chaptersReadJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> chaptersReadJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chaptersReadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> chaptersReadJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chaptersReadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
          QAfterFilterCondition>
      chaptersReadJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chaptersReadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
          QAfterFilterCondition>
      chaptersReadJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chaptersReadJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> chaptersReadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chaptersReadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> chaptersReadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chaptersReadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> churchIdEqualTo(
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> churchIdGreaterThan(
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> churchIdLessThan(
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> churchIdBetween(
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> churchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> churchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> completedDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedDays',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> completedDaysElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedDays',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> completedDaysElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedDays',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> completedDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> completedDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedDays',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> completedDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedDays',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> completedDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedDays',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> completedDaysLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedDays',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> completedDaysLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> completedDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> currentDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentDay',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> currentDayGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentDay',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> currentDayLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentDay',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> currentDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> lastReadAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> lastReadAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> lastReadAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> lastReadAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> planIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> planIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> planIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> planIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> planIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> planIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
          QAfterFilterCondition>
      planIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
          QAfterFilterCondition>
      planIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'planId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> planIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> planIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
          QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
          QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
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

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension BiblePlanProgressModelQueryObject on QueryBuilder<
    BiblePlanProgressModel, BiblePlanProgressModel, QFilterCondition> {}

extension BiblePlanProgressModelQueryLinks on QueryBuilder<
    BiblePlanProgressModel, BiblePlanProgressModel, QFilterCondition> {}

extension BiblePlanProgressModelQuerySortBy
    on QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QSortBy> {
  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByChaptersReadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chaptersReadJson', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByChaptersReadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chaptersReadJson', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByCurrentDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDay', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByCurrentDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDay', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BiblePlanProgressModelQuerySortThenBy on QueryBuilder<
    BiblePlanProgressModel, BiblePlanProgressModel, QSortThenBy> {
  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByChaptersReadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chaptersReadJson', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByChaptersReadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chaptersReadJson', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByCurrentDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDay', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByCurrentDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentDay', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByLastReadAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadAt', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BiblePlanProgressModelQueryWhereDistinct
    on QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct> {
  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct>
      distinctByChaptersReadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chaptersReadJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct>
      distinctByChurchId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'churchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct>
      distinctByCompletedDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedDays');
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct>
      distinctByCurrentDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentDay');
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct>
      distinctByLastReadAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadAt');
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct>
      distinctByPlanId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct>
      distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct>
      distinctByStatus({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<BiblePlanProgressModel, BiblePlanProgressModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension BiblePlanProgressModelQueryProperty on QueryBuilder<
    BiblePlanProgressModel, BiblePlanProgressModel, QQueryProperty> {
  QueryBuilder<BiblePlanProgressModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BiblePlanProgressModel, String?, QQueryOperations>
      chaptersReadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chaptersReadJson');
    });
  }

  QueryBuilder<BiblePlanProgressModel, String, QQueryOperations>
      churchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'churchId');
    });
  }

  QueryBuilder<BiblePlanProgressModel, List<int>, QQueryOperations>
      completedDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedDays');
    });
  }

  QueryBuilder<BiblePlanProgressModel, int, QQueryOperations>
      currentDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentDay');
    });
  }

  QueryBuilder<BiblePlanProgressModel, DateTime, QQueryOperations>
      lastReadAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadAt');
    });
  }

  QueryBuilder<BiblePlanProgressModel, String, QQueryOperations>
      planIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planId');
    });
  }

  QueryBuilder<BiblePlanProgressModel, DateTime, QQueryOperations>
      startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<BiblePlanProgressModel, String, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<BiblePlanProgressModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<BiblePlanProgressModel, String, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBibleRewardModelCollection on Isar {
  IsarCollection<BibleRewardModel> get bibleRewardModels => this.collection();
}

const BibleRewardModelSchema = CollectionSchema(
  name: r'BibleRewardModel',
  id: 4833496885747080506,
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
    r'grantedAt': PropertySchema(
      id: 2,
      name: r'grantedAt',
      type: IsarType.dateTime,
    ),
    r'planId': PropertySchema(
      id: 3,
      name: r'planId',
      type: IsarType.string,
    ),
    r'rewardType': PropertySchema(
      id: 4,
      name: r'rewardType',
      type: IsarType.string,
    ),
    r'rewardUrl': PropertySchema(
      id: 5,
      name: r'rewardUrl',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 6,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _bibleRewardModelEstimateSize,
  serialize: _bibleRewardModelSerialize,
  deserialize: _bibleRewardModelDeserialize,
  deserializeProp: _bibleRewardModelDeserializeProp,
  idName: r'id',
  indexes: {
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
    r'rewardType': IndexSchema(
      id: -3253564940152245392,
      name: r'rewardType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'rewardType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bibleRewardModelGetId,
  getLinks: _bibleRewardModelGetLinks,
  attach: _bibleRewardModelAttach,
  version: '3.1.0+1',
);

int _bibleRewardModelEstimateSize(
  BibleRewardModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.churchId.length * 3;
  bytesCount += 3 + object.planId.length * 3;
  bytesCount += 3 + object.rewardType.length * 3;
  {
    final value = object.rewardUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _bibleRewardModelSerialize(
  BibleRewardModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.churchId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDateTime(offsets[2], object.grantedAt);
  writer.writeString(offsets[3], object.planId);
  writer.writeString(offsets[4], object.rewardType);
  writer.writeString(offsets[5], object.rewardUrl);
  writer.writeString(offsets[6], object.userId);
}

BibleRewardModel _bibleRewardModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BibleRewardModel();
  object.churchId = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.grantedAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.planId = reader.readString(offsets[3]);
  object.rewardType = reader.readString(offsets[4]);
  object.rewardUrl = reader.readStringOrNull(offsets[5]);
  object.userId = reader.readString(offsets[6]);
  return object;
}

P _bibleRewardModelDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bibleRewardModelGetId(BibleRewardModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bibleRewardModelGetLinks(BibleRewardModel object) {
  return [];
}

void _bibleRewardModelAttach(
    IsarCollection<dynamic> col, Id id, BibleRewardModel object) {
  object.id = id;
}

extension BibleRewardModelQueryWhereSort
    on QueryBuilder<BibleRewardModel, BibleRewardModel, QWhere> {
  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BibleRewardModelQueryWhere
    on QueryBuilder<BibleRewardModel, BibleRewardModel, QWhereClause> {
  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterWhereClause>
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterWhereClause>
      churchIdEqualTo(String churchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'churchId',
        value: [churchId],
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterWhereClause>
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterWhereClause>
      rewardTypeEqualTo(String rewardType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'rewardType',
        value: [rewardType],
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterWhereClause>
      rewardTypeNotEqualTo(String rewardType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rewardType',
              lower: [],
              upper: [rewardType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rewardType',
              lower: [rewardType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rewardType',
              lower: [rewardType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rewardType',
              lower: [],
              upper: [rewardType],
              includeUpper: false,
            ));
      }
    });
  }
}

extension BibleRewardModelQueryFilter
    on QueryBuilder<BibleRewardModel, BibleRewardModel, QFilterCondition> {
  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      churchIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      churchIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'churchId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      churchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      churchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      grantedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grantedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      grantedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grantedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      grantedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grantedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      grantedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grantedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      planIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      planIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      planIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      planIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'planId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      planIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      planIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      planIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'planId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      planIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'planId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      planIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      planIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'planId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rewardType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rewardType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rewardType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rewardType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rewardType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rewardType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rewardType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardType',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rewardType',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rewardUrl',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rewardUrl',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rewardUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rewardUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rewardUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rewardUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rewardUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rewardUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rewardUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rewardUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      rewardUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rewardUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      userIdEqualTo(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      userIdGreaterThan(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      userIdLessThan(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      userIdBetween(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      userIdStartsWith(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      userIdEndsWith(
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

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension BibleRewardModelQueryObject
    on QueryBuilder<BibleRewardModel, BibleRewardModel, QFilterCondition> {}

extension BibleRewardModelQueryLinks
    on QueryBuilder<BibleRewardModel, BibleRewardModel, QFilterCondition> {}

extension BibleRewardModelQuerySortBy
    on QueryBuilder<BibleRewardModel, BibleRewardModel, QSortBy> {
  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByGrantedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grantedAt', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByGrantedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grantedAt', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByRewardType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardType', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByRewardTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardType', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByRewardUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardUrl', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByRewardUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardUrl', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BibleRewardModelQuerySortThenBy
    on QueryBuilder<BibleRewardModel, BibleRewardModel, QSortThenBy> {
  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByGrantedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grantedAt', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByGrantedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grantedAt', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByRewardType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardType', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByRewardTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardType', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByRewardUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardUrl', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByRewardUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rewardUrl', Sort.desc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BibleRewardModelQueryWhereDistinct
    on QueryBuilder<BibleRewardModel, BibleRewardModel, QDistinct> {
  QueryBuilder<BibleRewardModel, BibleRewardModel, QDistinct>
      distinctByChurchId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'churchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QDistinct>
      distinctByGrantedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grantedAt');
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QDistinct> distinctByPlanId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QDistinct>
      distinctByRewardType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rewardType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QDistinct>
      distinctByRewardUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rewardUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleRewardModel, BibleRewardModel, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension BibleRewardModelQueryProperty
    on QueryBuilder<BibleRewardModel, BibleRewardModel, QQueryProperty> {
  QueryBuilder<BibleRewardModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BibleRewardModel, String, QQueryOperations> churchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'churchId');
    });
  }

  QueryBuilder<BibleRewardModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BibleRewardModel, DateTime, QQueryOperations>
      grantedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grantedAt');
    });
  }

  QueryBuilder<BibleRewardModel, String, QQueryOperations> planIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planId');
    });
  }

  QueryBuilder<BibleRewardModel, String, QQueryOperations>
      rewardTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rewardType');
    });
  }

  QueryBuilder<BibleRewardModel, String?, QQueryOperations>
      rewardUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rewardUrl');
    });
  }

  QueryBuilder<BibleRewardModel, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBibleBookmarkModelCollection on Isar {
  IsarCollection<BibleBookmarkModel> get bibleBookmarkModels =>
      this.collection();
}

const BibleBookmarkModelSchema = CollectionSchema(
  name: r'BibleBookmarkModel',
  id: -948074953614751843,
  properties: {
    r'bookIdentifier': PropertySchema(
      id: 0,
      name: r'bookIdentifier',
      type: IsarType.string,
    ),
    r'chapter': PropertySchema(
      id: 1,
      name: r'chapter',
      type: IsarType.long,
    ),
    r'churchId': PropertySchema(
      id: 2,
      name: r'churchId',
      type: IsarType.string,
    ),
    r'collectionName': PropertySchema(
      id: 3,
      name: r'collectionName',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'reference': PropertySchema(
      id: 5,
      name: r'reference',
      type: IsarType.string,
    ),
    r'supabaseId': PropertySchema(
      id: 6,
      name: r'supabaseId',
      type: IsarType.string,
    ),
    r'translationId': PropertySchema(
      id: 7,
      name: r'translationId',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 8,
      name: r'userId',
      type: IsarType.string,
    ),
    r'verse': PropertySchema(
      id: 9,
      name: r'verse',
      type: IsarType.long,
    ),
    r'verseText': PropertySchema(
      id: 10,
      name: r'verseText',
      type: IsarType.string,
    )
  },
  estimateSize: _bibleBookmarkModelEstimateSize,
  serialize: _bibleBookmarkModelSerialize,
  deserialize: _bibleBookmarkModelDeserialize,
  deserializeProp: _bibleBookmarkModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'bookIdentifier_chapter_verse': IndexSchema(
      id: 8860188430652174293,
      name: r'bookIdentifier_chapter_verse',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'bookIdentifier',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'chapter',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'verse',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'collectionName': IndexSchema(
      id: -4238329797778617380,
      name: r'collectionName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'collectionName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'userId': IndexSchema(
      id: -2005826577402374815,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
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
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bibleBookmarkModelGetId,
  getLinks: _bibleBookmarkModelGetLinks,
  attach: _bibleBookmarkModelAttach,
  version: '3.1.0+1',
);

int _bibleBookmarkModelEstimateSize(
  BibleBookmarkModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.bookIdentifier.length * 3;
  bytesCount += 3 + object.churchId.length * 3;
  bytesCount += 3 + object.collectionName.length * 3;
  {
    final value = object.reference;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.supabaseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.translationId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  bytesCount += 3 + object.verseText.length * 3;
  return bytesCount;
}

void _bibleBookmarkModelSerialize(
  BibleBookmarkModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bookIdentifier);
  writer.writeLong(offsets[1], object.chapter);
  writer.writeString(offsets[2], object.churchId);
  writer.writeString(offsets[3], object.collectionName);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.reference);
  writer.writeString(offsets[6], object.supabaseId);
  writer.writeString(offsets[7], object.translationId);
  writer.writeString(offsets[8], object.userId);
  writer.writeLong(offsets[9], object.verse);
  writer.writeString(offsets[10], object.verseText);
}

BibleBookmarkModel _bibleBookmarkModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BibleBookmarkModel();
  object.bookIdentifier = reader.readString(offsets[0]);
  object.chapter = reader.readLong(offsets[1]);
  object.churchId = reader.readString(offsets[2]);
  object.collectionName = reader.readString(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.id = id;
  object.reference = reader.readStringOrNull(offsets[5]);
  object.supabaseId = reader.readStringOrNull(offsets[6]);
  object.translationId = reader.readString(offsets[7]);
  object.userId = reader.readString(offsets[8]);
  object.verse = reader.readLong(offsets[9]);
  object.verseText = reader.readString(offsets[10]);
  return object;
}

P _bibleBookmarkModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bibleBookmarkModelGetId(BibleBookmarkModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bibleBookmarkModelGetLinks(
    BibleBookmarkModel object) {
  return [];
}

void _bibleBookmarkModelAttach(
    IsarCollection<dynamic> col, Id id, BibleBookmarkModel object) {
  object.id = id;
}

extension BibleBookmarkModelQueryWhereSort
    on QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QWhere> {
  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhere>
      anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension BibleBookmarkModelQueryWhere
    on QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QWhereClause> {
  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierEqualToAnyChapterVerse(String bookIdentifier) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapter_verse',
        value: [bookIdentifier],
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierNotEqualToAnyChapterVerse(String bookIdentifier) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [],
              upper: [bookIdentifier],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [],
              upper: [bookIdentifier],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierChapterEqualToAnyVerse(String bookIdentifier, int chapter) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapter_verse',
        value: [bookIdentifier, chapter],
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierEqualToChapterNotEqualToAnyVerse(
          String bookIdentifier, int chapter) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              upper: [bookIdentifier, chapter],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              includeLower: false,
              upper: [bookIdentifier],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              includeLower: false,
              upper: [bookIdentifier],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier],
              upper: [bookIdentifier, chapter],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierEqualToChapterGreaterThanAnyVerse(
    String bookIdentifier,
    int chapter, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter],
        includeLower: include,
        upper: [bookIdentifier],
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierEqualToChapterLessThanAnyVerse(
    String bookIdentifier,
    int chapter, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier],
        upper: [bookIdentifier, chapter],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierEqualToChapterBetweenAnyVerse(
    String bookIdentifier,
    int lowerChapter,
    int upperChapter, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, lowerChapter],
        includeLower: includeLower,
        upper: [bookIdentifier, upperChapter],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierChapterVerseEqualTo(
          String bookIdentifier, int chapter, int verse) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'bookIdentifier_chapter_verse',
        value: [bookIdentifier, chapter, verse],
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseNotEqualTo(
          String bookIdentifier, int chapter, int verse) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              upper: [bookIdentifier, chapter, verse],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter, verse],
              includeLower: false,
              upper: [bookIdentifier, chapter],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter, verse],
              includeLower: false,
              upper: [bookIdentifier, chapter],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'bookIdentifier_chapter_verse',
              lower: [bookIdentifier, chapter],
              upper: [bookIdentifier, chapter, verse],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseGreaterThan(
    String bookIdentifier,
    int chapter,
    int verse, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter, verse],
        includeLower: include,
        upper: [bookIdentifier, chapter],
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseLessThan(
    String bookIdentifier,
    int chapter,
    int verse, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter],
        upper: [bookIdentifier, chapter, verse],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      bookIdentifierChapterEqualToVerseBetween(
    String bookIdentifier,
    int chapter,
    int lowerVerse,
    int upperVerse, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'bookIdentifier_chapter_verse',
        lower: [bookIdentifier, chapter, lowerVerse],
        includeLower: includeLower,
        upper: [bookIdentifier, chapter, upperVerse],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      collectionNameEqualTo(String collectionName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'collectionName',
        value: [collectionName],
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      collectionNameNotEqualTo(String collectionName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'collectionName',
              lower: [],
              upper: [collectionName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'collectionName',
              lower: [collectionName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'collectionName',
              lower: [collectionName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'collectionName',
              lower: [],
              upper: [collectionName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      churchIdEqualTo(String churchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'churchId',
        value: [churchId],
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BibleBookmarkModelQueryFilter
    on QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QFilterCondition> {
  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      bookIdentifierEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      bookIdentifierGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      bookIdentifierLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      bookIdentifierBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookIdentifier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      bookIdentifierStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      bookIdentifierEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      bookIdentifierContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bookIdentifier',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      bookIdentifierMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bookIdentifier',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      bookIdentifierIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      bookIdentifierIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bookIdentifier',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      chapterEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      chapterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      chapterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      chapterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      churchIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'churchId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      churchIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'churchId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      churchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      churchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      collectionNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      collectionNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'collectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      collectionNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'collectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      collectionNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'collectionName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      collectionNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'collectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      collectionNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'collectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      collectionNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'collectionName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      collectionNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'collectionName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      collectionNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collectionName',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      collectionNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'collectionName',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reference',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reference',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reference',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reference',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reference',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reference',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      referenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reference',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supabaseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supabaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      supabaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      translationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      translationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      translationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      translationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      translationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      translationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      translationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      translationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      translationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translationId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      translationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translationId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      userIdEqualTo(
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      userIdGreaterThan(
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      userIdLessThan(
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      userIdBetween(
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      userIdStartsWith(
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      userIdEndsWith(
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

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'verseText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'verseText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseText',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterFilterCondition>
      verseTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'verseText',
        value: '',
      ));
    });
  }
}

extension BibleBookmarkModelQueryObject
    on QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QFilterCondition> {}

extension BibleBookmarkModelQueryLinks
    on QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QFilterCondition> {}

extension BibleBookmarkModelQuerySortBy
    on QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QSortBy> {
  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByBookIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByBookIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByCollectionName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionName', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByCollectionNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionName', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByTranslationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByTranslationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByVerseText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      sortByVerseTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.desc);
    });
  }
}

extension BibleBookmarkModelQuerySortThenBy
    on QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QSortThenBy> {
  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByBookIdentifier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByBookIdentifierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookIdentifier', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByCollectionName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionName', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByCollectionNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'collectionName', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByReference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByReferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reference', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByTranslationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByTranslationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translationId', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.desc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByVerseText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.asc);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QAfterSortBy>
      thenByVerseTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseText', Sort.desc);
    });
  }
}

extension BibleBookmarkModelQueryWhereDistinct
    on QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct> {
  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctByBookIdentifier({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookIdentifier',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter');
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctByChurchId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'churchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctByCollectionName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'collectionName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctByReference({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reference', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctBySupabaseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supabaseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctByTranslationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translationId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verse');
    });
  }

  QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QDistinct>
      distinctByVerseText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseText', caseSensitive: caseSensitive);
    });
  }
}

extension BibleBookmarkModelQueryProperty
    on QueryBuilder<BibleBookmarkModel, BibleBookmarkModel, QQueryProperty> {
  QueryBuilder<BibleBookmarkModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BibleBookmarkModel, String, QQueryOperations>
      bookIdentifierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookIdentifier');
    });
  }

  QueryBuilder<BibleBookmarkModel, int, QQueryOperations> chapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter');
    });
  }

  QueryBuilder<BibleBookmarkModel, String, QQueryOperations>
      churchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'churchId');
    });
  }

  QueryBuilder<BibleBookmarkModel, String, QQueryOperations>
      collectionNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collectionName');
    });
  }

  QueryBuilder<BibleBookmarkModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BibleBookmarkModel, String?, QQueryOperations>
      referenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reference');
    });
  }

  QueryBuilder<BibleBookmarkModel, String?, QQueryOperations>
      supabaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supabaseId');
    });
  }

  QueryBuilder<BibleBookmarkModel, String, QQueryOperations>
      translationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translationId');
    });
  }

  QueryBuilder<BibleBookmarkModel, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<BibleBookmarkModel, int, QQueryOperations> verseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verse');
    });
  }

  QueryBuilder<BibleBookmarkModel, String, QQueryOperations>
      verseTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseText');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBibleSearchHistoryModelCollection on Isar {
  IsarCollection<BibleSearchHistoryModel> get bibleSearchHistoryModels =>
      this.collection();
}

const BibleSearchHistoryModelSchema = CollectionSchema(
  name: r'BibleSearchHistoryModel',
  id: 6962234580186686538,
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
    r'query': PropertySchema(
      id: 2,
      name: r'query',
      type: IsarType.string,
    ),
    r'resultCount': PropertySchema(
      id: 3,
      name: r'resultCount',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(
      id: 4,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _bibleSearchHistoryModelEstimateSize,
  serialize: _bibleSearchHistoryModelSerialize,
  deserialize: _bibleSearchHistoryModelDeserialize,
  deserializeProp: _bibleSearchHistoryModelDeserializeProp,
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
    r'query': IndexSchema(
      id: -3238105102146786367,
      name: r'query',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'query',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bibleSearchHistoryModelGetId,
  getLinks: _bibleSearchHistoryModelGetLinks,
  attach: _bibleSearchHistoryModelAttach,
  version: '3.1.0+1',
);

int _bibleSearchHistoryModelEstimateSize(
  BibleSearchHistoryModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.churchId.length * 3;
  bytesCount += 3 + object.query.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _bibleSearchHistoryModelSerialize(
  BibleSearchHistoryModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.churchId);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.query);
  writer.writeLong(offsets[3], object.resultCount);
  writer.writeString(offsets[4], object.userId);
}

BibleSearchHistoryModel _bibleSearchHistoryModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BibleSearchHistoryModel();
  object.churchId = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.query = reader.readString(offsets[2]);
  object.resultCount = reader.readLong(offsets[3]);
  object.userId = reader.readString(offsets[4]);
  return object;
}

P _bibleSearchHistoryModelDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bibleSearchHistoryModelGetId(BibleSearchHistoryModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bibleSearchHistoryModelGetLinks(
    BibleSearchHistoryModel object) {
  return [];
}

void _bibleSearchHistoryModelAttach(
    IsarCollection<dynamic> col, Id id, BibleSearchHistoryModel object) {
  object.id = id;
}

extension BibleSearchHistoryModelQueryWhereSort
    on QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QWhere> {
  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterWhere>
      anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension BibleSearchHistoryModelQueryWhere on QueryBuilder<
    BibleSearchHistoryModel, BibleSearchHistoryModel, QWhereClause> {
  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> userIdNotEqualTo(String userId) {
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> churchIdEqualTo(String churchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'churchId',
        value: [churchId],
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> churchIdNotEqualTo(String churchId) {
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> queryEqualTo(String query) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'query',
        value: [query],
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> queryNotEqualTo(String query) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query',
              lower: [],
              upper: [query],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query',
              lower: [query],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query',
              lower: [query],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'query',
              lower: [],
              upper: [query],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterWhereClause> createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BibleSearchHistoryModelQueryFilter on QueryBuilder<
    BibleSearchHistoryModel, BibleSearchHistoryModel, QFilterCondition> {
  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> churchIdEqualTo(
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> churchIdGreaterThan(
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> churchIdLessThan(
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> churchIdBetween(
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> churchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> churchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> queryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> queryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> queryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> queryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'query',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> queryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> queryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
          QAfterFilterCondition>
      queryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'query',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
          QAfterFilterCondition>
      queryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'query',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> queryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'query',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> queryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'query',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> resultCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resultCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> resultCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resultCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> resultCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resultCount',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> resultCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resultCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
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

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension BibleSearchHistoryModelQueryObject on QueryBuilder<
    BibleSearchHistoryModel, BibleSearchHistoryModel, QFilterCondition> {}

extension BibleSearchHistoryModelQueryLinks on QueryBuilder<
    BibleSearchHistoryModel, BibleSearchHistoryModel, QFilterCondition> {}

extension BibleSearchHistoryModelQuerySortBy
    on QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QSortBy> {
  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      sortByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      sortByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      sortByQuery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      sortByQueryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.desc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      sortByResultCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCount', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      sortByResultCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCount', Sort.desc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BibleSearchHistoryModelQuerySortThenBy on QueryBuilder<
    BibleSearchHistoryModel, BibleSearchHistoryModel, QSortThenBy> {
  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByQuery() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByQueryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'query', Sort.desc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByResultCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCount', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByResultCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resultCount', Sort.desc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BibleSearchHistoryModelQueryWhereDistinct on QueryBuilder<
    BibleSearchHistoryModel, BibleSearchHistoryModel, QDistinct> {
  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QDistinct>
      distinctByChurchId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'churchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QDistinct>
      distinctByQuery({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'query', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QDistinct>
      distinctByResultCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resultCount');
    });
  }

  QueryBuilder<BibleSearchHistoryModel, BibleSearchHistoryModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension BibleSearchHistoryModelQueryProperty on QueryBuilder<
    BibleSearchHistoryModel, BibleSearchHistoryModel, QQueryProperty> {
  QueryBuilder<BibleSearchHistoryModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BibleSearchHistoryModel, String, QQueryOperations>
      churchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'churchId');
    });
  }

  QueryBuilder<BibleSearchHistoryModel, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BibleSearchHistoryModel, String, QQueryOperations>
      queryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'query');
    });
  }

  QueryBuilder<BibleSearchHistoryModel, int, QQueryOperations>
      resultCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resultCount');
    });
  }

  QueryBuilder<BibleSearchHistoryModel, String, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBibleReadingStatModelCollection on Isar {
  IsarCollection<BibleReadingStatModel> get bibleReadingStatModels =>
      this.collection();
}

const BibleReadingStatModelSchema = CollectionSchema(
  name: r'BibleReadingStatModel',
  id: 5996453762900025223,
  properties: {
    r'churchId': PropertySchema(
      id: 0,
      name: r'churchId',
      type: IsarType.string,
    ),
    r'currentStreak': PropertySchema(
      id: 1,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'lastReadDate': PropertySchema(
      id: 2,
      name: r'lastReadDate',
      type: IsarType.dateTime,
    ),
    r'maxStreak': PropertySchema(
      id: 3,
      name: r'maxStreak',
      type: IsarType.long,
    ),
    r'totalAnnotations': PropertySchema(
      id: 4,
      name: r'totalAnnotations',
      type: IsarType.long,
    ),
    r'totalChaptersRead': PropertySchema(
      id: 5,
      name: r'totalChaptersRead',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 7,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _bibleReadingStatModelEstimateSize,
  serialize: _bibleReadingStatModelSerialize,
  deserialize: _bibleReadingStatModelDeserialize,
  deserializeProp: _bibleReadingStatModelDeserializeProp,
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
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _bibleReadingStatModelGetId,
  getLinks: _bibleReadingStatModelGetLinks,
  attach: _bibleReadingStatModelAttach,
  version: '3.1.0+1',
);

int _bibleReadingStatModelEstimateSize(
  BibleReadingStatModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.churchId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _bibleReadingStatModelSerialize(
  BibleReadingStatModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.churchId);
  writer.writeLong(offsets[1], object.currentStreak);
  writer.writeDateTime(offsets[2], object.lastReadDate);
  writer.writeLong(offsets[3], object.maxStreak);
  writer.writeLong(offsets[4], object.totalAnnotations);
  writer.writeLong(offsets[5], object.totalChaptersRead);
  writer.writeDateTime(offsets[6], object.updatedAt);
  writer.writeString(offsets[7], object.userId);
}

BibleReadingStatModel _bibleReadingStatModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BibleReadingStatModel();
  object.churchId = reader.readString(offsets[0]);
  object.currentStreak = reader.readLong(offsets[1]);
  object.id = id;
  object.lastReadDate = reader.readDateTimeOrNull(offsets[2]);
  object.maxStreak = reader.readLong(offsets[3]);
  object.totalAnnotations = reader.readLong(offsets[4]);
  object.totalChaptersRead = reader.readLong(offsets[5]);
  object.updatedAt = reader.readDateTime(offsets[6]);
  object.userId = reader.readString(offsets[7]);
  return object;
}

P _bibleReadingStatModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bibleReadingStatModelGetId(BibleReadingStatModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bibleReadingStatModelGetLinks(
    BibleReadingStatModel object) {
  return [];
}

void _bibleReadingStatModelAttach(
    IsarCollection<dynamic> col, Id id, BibleReadingStatModel object) {
  object.id = id;
}

extension BibleReadingStatModelQueryWhereSort
    on QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QWhere> {
  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhere>
      anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension BibleReadingStatModelQueryWhere on QueryBuilder<BibleReadingStatModel,
    BibleReadingStatModel, QWhereClause> {
  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
      userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'userId',
        value: [userId],
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
      churchIdEqualTo(String churchId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'churchId',
        value: [churchId],
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
      updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterWhereClause>
      updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension BibleReadingStatModelQueryFilter on QueryBuilder<
    BibleReadingStatModel, BibleReadingStatModel, QFilterCondition> {
  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> churchIdEqualTo(
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> churchIdGreaterThan(
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> churchIdLessThan(
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> churchIdBetween(
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> churchIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> churchIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'churchId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> currentStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> currentStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> lastReadDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastReadDate',
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> lastReadDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastReadDate',
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> lastReadDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastReadDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> lastReadDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastReadDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> lastReadDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastReadDate',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> lastReadDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastReadDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> maxStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> maxStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> maxStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> maxStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> totalAnnotationsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalAnnotations',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> totalAnnotationsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalAnnotations',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> totalAnnotationsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalAnnotations',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> totalAnnotationsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalAnnotations',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> totalChaptersReadEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalChaptersRead',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> totalChaptersReadGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalChaptersRead',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> totalChaptersReadLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalChaptersRead',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> totalChaptersReadBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalChaptersRead',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
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

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension BibleReadingStatModelQueryObject on QueryBuilder<
    BibleReadingStatModel, BibleReadingStatModel, QFilterCondition> {}

extension BibleReadingStatModelQueryLinks on QueryBuilder<BibleReadingStatModel,
    BibleReadingStatModel, QFilterCondition> {}

extension BibleReadingStatModelQuerySortBy
    on QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QSortBy> {
  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByLastReadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadDate', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByLastReadDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadDate', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByMaxStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxStreak', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByMaxStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxStreak', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByTotalAnnotations() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnnotations', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByTotalAnnotationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnnotations', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByTotalChaptersRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersRead', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByTotalChaptersReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersRead', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BibleReadingStatModelQuerySortThenBy
    on QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QSortThenBy> {
  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByChurchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByChurchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'churchId', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByLastReadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadDate', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByLastReadDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastReadDate', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByMaxStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxStreak', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByMaxStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxStreak', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByTotalAnnotations() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnnotations', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByTotalAnnotationsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAnnotations', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByTotalChaptersRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersRead', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByTotalChaptersReadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalChaptersRead', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BibleReadingStatModelQueryWhereDistinct
    on QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QDistinct> {
  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QDistinct>
      distinctByChurchId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'churchId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QDistinct>
      distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QDistinct>
      distinctByLastReadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastReadDate');
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QDistinct>
      distinctByMaxStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxStreak');
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QDistinct>
      distinctByTotalAnnotations() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAnnotations');
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QDistinct>
      distinctByTotalChaptersRead() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalChaptersRead');
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<BibleReadingStatModel, BibleReadingStatModel, QDistinct>
      distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension BibleReadingStatModelQueryProperty on QueryBuilder<
    BibleReadingStatModel, BibleReadingStatModel, QQueryProperty> {
  QueryBuilder<BibleReadingStatModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BibleReadingStatModel, String, QQueryOperations>
      churchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'churchId');
    });
  }

  QueryBuilder<BibleReadingStatModel, int, QQueryOperations>
      currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<BibleReadingStatModel, DateTime?, QQueryOperations>
      lastReadDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastReadDate');
    });
  }

  QueryBuilder<BibleReadingStatModel, int, QQueryOperations>
      maxStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxStreak');
    });
  }

  QueryBuilder<BibleReadingStatModel, int, QQueryOperations>
      totalAnnotationsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAnnotations');
    });
  }

  QueryBuilder<BibleReadingStatModel, int, QQueryOperations>
      totalChaptersReadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalChaptersRead');
    });
  }

  QueryBuilder<BibleReadingStatModel, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<BibleReadingStatModel, String, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PlanDayModelSchema = Schema(
  name: r'PlanDayModel',
  id: 4722248224316589857,
  properties: {
    r'dayNumber': PropertySchema(
      id: 0,
      name: r'dayNumber',
      type: IsarType.long,
    ),
    r'references': PropertySchema(
      id: 1,
      name: r'references',
      type: IsarType.stringList,
    ),
    r'title': PropertySchema(
      id: 2,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _planDayModelEstimateSize,
  serialize: _planDayModelSerialize,
  deserialize: _planDayModelDeserialize,
  deserializeProp: _planDayModelDeserializeProp,
);

int _planDayModelEstimateSize(
  PlanDayModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.references;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _planDayModelSerialize(
  PlanDayModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dayNumber);
  writer.writeStringList(offsets[1], object.references);
  writer.writeString(offsets[2], object.title);
}

PlanDayModel _planDayModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlanDayModel();
  object.dayNumber = reader.readLongOrNull(offsets[0]);
  object.references = reader.readStringList(offsets[1]);
  object.title = reader.readStringOrNull(offsets[2]);
  return object;
}

P _planDayModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PlanDayModelQueryFilter
    on QueryBuilder<PlanDayModel, PlanDayModel, QFilterCondition> {
  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      dayNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dayNumber',
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      dayNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dayNumber',
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      dayNumberEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      dayNumberGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      dayNumberLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dayNumber',
        value: value,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      dayNumberBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dayNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'references',
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'references',
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'references',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'references',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'references',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'references',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'references',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'references',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'references',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'references',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'references',
        value: '',
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'references',
        value: '',
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'references',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'references',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'references',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'references',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'references',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      referencesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'references',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
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

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
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

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<PlanDayModel, PlanDayModel, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension PlanDayModelQueryObject
    on QueryBuilder<PlanDayModel, PlanDayModel, QFilterCondition> {}
