import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/audio/data/models/audio.model.dart';
import 'package:pix2life/src/audio/domain/entities/audio.dart';
import 'package:pix2life/src/audio/domain/repositories/audio_repository.dart';

var tAudio = AudioModel.empty();
var uAudio = tAudio.copyWith();

class UpdateAudioParams extends Equatable {
  final String audioId;
  final AudioModel updateData;

  const UpdateAudioParams({
    required this.audioId,
    required this.updateData,
  });

  UpdateAudioParams.empty()
      : this(audioId: '_empty.audioId', updateData: uAudio);

  @override
  List<Object?> get props => [audioId, updateData];
}

class UpdateAudio implements UseCase<Audio, UpdateAudioParams> {
  final AudioRepository _audioRepository;
  const UpdateAudio(this._audioRepository);
  @override
  ResultFuture<Audio> call(params) async {
    return await _audioRepository.updateAudio(
        updateData: params.updateData, audioId: params.audioId);
  }
}
