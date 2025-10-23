class CreateGalleryResponse {
  final String message;

  CreateGalleryResponse({required this.message});

  factory CreateGalleryResponse.fromJson(Map<String, dynamic> json) {
    return CreateGalleryResponse(
      message: json['message'] ?? '',
    );
  }
}
