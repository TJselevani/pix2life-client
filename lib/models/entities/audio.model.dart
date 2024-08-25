class Audio {
  final String id;
  final String filename;
  final String path;
  final String originalName;
  final String galleryName;
  final String ownerId;
  final String description;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String galleryId;

  Audio({
    required this.id,
    required this.filename,
    required this.path,
    required this.originalName,
    required this.galleryName,
    required this.ownerId,
    required this.description,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.galleryId,
  });

  // Factory method to create an Audio object from JSON
  factory Audio.fromJson(Map<String, dynamic> json) {
    return Audio(
      id: json['id'],
      filename: json['filename'],
      path: json['path'],
      originalName: json['originalName'],
      galleryName: json['galleryName'],
      ownerId: json['ownerId'],
      description: json['description'],
      url: json['url'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      galleryId: json['galleryId'] ?? '',
    );
  }
}
