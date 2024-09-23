import 'dart:convert';

import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';

class GalleryModel extends Gallery {
  const GalleryModel({
    required super.id,
    required super.name,
    required super.iconUrl,
    required super.description,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
  });

  GalleryModel.empty()
      : this(
          id: '1',
          name: '_empty.name',
          iconUrl: '_empty.iconUrl',
          description: '_empty.description',
          userId: '_empty.userId',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      id: json['id'],
      name: json['name'],
      iconUrl: json['iconUrl'] ?? '',
      description: json['description'] ?? '',
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  factory GalleryModel.fromJSON(String source) =>
      GalleryModel.fromMap(jsonDecode(source) as DataMap);

  GalleryModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          iconUrl: map['iconUrl'] as String,
          description: map['description'] as String,
          userId: map['userId'] as String,
          createdAt: DateTime.parse(map['createdAt'] as String),
          updatedAt: DateTime.parse(map['updatedAt'] as String),
        );

  DataMap toMap() => {
        "id": id,
        "name": name,
        "iconUrl": iconUrl,
        "description": description,
        "userId": userId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  GalleryModel copyWith({
    String? id,
    String? name,
    String? iconUrl,
    String? description,
    String? userId,
    String? createdAt,
    String? updatedAt,
  }) =>
      GalleryModel(
        id: this.id,
        name: name ?? this.name,
        iconUrl: iconUrl ?? this.iconUrl,
        description: description ?? this.description,
        userId: this.userId,
        createdAt: this.createdAt,
        updatedAt: this.updatedAt,
      );

  @override
  List<Object?> get props => [id, iconUrl, userId];
}
