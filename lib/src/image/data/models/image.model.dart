import 'package:pix2life/src/image/domain/entities/image.dart';

class ImageModel extends Image {
  ImageModel({
    required super.id,
    required super.filename,
    required super.path,
    required super.originalName,
    required super.galleryName,
    required super.ownerId,
    required super.description,
    required super.url,
    required super.features,
    required super.createdAt,
    required super.updatedAt,
    required super.galleryId,
  });

  // Factory method to create an ImageModel object from JSON
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
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
