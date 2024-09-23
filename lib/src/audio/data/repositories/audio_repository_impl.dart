import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/api_failure.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/audio/data/data%20sources/audio_remote_data_source.dart';
import 'package:pix2life/src/audio/data/models/audio.model.dart';
import 'package:pix2life/src/audio/domain/entities/audio.dart';
import 'package:pix2life/src/audio/domain/repositories/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  late final AudioRemoteDataSource _remoteDataSource;
  AudioRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<String> deleteAudio({required String audioId}) async {
    try {
      final message = await _remoteDataSource.deleteAudio(audioId: audioId);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<List<Audio>> fetchAudios() async {
    try {
      final videos = await _remoteDataSource.fetchAudios();
      return right(videos);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<Audio> updateAudio(
      {required AudioModel updateData, required String audioId}) async {
    try {
      final updatedVideo = await _remoteDataSource.updateAudio(
          updateData: updateData, audioId: audioId);
      return right(updatedVideo);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<String> uploadAudio(
      {required FormData formData, required String galleryName}) async {
    try {
      final message = await _remoteDataSource.uploadAudio(
          formData: formData, galleryName: galleryName);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }
}
