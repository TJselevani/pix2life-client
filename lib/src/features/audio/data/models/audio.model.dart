import 'dart:convert';

import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';

class AudioModel extends Audio {
  const AudioModel({
    required super.id,
    required super.filename,
    required super.path,
    required super.originalName,
    required super.galleryName,
    required super.ownerId,
    required super.description,
    required super.url,
    required super.createdAt,
    required super.updatedAt,
  });

  AudioModel.empty()
      : this(
          id: '1',
          filename: '_empty.filename',
          path: '_empty.path',
          originalName: '_empty.originalName',
          galleryName: '_empty.galleryName',
          ownerId: '_empty.ownerId',
          description: '_empty.description',
          url: '_empty.url',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

  // Factory method to create an Audio object from JSON
  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
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
    );
  }

  factory AudioModel.fromJSON(String source) =>
      AudioModel.fromMap(jsonDecode(source) as DataMap);

  AudioModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          filename: map['filename'] as String,
          path: map['path'] as String,
          originalName: map['originalName'] as String,
          galleryName: map['galleryName'] as String,
          ownerId: map['ownerId'] as String,
          description: map['description'] as String,
          url: map['url'] as String,
          createdAt: DateTime.parse(map['createdAt'] as String),
          updatedAt: DateTime.parse(map['updatedAt'] as String),
        );
  DataMap toMap() => {
        "id": id,
        "filename": filename,
        "path": path,
        "originalName": originalName,
        "galleryName": galleryName,
        "ownerId": ownerId,
        "description": description,
        "url": url,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  AudioModel copyWith({
    String? id,
    String? filename,
    String? path,
    String? originalName,
    String? galleryName,
    String? ownerId,
    String? description,
    String? url,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      AudioModel(
        id: this.id,
        filename: filename ?? this.filename,
        path: path ?? this.path,
        originalName: this.originalName,
        galleryName: galleryName ?? this.galleryName,
        ownerId: this.ownerId,
        description: description ?? this.description,
        url: this.url,
        createdAt: this.createdAt,
        updatedAt: this.updatedAt,
      );

  @override
  List<Object?> get props => [id, ownerId, url];
}
