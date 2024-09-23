import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/domain/repositories/video_repository.dart';

class DeleteVideoParams extends Equatable {
  final String videoId;

  const DeleteVideoParams({
    required this.videoId,
  });

  const DeleteVideoParams.empty() : this(videoId: '_empty.videoId');

  @override
  List<Object?> get props => [videoId];
}

class DeleteVideo implements UseCase<String, DeleteVideoParams> {
  final VideoRepository _videoRepository;
  const DeleteVideo(this._videoRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _videoRepository.deleteVideo(videoId: params.videoId);
  }
}
