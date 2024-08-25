class UpdateAudioResponse {
  final String message;
  final dynamic updatedAudio;

  UpdateAudioResponse({
    required this.message,
    required this.updatedAudio,
  });

  factory UpdateAudioResponse.fromJson(Map<String, dynamic> json) {
    return UpdateAudioResponse(
      message: json['message'],
      updatedAudio: json['updatedAudio'],
    );
  }
}
