import 'package:dio/dio.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';

abstract interface class VideoRepository {
  const VideoRepository();

  ResultFuture<String> uploadVideo({
    required FormData formData,
    required String galleryName,
  });

  ResultFuture<List<Video>> fetchVideos();

  ResultFuture<Video> updateVideo({
    required Video video,
    required DataMap updateData,
  });

  ResultFuture<String> deleteVideo({
    required String videoId,
  });
}
