class ProofImage {
  final String id;
  final String transactionId;
  final String originalUrl;
  final String? thumbnailUrl;
  final String sha256Client;
  final String? sha256Server;
  final int? fileSizeBytes;
  final String? driveFileId;
  final String? mimeType;
  final String? uploadedBy;
  final DateTime uploadedAt;

  const ProofImage({
    required this.id,
    required this.transactionId,
    required this.originalUrl,
    this.thumbnailUrl,
    required this.sha256Client,
    this.sha256Server,
    this.fileSizeBytes,
    this.driveFileId,
    this.mimeType,
    this.uploadedBy,
    required this.uploadedAt,
  });

  factory ProofImage.fromJson(Map<String, dynamic> json) {
    return ProofImage(
      id: json['id'],
      transactionId: json['transaction_id'],
      originalUrl: json['original_url'],
      thumbnailUrl: json['thumbnail_url'],
      sha256Client: json['sha256_client'],
      sha256Server: json['sha256_server'],
      fileSizeBytes: json['file_size_bytes'],
      driveFileId: json['drive_file_id'],
      mimeType: json['mime_type'],
      uploadedBy: json['uploaded_by'],
      uploadedAt: DateTime.parse(json['uploaded_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'original_url': originalUrl,
      'thumbnail_url': thumbnailUrl,
      'sha256_client': sha256Client,
      'sha256_server': sha256Server,
      'file_size_bytes': fileSizeBytes,
      'drive_file_id': driveFileId,
      'mime_type': mimeType,
      // id, uploaded_by, uploaded_at are managed by DB
    };
  }
}