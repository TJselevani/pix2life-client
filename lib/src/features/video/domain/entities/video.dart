import 'package:equatable/equatable.dart';

class Video extends Equatable {
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

  const Video({
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

  Video.empty()
      : this(
          id: '1',
          filename: '_empty.filename',
          path: '_empty.filepath',
          originalName: '_empty.originalName',
          galleryName: '_empty.galleryName',
          ownerId: '_empty.ownerId',
          description: '_empty.description',
          url: '_empty.url',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

  @override
  List<Object> get props => [id, ownerId, url];
}
