import 'package:equatable/equatable.dart';

class Image extends Equatable {
  final String id;
  final String filename;
  final String path;
  final String originalName;
  final String galleryName;
  final String ownerId;
  final String description;
  final String url;
  final List<List<dynamic>> features;
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

  @override
  List<Object> get props => [id];
}
