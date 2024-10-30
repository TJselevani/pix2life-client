import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/data/models/audio.model.dart';

class UpdateAudioResponse {
  final String message;
  final AudioModel updatedAudio;

  UpdateAudioResponse({
    required this.message,
    required this.updatedAudio,
  });

  factory UpdateAudioResponse.fromJson(Map<String, dynamic> json) {
    final DataMap imageData = json['updatedAudio'];
    final AudioModel audio = AudioModel.fromJson(imageData);
    return UpdateAudioResponse(
      message: json['message'],
      updatedAudio: audio,
    );
  }
}
