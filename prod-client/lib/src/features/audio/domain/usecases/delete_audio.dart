import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/domain/repositories/audio_repository.dart';

class DeleteAudioParams extends Equatable {
  final String audioId;

  const DeleteAudioParams({
    required this.audioId,
  });

  const DeleteAudioParams.empty() : this(audioId: '_empty.audioId');

  @override
  List<Object?> get props => [audioId];
}

class DeleteAudio implements UseCase<String, DeleteAudioParams> {
  final AudioRepository _audioRepository;
  const DeleteAudio(this._audioRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _audioRepository.deleteAudio(audioId: params.audioId);
  }
}
