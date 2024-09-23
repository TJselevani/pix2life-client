import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/domain/repositories/audio_repository.dart';

class UploadAudioParams extends Equatable {
  final FormData formData;
  final String galleryName;

  const UploadAudioParams({
    required this.formData,
    required this.galleryName,
  });

  UploadAudioParams.empty()
      : this(formData: FormData.fromMap({}), galleryName: '_empty.galleryName');

  @override
  List<Object?> get props => [formData, galleryName];
}

class UploadAudio implements UseCase<String, UploadAudioParams> {
  final AudioRepository _audioRepository;
  const UploadAudio(this._audioRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _audioRepository.uploadAudio(
        formData: params.formData, galleryName: params.galleryName);
  }
}
