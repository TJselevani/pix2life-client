import 'package:dio/dio.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/audio/data/models/audio.model.dart';
import 'package:pix2life/src/audio/domain/entities/audio.dart';

abstract interface class AudioRepository {
  const AudioRepository();

  ResultFuture<String> uploadAudio({
    required FormData formData,
    required String galleryName,
  });

  ResultFuture<List<Audio>> fetchAudios();

  ResultFuture<Audio> updateAudio({
    required AudioModel updateData,
    required String audioId,
  });

  ResultFuture<String> deleteAudio({
    required String audioId,
  });
}
