import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/api_failure.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/data/data%20sources/video_remote_data_source.dart';
import 'package:pix2life/src/features/video/data/models/video.model.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/features/video/domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  late final VideoRemoteDataSource _remoteDataSource;
  VideoRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<String> deleteVideo({required String videoId}) async {
    try {
      final message = await _remoteDataSource.deleteVideo(videoId: videoId);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<List<VideoModel>> fetchVideos() async {
    try {
      final videos = await _remoteDataSource.fetchVideos();
      return right(videos);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<VideoModel> updateVideo({required Video video, required DataMap updateData}) async {
    try {
      final updatedVideo = await _remoteDataSource.updateVideo(
        updateData: updateData,
          video: VideoModel(
        id: video.id,
        filename: video.filename,
        path: video.path,
        originalName: video.originalName,
        galleryName: video.galleryName,
        ownerId: video.ownerId,
        description: video.description,
        url: video.url,
        createdAt: video.createdAt,
        updatedAt: video.updatedAt,
      ));
      return right(updatedVideo);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<String> uploadVideo(
      {required FormData formData, required String galleryName}) async {
    try {
      final message = await _remoteDataSource.uploadVideo(
          formData: formData, galleryName: galleryName);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }
}
