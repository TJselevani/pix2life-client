class UpdateImageResponse {
  final String message;
  final dynamic updatedImage;

  UpdateImageResponse({
    required this.message,
    required this.updatedImage,
  });

  factory UpdateImageResponse.fromJson(Map<String, dynamic> json) {
    return UpdateImageResponse(
      message: json['message'],
      updatedImage: json['updatedImage'],
    );
  }
}
