import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';

class MyVideoProvider with ChangeNotifier {
  final BuildContext context;
  late final StreamSubscription _videoSubscription;

  List<Video> _videos = [];
  bool _loading = false;
  String _errorMessage = '';

  List<Video> get videos => _videos;
  bool get isLoading => _loading;
  String get errorMessage => _errorMessage;

  MyVideoProvider(this.context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  void _initialize() {
    final videoBloc = BlocProvider.of<VideoBloc>(context);

    // Store subscription to cancel it later
    _videoSubscription = videoBloc.stream.listen((state) {
      if (state is VideoLoading) {
        _loading = true;
        _errorMessage = '';
        notifyListeners();
      } else if (state is VideosLoaded) {
        _videos = state.videos;
        _loading = false;
        notifyListeners();
      } else if (state is VideoUpdated) {
        videoBloc.add(VideosFetchEvent()); // Refetch videos after update
        notifyListeners();
      } else if (state is VideoDeleted) {
        videoBloc.add(VideosFetchEvent()); // Refetch videos after deletion
        notifyListeners();
      } else if (state is VideoFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
      }
    });

    // Initial fetch of videos
    videoBloc.add(VideosFetchEvent());
  }

  Future<void> fetchVideos() async {
    final videoBloc = BlocProvider.of<VideoBloc>(context);
    videoBloc.add(VideosFetchEvent());
  }

  // Method to delete a video by ID
  Future<void> deleteVideo(String videoId) async {
    final videoBloc = BlocProvider.of<VideoBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    videoBloc.add(VideoDeleteEvent(videoId: videoId));

    // Wait for response from Bloc
    await for (var state in videoBloc.stream) {
      if (state is VideoDeleted) {
        videoBloc.add(VideosFetchEvent()); // Refresh videos after deletion
        _loading = false;
        notifyListeners();
        break;
      } else if (state is VideoFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
        break;
      }
    }
  }

  // Method to update a video
  Future<void> updateVideo(Video video, DataMap updateData) async {
    final videoBloc = BlocProvider.of<VideoBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    videoBloc.add(VideoUpdateEvent(video: video, updateData: updateData));

    // Wait for response from Bloc
    await for (var state in videoBloc.stream) {
      if (state is VideoUpdated) {
        videoBloc.add(VideosFetchEvent()); // Refresh videos after update
        _loading = false;
        notifyListeners();
        break;
      } else if (state is VideoFailure) {
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
    _videoSubscription.cancel();
    super.dispose();
  }
}
