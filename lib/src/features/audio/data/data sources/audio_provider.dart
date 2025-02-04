import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';
import 'package:pix2life/src/features/audio/presentation/bloc/audio_bloc.dart';

class MyAudioProvider with ChangeNotifier {
  final BuildContext context;
  late final StreamSubscription _audioSubscription;

  List<Audio> _audios = [];
  Audio? _audio;
  bool _loading = false;
  String _errorMessage = '';

  List<Audio> get audios => _audios;
  Audio? get audio => _audio;
  bool get isLoading => _loading;
  String get errorMessage => _errorMessage;

  MyAudioProvider(this.context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _initialize() {
    final audioBloc = BlocProvider.of<AudioBloc>(context);

    // Store subscription to cancel it later
    _audioSubscription = audioBloc.stream.listen((state) {
      if (state is AudioLoading) {
        _loading = true;
        _errorMessage = '';
        notifyListeners();
      } else if (state is AudiosLoaded) {
        _audios = state.audios;
        _loading = false;
        notifyListeners();
      } else if (state is AudioUpdated) {
        audioBloc.add(AudiosFetchEvent());
        notifyListeners();
      } else if (state is AudioDeleted) {
        audioBloc.add(AudiosFetchEvent());
        notifyListeners();
      } else if (state is AudioFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
      }
    });

    // Initial fetch of audios
    audioBloc.add(AudiosFetchEvent());
  }

  Future<void> fetchAudios() async {
    final audioBloc = BlocProvider.of<AudioBloc>(context);
    audioBloc.add(AudiosFetchEvent());
  }

  // Method to delete an audio by ID
  Future<void> deleteAudio(String audioId) async {
    final audioBloc = BlocProvider.of<AudioBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    audioBloc.add(AudioDeleteEvent(audioId: audioId));

    // Wait for response from Bloc
    await for (var state in audioBloc.stream) {
      if (state is AudioDeleted) {
        audioBloc.add(AudiosFetchEvent()); // Refresh audios after deletion
        _loading = false;
        notifyListeners();
        break;
      } else if (state is AudioFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
        break;
      }
    }
  }

  // Method to update an audio
  Future<void> updateAudio(Audio audio, DataMap updateData) async {
    final audioBloc = BlocProvider.of<AudioBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    audioBloc.add(AudioUpdateEvent(audio: audio, updateData: updateData));

    // Wait for response from Bloc
    await for (var state in audioBloc.stream) {
      if (state is AudioUpdated) {
        audioBloc.add(AudiosFetchEvent()); // Refresh audios after update
        _loading = false;
        notifyListeners();
        break;
      } else if (state is AudioFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
        break;
      }
    }
  }

  // Dispose method to prevent memory leaks
  @override
  void dispose() {
    _audioSubscription.cancel();
    super.dispose();
  }
}
