import 'package:freezed_annotation/freezed_annotation.dart';

part 'sheet_music.freezed.dart';
part 'sheet_music.g.dart';

@freezed
class SheetMusic with _$SheetMusic {
  const SheetMusic._();

  const factory SheetMusic({
    required String id,
    required String title,
    String? composer,
    String? category,
    required String fileUrl,
    required String groupId,
    required String churchId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) = _SheetMusic;

  factory SheetMusic.fromJson(Map<String, dynamic> json) =>
      _$SheetMusicFromJson(json);

  String get displayName => title;
}