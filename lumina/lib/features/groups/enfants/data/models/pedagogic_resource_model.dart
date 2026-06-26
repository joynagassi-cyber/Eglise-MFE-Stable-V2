import 'package:isar/isar.dart';
import '../../domain/entities/pedagogic_resource.dart';

part 'pedagogic_resource_model.g.dart';

@collection
class PedagogicResourceModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  late String title;
  late String category;
  String? fileUrl;
  String? ageRange;
  String? contentSummary;
  late DateTime createdAt;

  PedagogicResource toDomain() {
    return PedagogicResource(
      id: id,
      churchId: churchId,
      title: title,
      category: category,
      fileUrl: fileUrl,
      ageRange: ageRange,
      contentSummary: contentSummary,
      createdAt: createdAt,
    );
  }

  static PedagogicResourceModel fromDomain(PedagogicResource entity) {
    return PedagogicResourceModel()
      ..id = entity.id
      ..churchId = entity.churchId
      ..title = entity.title
      ..category = entity.category
      ..fileUrl = entity.fileUrl
      ..ageRange = entity.ageRange
      ..contentSummary = entity.contentSummary
      ..createdAt = entity.createdAt;
  }
}