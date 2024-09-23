import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/video/data/models/video.model.dart';

class FetchVideoResponse {
  final List<VideoModel> videos;

  FetchVideoResponse({required this.videos});

  factory FetchVideoResponse.fromJson(DataMap json) {
    var videosJson = json['video'] as List;
    List<VideoModel> videoList =
        videosJson.map((video) => VideoModel.fromJson(video)).toList();

    return FetchVideoResponse(
      videos: videoList,
    );
  }
}
