import 'package:pix2life/src/features/video/data/models/video.model.dart';

class FetchVideoResponse {
  final List<VideoModel> videos;

  FetchVideoResponse({required this.videos});

  factory FetchVideoResponse.fromJson(List json) {
    var videosJson = json;
    List<VideoModel> videoList =
        videosJson.map((video) => VideoModel.fromJson(video)).toList();

    return FetchVideoResponse(
      videos: videoList,
    );
  }
}
