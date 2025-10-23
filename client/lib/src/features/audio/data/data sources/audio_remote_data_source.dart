import 'package:dio/dio.dart';
import 'package:pix2life/core/dtos/delete_data_dto.dart';
import 'package:pix2life/core/dtos/fetch_audio_response_dto.dart';
import 'package:pix2life/core/dtos/update_audio_response_dto.dart';
import 'package:pix2life/core/dtos/upload_audio_response_dto.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/data/data%20sources/audio_service.dart';
import 'package:pix2life/src/features/audio/data/models/audio.model.dart';

abstract interface class AudioRemoteDataSource {
  Future<String> deleteAudio({required String audioId});

  Future<List<AudioModel>> fetchAudios();

  Future<AudioModel> updateAudio({
    required AudioModel audio,
    required DataMap updateData,
  });

  Future<String> uploadAudio(
      {required FormData formData, required String galleryName});
}

class AudioRemoteDataSourceImpl implements AudioRemoteDataSource {
  final AudioService _audioService;
  AudioRemoteDataSourceImpl(this._audioService);
  final logger = createLogger(AudioRemoteDataSourceImpl);

  @override
  Future<String> deleteAudio({required String audioId}) async {
    try {
      final DeleteDataResponse response =
          await _audioService.deleteAudio(audioId);
      final message = response.message;
      logger.i(message);
      return message;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<AudioModel>> fetchAudios() async {
    try {
      final FetchAudiosResponse response = await _audioService.fetchAudios();
      final List<AudioModel> audios = response.audios;
      logger.i('Retrieved ${audios.length} Audio files');
      return audios;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<AudioModel> updateAudio(
      {required AudioModel audio, required DataMap updateData}) async {
    try {
      final UpdateAudioResponse response =
          await _audioService.updateAudio(audio, updateData);
      final String message = response.message;
      final AudioModel updatedAudio = response.updatedAudio;
      logger.i(message);
      return updatedAudio;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> uploadAudio(
      {required FormData formData, required String galleryName}) async {
    try {
      final UploadAudioResponse response =
          await _audioService.uploadAudio(formData, galleryName);
      final String message = response.message;
      logger.i(message);
      return message;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }
}
