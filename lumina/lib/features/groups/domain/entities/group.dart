import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';
// ignore_for_file: invalid_annotation_target

enum GroupType {
  @JsonValue('cellule')
  cellule,
  @JsonValue('ministere')
  ministere,
  @JsonValue('equipe')
  equipe,
  @JsonValue('chorale')
  chorale,
  @JsonValue('hommes')
  hommes,
  @JsonValue('femmes')
  femmes,
  @JsonValue('jeunesse')
  jeunesse,
  @JsonValue('enfants')
  enfants,
  @JsonValue('intercession')
  intercession,
  @JsonValue('autre')
  autre,
}

@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'label') required String name,
    String? description,
    @Default(GroupType.autre)
    @JsonKey(name: 'code', unknownEnumValue: GroupType.autre)
    GroupType type,
    @JsonKey(name: 'leader_id') String? leaderId,
    String? location,
    @JsonKey(name: 'schedule_description') String? scheduleDescription,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default(true) @JsonKey(name: 'is_active') bool isActive,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}