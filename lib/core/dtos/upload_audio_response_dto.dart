class UploadAudioResponse {
  final String message;

  UploadAudioResponse({required this.message});

  factory UploadAudioResponse.fromJson(Map<String, dynamic> json) {
    return UploadAudioResponse(
      message: json['message'],
    );
  }
}
