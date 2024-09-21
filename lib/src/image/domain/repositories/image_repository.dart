import 'package:dio/dio.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/image/domain/entities/image.dart';

abstract interface class ImageRepository {
  ResultFuture<Image> uploadImage({
    required FormData formData,
    required String galleryName,
  });

  ResultFuture<Image> uploadAvatar({
    required FormData formData,
  });

  ResultFuture<Image> matchImage({
    required FormData formData,
  });

  ResultFuture<List<Image>> fetchImages();

  ResultFuture<Image>  updateImage({
    required Map<String, dynamic> updateData,
    required String imageId,
  });

  ResultFuture<String> deleteImage({
    required String imageId,
  });
}
