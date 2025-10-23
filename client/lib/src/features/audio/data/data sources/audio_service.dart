import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pix2life/core/dtos/delete_data_dto.dart';
import 'package:pix2life/core/dtos/fetch_audio_response_dto.dart';
import 'package:pix2life/core/dtos/update_audio_response_dto.dart';
import 'package:pix2life/core/dtos/upload_audio_response_dto.dart';
import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/api/data/data_source/api.service.dart';
import 'package:pix2life/src/features/audio/data/models/audio.model.dart';

class AudioService {
  final storage = const FlutterSecureStorage();
  final ApiService _apiService;
  AudioService(this._apiService);
  final log = createLogger(AudioService);

  Future<UploadAudioResponse> uploadAudio(
      FormData formData, String? galleryName) async {
    final url = '${AppSecrets.baseUrl}/audio/upload?galleryName=$galleryName';
    final data = await _apiService.uploadFile(formData, url);
    return UploadAudioResponse.fromJson(data);
  }

  Future<FetchAudiosResponse> fetchAudios() async {
    const url = '${AppSecrets.baseUrl}/audio/user/all';
    final data = await _apiService.fetchData(url);
    return FetchAudiosResponse.fromJson(data);
  }

  Future<UpdateAudioResponse> updateAudio(
      AudioModel audio, DataMap updateData) async {
    final url = '${AppSecrets.baseUrl}/audio/update?audioId=${audio.id}';
    final data = await _apiService.updateData(updateData, url);
    return UpdateAudioResponse.fromJson(data);
  }

  Future<DeleteDataResponse> deleteAudio(String audioId) async {
    final url = '${AppSecrets.baseUrl}/audio/destroy?audioId=$audioId';
    final data = await _apiService.deleteData(url);
    return DeleteDataResponse.fromJson(data);
  }
}
