import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/annonce.dart';
import '../../domain/entities/commentaire.dart';

part 'annonce_model.g.dart';

@collection
class AnnonceModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  @Index()
  late String type;

  @Index()
  late DateTime date;

  @Index(caseSensitive: false)
  String? title;
  @Index(caseSensitive: false)
  String? content;
  @Index(caseSensitive: false)
  String? summary;
  String? imageUrl;
  String? groupId;
  String? authorId;
  String? authorName;
  DateTime? publishedAt;
  bool isPublished = false;
  bool isPinned = false;
  int viewsCount = 0;
  int likesCount = 0;
  String? tags;
  String? category;
  String status = 'BROUILLON';
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdBy;
  String? updatedBy;

  int version = 1;
  String deviceId = 'unknown';

  bool isDeleted = false;
  DateTime? deletedAt;
  String? deletedBy;
  DateTime? lastSyncedAt;

  String? jsonData;

  static AnnonceModel fromDomain(Annonce annonce) {
    return AnnonceModel()
      ..id = annonce.id
      ..churchId = annonce.churchId
      ..type = annonce.type
      ..date = annonce.date
      ..title = annonce.title
      ..content = annonce.content
      ..summary = annonce.summary
      ..imageUrl = annonce.imageUrl
      ..groupId = annonce.groupId
      ..authorId = annonce.authorId
      ..authorName = annonce.authorName
      ..publishedAt = annonce.publishedAt
      ..isPublished = annonce.isPublished
      ..isPinned = annonce.isPinned
      ..viewsCount = annonce.viewsCount ?? 0
      ..likesCount = annonce.likesCount ?? 0
      ..tags = annonce.tags
      ..category = annonce.category
      ..status = annonce.status ?? 'BROUILLON'
      ..notes = annonce.notes
      ..createdAt = annonce.createdAt
      ..updatedAt = annonce.updatedAt
      ..createdBy = annonce.createdBy
      ..updatedBy = annonce.updatedBy
      ..lastSyncedAt = DateTime.now()
      ..jsonData = jsonEncode(annonce.toJson());
  }

  Annonce toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Annonce.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Annonce(
      id: id,
      churchId: churchId,
      type: type,
      date: date,
      title: title ?? '',
      content: content,
      summary: summary,
      imageUrl: imageUrl,
      groupId: groupId,
      authorId: authorId,
      authorName: authorName,
      publishedAt: publishedAt,
      isPublished: isPublished,
      isPinned: isPinned,
      viewsCount: viewsCount,
      likesCount: likesCount,
      tags: tags,
      category: category,
      status: status,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }
}

@collection
class CommentaireModel {
  Id isarId = Isar.autoIncrement;

  @Index()
  late String id;

  @Index()
  late String annonceId;

  late String authorId;
  late String authorName;
  late String authorAvatarUrl;
  late String content;
  late DateTime date;

  String? parentId;
  List<String> likes = [];
  int repliesCount = 0;
  bool isApproved = false;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdBy;
  String? updatedBy;

  @Index()
  String? churchId;

  int version = 1;
  String deviceId = 'unknown';

  bool isDeleted = false;
  DateTime? deletedAt;
  String? deletedBy;
  DateTime? lastSyncedAt;

  String? jsonData;

  static CommentaireModel fromDomain(Commentaire commentaire) {
    return CommentaireModel()
      ..id = commentaire.id
      ..annonceId = commentaire.annonceId
      ..authorId = commentaire.authorId
      ..authorName = commentaire.authorName
      ..authorAvatarUrl = commentaire.authorAvatarUrl
      ..content = commentaire.content
      ..date = commentaire.date
      ..parentId = commentaire.parentId
      ..likes = commentaire.likes
      ..repliesCount = commentaire.repliesCount
      ..isApproved = commentaire.isApproved
      ..createdAt = commentaire.createdAt
      ..updatedAt = commentaire.updatedAt
      ..jsonData = jsonEncode(commentaire.toJson());
  }

  Commentaire toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Commentaire.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Commentaire(
      id: id,
      annonceId: annonceId,
      authorId: authorId,
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      content: content,
      date: date,
      parentId: parentId,
      likes: likes,
      repliesCount: repliesCount,
      isApproved: isApproved,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}