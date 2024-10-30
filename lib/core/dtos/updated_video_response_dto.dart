import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/data/models/video.model.dart';

class UpdatedVideoResponse {
  final String message;
  final VideoModel updatedVideo;

  UpdatedVideoResponse({
    required this.message,
    required this.updatedVideo,
  });

  factory UpdatedVideoResponse.fromJson(DataMap json) {
    final DataMap videoData = json['updatedVideo'];
    final VideoModel video = VideoModel.fromJson(videoData);
    return UpdatedVideoResponse(
      message: json['message'],
      updatedVideo: video,
    );
  }
}
