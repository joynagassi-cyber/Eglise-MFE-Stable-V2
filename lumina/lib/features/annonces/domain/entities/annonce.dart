class Annonce {
  final String id;
  final String churchId;
  final String type;
  final String title;
  final String? content;
  final String? summary;
  final String? imageUrl;
  final String? groupId;
  final String? authorId;
  final String? authorName;
  final DateTime date;
  final DateTime? publishedAt;
  final bool isPublished;
  final bool isPinned;
  final int? viewsCount;
  final int? likesCount;
  final String? tags;
  final String? category;
  final String? status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? createdBy;
  final String? updatedBy;
  final bool isSynced;

  Annonce({
    required this.id,
    required this.churchId,
    required this.type,
    required this.title,
    this.content,
    this.summary,
    this.imageUrl,
    this.groupId,
    this.authorId,
    this.authorName,
    required this.date,
    this.publishedAt,
    this.isPublished = false,
    this.isPinned = false,
    this.viewsCount = 0,
    this.likesCount = 0,
    this.tags,
    this.category,
    this.status = 'BROUILLON',
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.isSynced = true,
  });

  Annonce copyWith({
    String? id,
    String? churchId,
    String? type,
    String? title,
    String? content,
    String? summary,
    String? imageUrl,
    String? groupId,
    String? authorId,
    String? authorName,
    DateTime? date,
    DateTime? publishedAt,
    bool? isPublished,
    bool? isPinned,
    int? viewsCount,
    int? likesCount,
    String? tags,
    String? category,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    bool? isSynced,
  }) {
    return Annonce(
      id: id ?? this.id,
      churchId: churchId ?? this.churchId,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      imageUrl: imageUrl ?? this.imageUrl,
      groupId: groupId ?? this.groupId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      date: date ?? this.date,
      publishedAt: publishedAt ?? this.publishedAt,
      isPublished: isPublished ?? this.isPublished,
      isPinned: isPinned ?? this.isPinned,
      viewsCount: viewsCount ?? this.viewsCount,
      likesCount: likesCount ?? this.likesCount,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      id: json['id']?.toString() ?? '',
      churchId: json['church_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString(),
      summary: json['summary']?.toString(),
      imageUrl: json['image_url']?.toString(),
      groupId: json['group_id']?.toString(),
      authorId: json['author_id']?.toString(),
      authorName: json['author_name']?.toString(),
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())
          : null,
      isPublished: json['is_published'] ?? false,
      isPinned: json['is_pinned'] ?? false,
      viewsCount: json['views_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
      tags: json['tags']?.toString(),
      category: json['category']?.toString(),
      status: json['status']?.toString() ?? 'BROUILLON',
      notes: json['notes']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      createdBy: json['created_by']?.toString(),
      updatedBy: json['updated_by']?.toString(),
      isSynced: json['is_synced'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'church_id': churchId,
      'type': type,
      'title': title,
      'content': content,
      'summary': summary,
      'image_url': imageUrl,
      'group_id': groupId,
      'author_id': authorId,
      'author_name': authorName,
      'date': date.toIso8601String(),
      'published_at': publishedAt?.toIso8601String(),
      'is_published': isPublished,
      'is_pinned': isPinned,
      'views_count': viewsCount,
      'likes_count': likesCount,
      'tags': tags,
      'category': category,
      'status': status,
      'notes': notes,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'is_synced': isSynced,
    };
  }

  String get displayName => title;
  // ... (reste du code inchangé)

  bool get isDraft => status == 'BROUILLON';
  bool get isPublishedStatus => isPublished;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  String? get firstImageUrl => imageUrl;

  List<String> get tagsList {
    if (tags == null || tags!.isEmpty) return [];
    return tags!
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }
}