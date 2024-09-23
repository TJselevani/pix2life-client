import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/video/data/models/video.model.dart';
import 'package:pix2life/src/video/domain/entities/video.dart';
import 'package:pix2life/src/video/domain/repositories/video_repository.dart';

var tVideo = VideoModel.empty();
var vid = tVideo.copyWith();

class UpdateVideoParams extends Equatable {
  final String videoId;
  final VideoModel updateData;

  const UpdateVideoParams({
    required this.videoId,
    required this.updateData,
  });

  UpdateVideoParams.empty() : this(videoId: '_empty.videoId', updateData: vid);

  @override
  List<Object?> get props => [videoId];
}

class UpdateVideo implements UseCase<Video, UpdateVideoParams> {
  final VideoRepository _videoRepository;
  const UpdateVideo(this._videoRepository);
  @override
  ResultFuture<Video> call(params) async {
    return await _videoRepository.updateVideo(
        updateData: params.updateData, videoId: params.videoId);
  }
}
