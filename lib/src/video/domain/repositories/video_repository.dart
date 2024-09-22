import 'package:dio/dio.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/video/data/models/video.model.dart';

abstract interface class VideoRepository {
  const VideoRepository();

  ResultFuture<String> uploadVideo({
    required FormData formData,
    required String galleryName,
  });

  ResultFuture<List<VideoModel>> fetchVideos();

  ResultFuture<VideoModel> updateVideo({
    required VideoModel updateData,
    required String videoId,
  });

  ResultFuture<String> deleteVideo({
    required String videoId,
  });
}
