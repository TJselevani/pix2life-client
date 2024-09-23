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

  ResultFuture<Image> matchImage({
    required FormData formData,
  });

  ResultFuture<List<Image>> fetchImages();

  ResultFuture<Image> updateImage({
    required Image image,
  });

  ResultFuture<String> deleteImage({
    required String imageId,
  });
}
