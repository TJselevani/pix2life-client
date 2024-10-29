import 'package:dio/dio.dart';
import 'package:pix2life/core/dtos/delete_data_dto.dart';
import 'package:pix2life/core/dtos/fetch_image_response_dto.dart';
import 'package:pix2life/core/dtos/update_image_response_dto.dart';
import 'package:pix2life/core/dtos/upload_image_match_dto.dart';
import 'package:pix2life/core/dtos/upload_image_response_dto.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/image/data/data%20sources/image_service.dart';
import 'package:pix2life/src/features/image/data/models/image.model.dart';

abstract interface class ImageRemoteDataSource {
  Future<String> deleteImage({
    required String imageId,
  });

  Future<List<ImageModel>> fetchImages();

  Future<ImageModel> matchImage({
    required FormData formData,
  });

  Future<ImageModel> updateImage({
    required ImageModel image,
    required DataMap updateData
  });

  Future<String> uploadAvatar({
    required FormData formData,
  });

  Future<String> uploadImage(
      {required FormData formData, required String galleryName});
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final ImageService _imageService;
  ImageRemoteDataSourceImpl(this._imageService);
  final logger = createLogger(ImageRemoteDataSourceImpl);

  @override
  Future<String> deleteImage({required String imageId}) async {
    try {
      final DeleteDataResponse response =
          await _imageService.deleteImage(imageId);
      final message = response.message;
      logger.i(message);
      return imageId;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<ImageModel>> fetchImages() async {
    try {
      final FetchImagesResponse response = await _imageService.fetchImages();
      final List<ImageModel> images = response.images;
      logger.i('Retrieved ${images.length} images');
      return images;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<ImageModel> matchImage({required FormData formData}) async {
    try {
      final UploadImageMatchResponse response =
          await _imageService.matchImage(formData);
      final ImageModel image = response.image;
      final String message = response.message;
      logger.i(message);
      return image;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<ImageModel> updateImage({required ImageModel image, required DataMap updateData}) async {
    try {
      final UpdateImageResponse response =
          await _imageService.updateImage(image, updateData);
      final ImageModel updatedImage = response.updatedImage;
      final String message = response.message;
      logger.i(message);
      return updatedImage;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> uploadAvatar({required FormData formData}) async {
    try {
      final UploadImageResponse response =
          await _imageService.uploadAvatar(formData);
      final String message = response.message;
      logger.i(message);
      return message;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> uploadImage(
      {required FormData formData, required String galleryName}) async {
    try {
      final UploadImageResponse response =
          await _imageService.uploadImage(formData, galleryName);
      final String message = response.message;
      logger.i(message);
      return message;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }
}
