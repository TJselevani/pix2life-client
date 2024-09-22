import 'package:dio/src/form_data.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/api_failure.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/image/data/data%20sources/image_remote_data_source.dart';
import 'package:pix2life/src/image/domain/entities/image.dart';
import 'package:pix2life/src/image/domain/repositories/image_repository.dart';

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
  ResultFuture<List<Image>> fetchImages() async {
    try {
      final imageList = await _remoteDataSource.fetchImages();
      return right(imageList);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<Image> matchImage({required FormData formData}) async {
    try {
      final matchedImage =
          await _remoteDataSource.matchImage(formData: formData);
      return right(matchedImage);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<Image> updateImage(
      {required DataMap updateData, required String imageId}) async {
    try {
      final updatedImage = await _remoteDataSource.updateImage(
          updateData: updateData, imageId: imageId);
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
