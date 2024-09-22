
// class FetchAudiosResponse {
//   final List<Audio> audios;

//   FetchAudiosResponse({required this.audios});

//   factory FetchAudiosResponse.fromJson(Map<String, dynamic> json) {
//     var audiosJson = json['audios'] as List;
//     List<Audio> audioList =
//         audiosJson.map((image) => Audio.fromJson(image)).toList();

//     return FetchAudiosResponse(
//       audios: audioList,
//     );
//   }
// }
