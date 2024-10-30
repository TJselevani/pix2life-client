part of 'video_bloc.dart';

sealed class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object?> get props => [];
}

final class VideoInitial extends VideoState {}

final class VideoLoading extends VideoState {}

final class VideosLoaded extends VideoState {
  final List<Video> videos;

  const VideosLoaded({required this.videos});

  @override
  List<Object?> get props => [videos];
}

final class VideoLoaded extends VideoState {
  final Video video;

  const VideoLoaded({required this.video});

  @override
  List<Object> get props => [video];
}

final class VideoUpdated extends VideoState {
  final Video video;
  final String message;

  const VideoUpdated({required this.message, required this.video});

  @override
  List<Object> get props => [video, message];
}

final class VideoDeleted extends VideoState {
  final String videoId;
  final String message;

  const VideoDeleted({required this.videoId, required this.message});

  @override
  List<Object> get props => [videoId, message];
}

final class VideoSuccess extends VideoState {
  final String message;

  const VideoSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class VideoFailure extends VideoState {
  final String message;

  const VideoFailure({required this.message});

  @override
  List<Object> get props => [message];
}
