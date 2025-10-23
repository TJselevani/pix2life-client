import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/features/video/domain/repositories/video_repository.dart';

class FetchVideo implements UseCaseWithoutParams<List<Video>> {
  final VideoRepository _videoRepository;
  const FetchVideo(this._videoRepository);
  @override
  ResultFuture<List<Video>> call() async {
    return await _videoRepository.fetchVideos();
  }
}
