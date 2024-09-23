part of 'video_bloc.dart';

@immutable
sealed class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

final class VideoDeleteEvent extends VideoEvent {}

final class VideoFetchEvent extends VideoEvent {}

final class VideoUpdateEvent extends VideoEvent {}

final class VideoUploadEvent extends VideoEvent {}
