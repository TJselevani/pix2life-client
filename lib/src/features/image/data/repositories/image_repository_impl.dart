import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/api_failure.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/image/data/data%20sources/image_remote_data_source.dart';
import 'package:pix2life/src/features/image/data/models/image.model.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';
import 'package:pix2life/src/features/image/domain/repositories/image_repository.dart';

class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource _remoteDataSource;
  const ImageRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<String> deleteImage({required String imageId}) async {
    try {
      final message = await _remoteDataSource.deleteImage(imageId: imageId);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<List<ImageModel>> fetchImages() async {
    try {
      final imageList = await _remoteDataSource.fetchImages();
      return right(imageList);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<ImageModel> matchImage({required FormData formData}) async {
    try {
      final matchedImage =
          await _remoteDataSource.matchImage(formData: formData);
      return right(matchedImage);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<ImageModel> updateImage(
      {required Photo image, required DataMap updateData}) async {
    try {
      final updatedImage = await _remoteDataSource.updateImage(
          updateData: updateData,
          image: ImageModel(
            id: image.id,
            filename: updateData['filename'] ?? image.filename,
            path: image.path,
            originalName: image.originalName,
            galleryName: updateData['galleryName'] ?? image.galleryName,
            ownerId: image.ownerId,
            description: updateData['description'] ?? image.description,
            url: image.url,
            createdAt: image.createdAt,
            updatedAt: image.updatedAt,
          ));
      return right(updatedImage);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<String> uploadAvatar({required FormData formData}) async {
    try {
      final uploadedAvatarImage =
          await _remoteDataSource.uploadAvatar(formData: formData);
      return right(uploadedAvatarImage);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<String> uploadImage(
      {required FormData formData, required String galleryName}) async {
    try {
      final uploadedAvatarImage = await _remoteDataSource.uploadImage(
          formData: formData, galleryName: galleryName);
      return right(uploadedAvatarImage);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }
}
