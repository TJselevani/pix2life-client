import 'package:pix2life/src/features/audio/data/models/audio.model.dart';

class FetchAudiosResponse {
  final List<AudioModel> audios;

  FetchAudiosResponse({required this.audios});

  factory FetchAudiosResponse.fromJson(List json) {
    var audiosJson = json;
    List<AudioModel> audioList =
        audiosJson.map((audio) => AudioModel.fromJson(audio)).toList();

    return FetchAudiosResponse(
      audios: audioList,
    );
  }
}
