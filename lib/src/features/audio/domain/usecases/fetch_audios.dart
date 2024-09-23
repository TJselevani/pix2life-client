import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';
import 'package:pix2life/src/features/audio/domain/repositories/audio_repository.dart';

class FetchAudios implements UseCaseWithoutParams<List<Audio>> {
  final AudioRepository _audioRepository;
  const FetchAudios(this._audioRepository);
  @override
  ResultFuture<List<Audio>> call() async {
    return await _audioRepository.fetchAudios();
  }
}
