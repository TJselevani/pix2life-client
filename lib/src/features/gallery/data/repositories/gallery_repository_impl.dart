import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/api_failure.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/data/models/audio.model.dart';
import 'package:pix2life/src/features/gallery/data/data_source/gallery_remote_data_source.dart';
import 'package:pix2life/src/features/gallery/data/models/gallery.model.dart';
import 'package:pix2life/src/features/gallery/domain/repositories/gallery_repository.dart';
import 'package:pix2life/src/features/image/data/models/image.model.dart';
import 'package:pix2life/src/features/video/data/models/video.model.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  late final GalleryRemoteDataSource _remoteDataSource;
  GalleryRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<String> createGallery({required FormData formData}) async {
    try {
      final message = await _remoteDataSource.createGallery(formData: formData);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<List<AudioModel>> fetchAudiosByGallery(
      {required String galleryName}) async {
    try {
      final audios = await _remoteDataSource.fetchAudiosByGallery(
          galleryName: galleryName);
      return right(audios);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<List<GalleryModel>> fetchGalleries() async {
    try {
      final galleries = await _remoteDataSource.fetchGalleries();
      return right(galleries);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<List<ImageModel>> fetchImagesByGallery(
      {required String galleryName}) async {
    try {
      final images = await _remoteDataSource.fetchImagesByGallery(
          galleryName: galleryName);
      return right(images);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<List<VideoModel>> fetchVideosByGallery(
      {required String galleryName}) async {
    try {
      final videos = await _remoteDataSource.fetchVideosByGallery(
          galleryName: galleryName);
      return right(videos);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }
}
