import 'package:dio/dio.dart';
import 'package:pix2life/core/dtos/delete_data_dto.dart';
import 'package:pix2life/core/dtos/fetch_video_response_dto.dart';
import 'package:pix2life/core/dtos/updated_video_response_dto.dart';
import 'package:pix2life/core/dtos/upload_video_response_dto.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/data/data%20sources/video_service.dart';
import 'package:pix2life/src/features/video/data/models/video.model.dart';

abstract interface class VideoRemoteDataSource {
  Future<String> uploadVideo(
      {required FormData formData, required String galleryName});

  Future<List<VideoModel>> fetchVideos();

  Future<VideoModel> updateVideo({
    required VideoModel video,
    required DataMap updateData,
  });

  Future<String> deleteVideo({required String videoId});
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final VideoService _videoService;
  VideoRemoteDataSourceImpl(this._videoService);
  final logger = createLogger(VideoRemoteDataSourceImpl);

  @override
  Future<String> deleteVideo({required String videoId}) async {
    try {
      final DeleteDataResponse response =
          await _videoService.deleteVideo(videoId);
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
  Future<List<VideoModel>> fetchVideos() async {
    try {
      final FetchVideoResponse response = await _videoService.fetchVideos();
      final List<VideoModel> videos = response.videos;
      logger.i('Retrieved ${videos.length} Videos');
      return videos;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<VideoModel> updateVideo({
    required VideoModel video,
    required DataMap updateData,
  }) async {
    try {
      final UpdatedVideoResponse response =
          await _videoService.updateVideo(video, updateData);
      final message = response.message;
      final updateVideo = response.updatedVideo;
      logger.i(message);
      return updateVideo;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> uploadVideo(
      {required FormData formData, required String galleryName}) async {
    try {
      final UploadVideoResponse response =
          await _videoService.uploadVideo(formData, galleryName);
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
}
