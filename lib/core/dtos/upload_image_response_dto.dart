class UploadImageResponse {
  final String message;

  UploadImageResponse({required this.message});

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageResponse(
      message: json['message'],
    );
  }
}
