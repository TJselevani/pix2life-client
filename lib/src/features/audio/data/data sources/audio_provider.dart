import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/audio/domain/entities/audio.dart';
import 'package:pix2life/src/features/audio/presentation/bloc/audio_bloc.dart';

class MyAudioProvider with ChangeNotifier {
  final BuildContext context;

  List<Audio> _audios = [];
  Audio? _audio;
  bool _loading = false;
  String _errorMessage = '';

  List<Audio> get audios => _audios;
  Audio? get audio => _audio;
  bool get isLoading => _loading;
  String get errorMessage => _errorMessage;

  MyAudioProvider(this.context) {
    // Start listening to [AudioBloc] state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _initialize() {
    final audioBloc = BlocProvider.of<AudioBloc>(context);

    // Listen for changes in the [AudioBloc] state
    audioBloc.stream.listen((state) {
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

    audioBloc.add(AudiosFetchEvent());
  }

  // Method to delete an [Audio] by ID
  void deleteAudio(String audioId) {
    final audioBloc = BlocProvider.of<AudioBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    // Dispatch a delete event to the [AudioBloc]
    audioBloc.add(AudioDeleteEvent(audioId: audioId));
  }

  // Method to update an [Audio]
  void updateAudio(Audio audio, DataMap updateData) {
    final audioBloc = BlocProvider.of<AudioBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    // Dispatch an update event to the [AudioBloc]
    audioBloc.add(AudioUpdateEvent(audio: audio, updateData: updateData));
  }
}
