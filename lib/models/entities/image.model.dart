class Image {
  final String id;
  final String filename;
  final String path;
  final String originalName;
  final String galleryName;
  final String ownerId;
  final String description;
  final String url;
  final List<List<dynamic>> features; // Assuming features is a list of lists
  final DateTime createdAt;
  final DateTime updatedAt;
  final String galleryId;

  Image({
    required this.id,
    required this.filename,
    required this.path,
    required this.originalName,
    required this.galleryName,
    required this.ownerId,
    required this.description,
    required this.url,
    required this.features,
    required this.createdAt,
    required this.updatedAt,
    required this.galleryId,
  });

  // Factory method to create an Image object from JSON
  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['id'],
      filename: json['filename'],
      path: json['path'],
      originalName: json['originalName'],
      galleryName: json['galleryName'],
      ownerId: json['ownerId'],
      description: json['description'],
      url: json['url'],
      features: List<List<dynamic>>.from(
          json['features'].map((x) => List<dynamic>.from(x))),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      galleryId: json['galleryId'] ?? '',
    );
  }
}
