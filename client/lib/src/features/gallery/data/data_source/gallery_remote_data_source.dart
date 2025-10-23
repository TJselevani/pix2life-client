import 'package:dio/dio.dart';
import 'package:pix2life/core/dtos/create_gallery_dto.dart';
import 'package:pix2life/core/dtos/fetch_audio_response_dto.dart';
import 'package:pix2life/core/dtos/fetch_gallery_dto.dart';
import 'package:pix2life/core/dtos/fetch_image_response_dto.dart';
import 'package:pix2life/core/dtos/fetch_video_response_dto.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/src/features/audio/data/models/audio.model.dart';
import 'package:pix2life/src/features/gallery/data/data_source/gallery_service.dart';
import 'package:pix2life/src/features/gallery/data/models/gallery.model.dart';
import 'package:pix2life/src/features/image/data/models/image.model.dart';
import 'package:pix2life/src/features/video/data/models/video.model.dart';

abstract interface class GalleryRemoteDataSource {
  Future<String> createGallery({required FormData formData});

  Future<List<GalleryModel>> fetchGalleries();

  Future<List<ImageModel>> fetchImagesByGallery({required String galleryName});

  Future<List<AudioModel>> fetchAudiosByGallery({required String galleryName});

  Future<List<VideoModel>> fetchVideosByGallery({required String galleryName});
}

class GalleryRemoteDataSourceImpl implements GalleryRemoteDataSource {
  final GalleryService _galleryService;
  GalleryRemoteDataSourceImpl(this._galleryService);
  final logger = createLogger(GalleryRemoteDataSourceImpl);

  @override
  Future<String> createGallery({required FormData formData}) async {
    try {
      final CreateGalleryResponse response =
          await _galleryService.createGallery(formData);
      final message = response.message;
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
  Future<List<AudioModel>> fetchAudiosByGallery(
      {required String galleryName}) async {
    try {
      final FetchAudiosResponse response =
          await _galleryService.fetchAudiosByGallery(galleryName);
      final audios = response.audios;
      return audios;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<GalleryModel>> fetchGalleries() async {
    try {
      final FetchGalleriesResponse response =
          await _galleryService.fetchGalleries();
      final List<GalleryModel> galleries = response.galleries;
      final message = response.message;
      logger.i('retrieved ${galleries.length} galleries');
      logger.i(message);
      return galleries;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<ImageModel>> fetchImagesByGallery(
      {required String galleryName}) async {
    try {
      final FetchImagesResponse response =
          await _galleryService.fetchImagesByGallery(galleryName);
      final List<ImageModel> images = response.images;
      return images;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<VideoModel>> fetchVideosByGallery(
      {required String galleryName}) async {
    try {
      final FetchVideoResponse response =
          await _galleryService.fetchVideosByGallery(galleryName);
      final List<VideoModel> videos = response.videos;
      return videos;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }
}
