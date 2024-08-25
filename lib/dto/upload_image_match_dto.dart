class UploadImageMatchResponse {
  final String message;
  final Map image;

  UploadImageMatchResponse({
    required this.message,
    required this.image,
  });

  factory UploadImageMatchResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageMatchResponse(message: json['message'], image: json['image']);
  }
}
