import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';

class MyVideoProvider with ChangeNotifier {
  final BuildContext context;

  List<Video> _videos = [];
  bool _loading = false;
  String _errorMessage = '';

  List<Video> get videos => _videos;
  bool get isLoading => _loading;
  String get errorMessage => _errorMessage;

  MyVideoProvider(this.context) {
    // Start listening to GalleryBloc state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _initialize() {
    final videoBloc = BlocProvider.of<VideoBloc>(context);

    // Listen for changes in the AudioBloc state
    videoBloc.stream.listen((state) {
      if (state is VideoLoading) {
        _loading = true;
        _errorMessage = '';
        notifyListeners();
      } else if (state is VideosLoaded) {
        _videos = state.videos;
        _loading = false;
        notifyListeners();
      } else if (state is VideoUpdated) {
        videoBloc.add(VideosFetchEvent());
        notifyListeners();
      } else if (state is VideoDeleted) {
        videoBloc.add(VideosFetchEvent());
        notifyListeners();
      } else if (state is VideoFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
      }
    });

    videoBloc.add(VideosFetchEvent());
  }

  // Method to delete an image by ID
  void deleteVideo(String videoId) {
    final videoBloc = BlocProvider.of<VideoBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    // Dispatch a delete event to the ImageBloc
    videoBloc.add(VideoDeleteEvent(videoId: videoId));
  }

  // Method to update an image
  void updateVideo(Video video, DataMap updateData) {
    final videoBloc = BlocProvider.of<VideoBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    // Dispatch an update event to the ImageBloc
    videoBloc.add(VideoUpdateEvent(video: video, updateData: updateData));
  }
}
