import 'package:freezed_annotation/freezed_annotation.dart';

part 'pedagogic_resource.freezed.dart';
part 'pedagogic_resource.g.dart';
// ignore_for_file: invalid_annotation_target

@freezed
class PedagogicResource with _$PedagogicResource {
  const factory PedagogicResource({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    required String title,
    required String category, // 'lesson', 'game', 'media'
    String? fileUrl,
    String? ageRange,
    String? contentSummary,
    required DateTime createdAt,
  }) = _PedagogicResource;

  factory PedagogicResource.fromJson(Map<String, dynamic> json) =>
      _$PedagogicResourceFromJson(json);
}