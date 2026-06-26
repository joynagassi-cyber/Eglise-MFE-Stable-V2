import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/sheet_music.dart';

part 'sheet_music_model.g.dart';

@collection
class SheetMusicModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index(caseSensitive: false)
  String? title;

  @Index(caseSensitive: false)
  String? composer;

  String? category;

  late String fileUrl;

  @Index()
  late String groupId;

  @Index()
  late String churchId;

  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdBy;

  bool isDeleted = false;
  DateTime? lastSyncedAt;

  String? jsonData;

  static SheetMusicModel fromDomain(SheetMusic sheetMusic) {
    return SheetMusicModel()
      ..id = sheetMusic.id
      ..title = sheetMusic.title
      ..composer = sheetMusic.composer
      ..category = sheetMusic.category
      ..fileUrl = sheetMusic.fileUrl
      ..groupId = sheetMusic.groupId
      ..churchId = sheetMusic.churchId
      ..createdAt = sheetMusic.createdAt
      ..updatedAt = sheetMusic.updatedAt
      ..createdBy = sheetMusic.createdBy
      ..lastSyncedAt = DateTime.now()
      ..jsonData = jsonEncode(sheetMusic.toJson());
  }

  SheetMusic toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return SheetMusic.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return SheetMusic(
      id: id,
      title: title ?? '',
      composer: composer,
      category: category,
      fileUrl: fileUrl,
      groupId: groupId,
      churchId: churchId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
    );
  }
}