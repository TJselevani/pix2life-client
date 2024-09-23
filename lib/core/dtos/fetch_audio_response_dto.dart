import 'package:pix2life/src/audio/data/models/audio.model.dart';

class FetchAudiosResponse {
  final List<AudioModel> audios;

  FetchAudiosResponse({required this.audios});

  factory FetchAudiosResponse.fromJson(Map<String, dynamic> json) {
    var audiosJson = json['audios'] as List;
    List<AudioModel> audioList =
        audiosJson.map((image) => AudioModel.fromJson(image)).toList();

    return FetchAudiosResponse(
      audios: audioList,
    );
  }
}
