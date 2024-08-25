class UploadVideoResponse {
  final String message;

  UploadVideoResponse({required this.message});

  factory UploadVideoResponse.fromJson(Map<String, dynamic> json) {
    return UploadVideoResponse(
      message: json['message'],
    );
  }
}
