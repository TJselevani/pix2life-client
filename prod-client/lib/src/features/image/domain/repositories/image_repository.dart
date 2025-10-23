import 'package:dio/dio.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';

abstract interface class ImageRepository {
  ResultFuture<String> uploadImage({
    required FormData formData,
    required String galleryName,
  });

  ResultFuture<String> uploadAvatar({
    required FormData formData,
  });

  ResultFuture<Photo> matchImage({
    required FormData formData,
  });

  ResultFuture<List<Photo>> fetchImages();

  ResultFuture<Photo> updateImage({
    required Photo image,
    required DataMap updateData,
  });

  ResultFuture<String> deleteImage({
    required String imageId,
  });
}
