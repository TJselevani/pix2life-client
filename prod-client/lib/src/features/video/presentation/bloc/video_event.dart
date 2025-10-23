part of 'video_bloc.dart';

@immutable
sealed class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

final class VideoDeleteEvent extends VideoEvent {
  final String videoId;

  const VideoDeleteEvent({required this.videoId});

  @override
  List<Object> get props => [videoId];
}

final class VideosFetchEvent extends VideoEvent {}

// final class VideoFetchEvent extends VideoEvent {}

final class VideoUpdateEvent extends VideoEvent {
  final Video video;
  final DataMap updateData;

  const VideoUpdateEvent({required this.video, required this.updateData});

  @override
  List<Object> get props => [video, updateData];
}

final class VideoUploadEvent extends VideoEvent {
  final FormData formData;
  final String galleryName;

  const VideoUploadEvent({required this.formData, required this.galleryName});

  @override
  List<Object> get props => [formData, galleryName];
}
