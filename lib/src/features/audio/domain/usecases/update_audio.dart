import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/data/models/audio.model.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';
import 'package:pix2life/src/features/audio/domain/repositories/audio_repository.dart';

var tAudio = AudioModel.empty();
var uAudio = tAudio.copyWith();

class UpdateAudioParams extends Equatable {
  final Audio audio;
  final DataMap updateData;

  const UpdateAudioParams({
    required this.audio,
    required this.updateData,
  });

  UpdateAudioParams.empty() : this(audio: Audio.empty(), updateData: {});

  @override
  List<Object?> get props => [audio];
}

class UpdateAudio implements UseCase<Audio, UpdateAudioParams> {
  final AudioRepository _audioRepository;
  const UpdateAudio(this._audioRepository);
  @override
  ResultFuture<Audio> call(params) async {
    return await _audioRepository.updateAudio(audio: params.audio, updateData: params.updateData);
  }
}
