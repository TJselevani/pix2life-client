class UpdatedVideoResponse {
  final String message;
  final dynamic updatedVideo;

  UpdatedVideoResponse({
    required this.message,
    required this.updatedVideo,
  });

  factory UpdatedVideoResponse.fromJson(Map<String, dynamic> json) {
    return UpdatedVideoResponse(
      message: json['message'],
      updatedVideo: json['updatedVideo'],
    );
  }
}
