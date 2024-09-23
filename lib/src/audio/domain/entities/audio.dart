import 'package:equatable/equatable.dart';

class Audio extends Equatable {
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

  const Audio({
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
  });

  @override
  List<Object?> get props => [id, ownerId, url];
}
