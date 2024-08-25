import 'package:pix2life/models/entities/video.model.dart';

class FetchVideoResponse {
  final List<Video> video;

  FetchVideoResponse({required this.video});

  factory FetchVideoResponse.fromJson(Map<String, dynamic> json) {
    var videoJson = json['video'] as List;
    List<Video> videoList =
        videoJson.map((image) => Video.fromJson(image)).toList();

    return FetchVideoResponse(
      video: videoList,
    );
  }
}
