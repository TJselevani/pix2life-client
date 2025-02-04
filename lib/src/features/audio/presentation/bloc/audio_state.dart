part of 'audio_bloc.dart';

sealed class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object> get props => [];
}

final class AudioInitial extends AudioState {}

final class AudioLoading extends AudioState {}

final class AudiosLoaded extends AudioState {
  final List<Audio> audios;

  const AudiosLoaded({required this.audios});

  @override
  List<Object> get props => [audios];
}

final class AudioUpdated extends AudioState {
  final Audio audio;
  final String message;

  const AudioUpdated({required this.audio, required this.message});

  @override
  List<Object> get props => [audio];
}

final class AudioDeleted extends AudioState {
  final String audioId;
  final String message;

  const AudioDeleted({required this.audioId, required this.message});

  @override
  List<Object> get props => [audioId, message];
}

final class AudioSuccess extends AudioState {
  final String message;

  const AudioSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class AudioFailure extends AudioState {
  final String message;

  const AudioFailure({required this.message});

  @override
  List<Object> get props => [message];
}
