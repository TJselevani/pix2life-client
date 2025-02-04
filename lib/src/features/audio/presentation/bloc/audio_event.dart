part of 'audio_bloc.dart';

sealed class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object?> get props => [];
}

final class AudioDeleteEvent extends AudioEvent {
  final String audioId;

  const AudioDeleteEvent({required this.audioId});

  @override
  List<Object> get props => [audioId];
}

final class AudiosFetchEvent extends AudioEvent {}

// final class AudioFetchEvent extends AudioEvent {}

final class AudioUpdateEvent extends AudioEvent {
  final Audio audio;
  final DataMap updateData;

  const AudioUpdateEvent({required this.audio, required this.updateData});

  @override
  List<Object> get props => [audio, updateData];
}

final class AudioUploadEvent extends AudioEvent {
  final FormData formData;
  final String galleryName;

  const AudioUploadEvent({required this.formData, required this.galleryName});

  @override
  List<Object> get props => [formData, galleryName];
}
