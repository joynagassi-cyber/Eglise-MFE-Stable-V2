class Commentaire {
  final String id;
  final String annonceId;
  final String authorId;
  final String authorName;
  final String authorAvatarUrl;
  final String content;
  final DateTime date;
  String? parentId;
  List<String> likes;
  int repliesCount;
  bool isApproved;
  DateTime? createdAt;
  DateTime? updatedAt;

  Commentaire({
    required this.id,
    required this.annonceId,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.content,
    required this.date,
    this.parentId,
    this.likes = const [],
    this.repliesCount = 0,
    this.isApproved = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Commentaire.fromJson(Map<String, dynamic> json) {
    return Commentaire(
      id: json['id']?.toString() ?? '',
      annonceId:
          json['post_id']?.toString() ?? json['annonce_id']?.toString() ?? '',
      authorId: json['author_id']?.toString() ?? '',
      authorName: json['author_name']?.toString() ?? 'Anonyme',
      authorAvatarUrl: json['author_avatar_url']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      date: DateTime.tryParse(
            json['date']?.toString() ?? json['created_at']?.toString() ?? '',
          ) ??
          DateTime.now(),
      parentId: json['parent_id']?.toString(),
      likes: List<String>.from(json['likes'] ?? []),
      repliesCount: json['replies_count'] ?? 0,
      isApproved: json['is_approved'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': annonceId,
      'author_id': authorId,
      'author_name': authorName,
      'author_avatar_url': authorAvatarUrl,
      'content': content,
      'date': date.toIso8601String(),
      'parent_id': parentId,
      'likes': likes,
      'is_approved': isApproved,
    };
  }

  bool get hasParent => parentId != null && parentId!.isNotEmpty;
  // ...
  bool get isLiked => false;
  int get likesCount => likes.length;
}