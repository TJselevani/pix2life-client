import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/data/models/video.model.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/features/video/domain/repositories/video_repository.dart';

var tVideo = VideoModel.empty();
var vid = tVideo.copyWith();

class UpdateVideoParams extends Equatable {
  final Video video;
  final DataMap updateData;

  const UpdateVideoParams({
    required this.video,
    required this.updateData,
  });

  UpdateVideoParams.empty() : this(video: Video.empty(), updateData: {});

  @override
  List<Object?> get props => [video];
}

class UpdateVideo implements UseCase<Video, UpdateVideoParams> {
  final VideoRepository _videoRepository;
  const UpdateVideo(this._videoRepository);
  @override
  ResultFuture<Video> call(params) async {
    return await _videoRepository.updateVideo(video: params.video, updateData: params.updateData);
  }
}
