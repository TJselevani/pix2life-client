import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';
import 'package:pix2life/src/features/audio/domain/usecases/delete_audio.dart';
import 'package:pix2life/src/features/audio/domain/usecases/fetch_audios.dart';
import 'package:pix2life/src/features/audio/domain/usecases/update_audio.dart';
import 'package:pix2life/src/features/audio/domain/usecases/upload_audio.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final DeleteAudio _deleteAudio;
  final FetchAudios _fetchAudios;
  final UpdateAudio _updateAudio;
  final UploadAudio _uploadAudio;

  AudioBloc({
    required DeleteAudio deleteAudio,
    required FetchAudios fetchAudios,
    required UpdateAudio updateAudio,
    required UploadAudio uploadAudio,
  })  : _deleteAudio = deleteAudio,
        _fetchAudios = fetchAudios,
        _updateAudio = updateAudio,
        _uploadAudio = uploadAudio,
        super(AudioInitial()) {
    on<AudioDeleteEvent>(_onAudioDeleteEvent);
    on<AudiosFetchEvent>(_onAudioFetchEvent);
    on<AudioUpdateEvent>(_onAudioUpdateEvent);
    on<AudioUploadEvent>(_onAudioUploadEvent);
  }

  FutureOr<void> _onAudioDeleteEvent(
      AudioDeleteEvent event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    final response =
        await _deleteAudio(DeleteAudioParams(audioId: event.audioId));
    response.fold(
      (failure) => emit(AudioFailure(message: failure.errorMessage)),
      (audioId) => emit(AudioDeleted(
          audioId: audioId, message: 'Audio Deleted Successfully')),
    );
  }

  FutureOr<void> _onAudioFetchEvent(
      AudiosFetchEvent event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    final response = await _fetchAudios();
    response.fold(
      (failure) => emit(AudioFailure(message: failure.errorMessage)),
      (audios) => emit(AudiosLoaded(audios: audios)),
    );
  }

  FutureOr<void> _onAudioUpdateEvent(
      AudioUpdateEvent event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    final response = await _updateAudio(UpdateAudioParams(audio: event.audio, updateData: event.updateData));
    response.fold(
      (failure) => emit(AudioFailure(message: failure.errorMessage)),
      (audio) => emit(
          AudioUpdated(audio: audio, message: 'Audio Updated Successfully')),
    );
  }

  FutureOr<void> _onAudioUploadEvent(
      AudioUploadEvent event, Emitter<AudioState> emit) async {
    emit(AudioLoading());
    final response = await _uploadAudio(UploadAudioParams(
        formData: event.formData, galleryName: event.galleryName));
    response.fold(
      (failure) => emit(AudioFailure(message: failure.errorMessage)),
      (message) => emit(AudioSuccess(message: message)),
    );
  }
}
