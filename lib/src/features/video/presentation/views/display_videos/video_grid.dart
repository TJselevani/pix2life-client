import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/src/features/video/domain/entities/video.dart';
import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';
import 'package:pix2life/src/features/video/presentation/widgets/video_popup_dialog.dart';
import 'package:pix2life/src/shared/widgets/video-player/thumbnail/network_video_thumbnail_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pix2life/src/shared/widgets/video-player/video_player_widget.dart';
import 'package:video_player/video_player.dart';

enum ViewMode { compactGrid, list, grid }

class VideoGridPage extends StatefulWidget {
  const VideoGridPage({super.key});

  @override
  State<VideoGridPage> createState() => _VideoGridPageState();
}

class _VideoGridPageState extends State<VideoGridPage>
    with SingleTickerProviderStateMixin {
  String _selectedVideoName = 'Video Gallery';
  String? _selectedVideoUrl;
  ViewMode _currentViewMode = ViewMode.list;
  VideoPlayerController? _videoPlayerController;
  bool _isFullScreen = false;
  // ignore: unused_field
  bool _isPlaying = false;
  late AnimationController _controller;
  bool isTapped = false;
  double targetValue = 0.8;
  final logger = createLogger(VideoGridPage);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          setState(() => isTapped = true);
        } else if (status == AnimationStatus.dismissed) {
          setState(() => isTapped = false);
        }
      });
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    // Trigger the fetch event
    context.read<VideoBloc>().add(VideosFetchEvent());

    // Wait for the state to be updated
    await Future.delayed(
        const Duration(milliseconds: 100)); // Adjust if necessary
    final currentState = context.read<VideoBloc>().state;

    if (currentState is VideosLoaded) {
      final videos = currentState.videos;
      if (videos.isNotEmpty) {
        final randomVideo = videos[Random().nextInt(videos.length)];
        _selectedVideoName = randomVideo.filename;
        _selectedVideoUrl = randomVideo.url;
        _initializeVideoPlayer(_selectedVideoUrl!);
      }
    }
  }

  void _initializeVideoPlayer(String url) {
    _videoPlayerController?.dispose();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize().then((_) {
        setState(() {
          _isPlaying = true;
          _videoPlayerController?.pause(); // Start paused
        });
      }).catchError((error) {
        logger.e(error);
        ErrorSnackBar.show(context: context, message: 'Failed to play video');
      });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _playVideo(String url) {
    // Dispose of the current player
    _videoPlayerController?.dispose();

    // Initialize the new video player
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..setLooping(true)
      ..initialize().then((_) {
        setState(() {
          _isPlaying = true;
          _videoPlayerController!.play();
        });
      }).catchError((error) {
        logger.e(error);
        ErrorSnackBar.show(context: context, message: 'Unable to play video');
      });
  }

  void _showVideoInfo(Video video) {
    showDialog(
      context: context,
      builder: (context) {
        return VideoDialog(
          video: video,
          targetValue: targetValue,
          controller: _controller,
        );
      },
    );
  }

  void _toggleViewMode() {
    setState(() {
      _currentViewMode = ViewMode
          .values[(_currentViewMode.index + 1) % ViewMode.values.length];
    });
  }

  Widget _buildSelectedView(List<Video> videos) {
    switch (_currentViewMode) {
      case ViewMode.compactGrid:
        return MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          itemCount: videos.length,
          itemBuilder: (context, index) => _buildVideoItem(videos[index]),
        );
      case ViewMode.list:
        return ListView.builder(
          itemCount: videos.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: _buildVideoItem(videos[index]),
          ),
        );
      case ViewMode.grid:
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.0,
          ),
          itemCount: videos.length,
          itemBuilder: (context, index) => _buildVideoItem(videos[index]),
        );
      default:
        return Container();
    }
  }

  Widget _buildVideoItem(Video video) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVideoName = video.filename;
          _selectedVideoUrl = video.url;
          _playVideo(video.url);
        });
      },
      onLongPress: () => _showVideoInfo(video),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: VideoThumbnailWidget(videoUrl: video.url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedVideoName,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.refresh, size: 24),
          onPressed: () {
            context.read<VideoBloc>().add(VideosFetchEvent());
            setState(() {
              _videoPlayerController?.pause();
              _videoPlayerController = null;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _currentViewMode == ViewMode.grid
                  ? Icons.grid_view
                  : _currentViewMode == ViewMode.compactGrid
                      ? Icons.view_agenda
                      : Icons.list,
            ),
            onPressed: _toggleViewMode,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Video Player Container
              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.all(16.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(2.w, 2.h),
                      ),
                    ],
                  ),
                  child: _selectedVideoUrl != null &&
                          _videoPlayerController != null &&
                          _videoPlayerController!.value.isInitialized
                      ? Stack(
                          children: [
                            Center(
                              child: VideoPlayerWidget(
                                  controller: _videoPlayerController!),
                            ),
                            Positioned(
                              bottom: 8.h,
                              left: 8.w,
                              child: IconButton(
                                icon: Icon(
                                  _videoPlayerController!.value.volume > 0
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: AppPalette.red,
                                  size: 24.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_videoPlayerController!.value.volume >
                                        0) {
                                      _videoPlayerController!.setVolume(0);
                                    } else {
                                      _videoPlayerController!.setVolume(1);
                                    }
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              top: 100.h,
                              left: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  _videoPlayerController!.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: AppPalette.transparent,
                                  size: 100.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _videoPlayerController!.value.isPlaying
                                        ? _videoPlayerController!.pause()
                                        : _videoPlayerController!.play();
                                  });
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 8.h,
                              right: 8.w,
                              child: IconButton(
                                icon: Icon(
                                  _isFullScreen
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  color: AppPalette.red,
                                  size: 24.sp,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isFullScreen = !_isFullScreen;

                                    if (_isFullScreen) {
                                      SystemChrome.setEnabledSystemUIMode(
                                          SystemUiMode.edgeToEdge);
                                      SystemChrome.setPreferredOrientations([
                                        DeviceOrientation.portraitUp,
                                        DeviceOrientation.portraitDown,
                                        // SystemChrome.setEnabledSystemUIMode(
                                        //     SystemUiMode.immersive);
                                        // SystemChrome.setPreferredOrientations([
                                        //   DeviceOrientation.landscapeLeft,
                                        //   DeviceOrientation.landscapeRight,
                                      ]);
                                    } else {
                                      SystemChrome.setEnabledSystemUIMode(
                                          SystemUiMode.edgeToEdge);
                                      SystemChrome.setPreferredOrientations([
                                        DeviceOrientation.portraitUp,
                                        DeviceOrientation.portraitDown,
                                      ]);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: AppPalette.red,
                            size: 30.sp,
                          ),
                        ),
                ),
              ),
              Expanded(
                flex: 2,
                child: BlocConsumer<VideoBloc, VideoState>(
                  listener: (context, state) {
                    if (state is VideoFailure) {
                      ErrorSnackBar.show(
                          context: context, message: state.message);
                    }
                    if (state is VideoDeleted) {
                      SuccessSnackBar.show(
                          context: context, message: state.message);
                    }

                    if (state is VideoUpdated) {
                      SuccessSnackBar.show(
                          context: context, message: state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is VideoLoading) {
                      return Center(
                        child: LoadingAnimationWidget.waveDots(
                          color: AppPalette.red,
                          size: 50,
                        ),
                      );
                    } else if (state is VideosLoaded) {
                      final videos = state.videos;

                      if (videos.isEmpty) {
                        return const Center(child: Text('No Videos found'));
                      }

                      // Categorize videos by gallery name
                      final galleryMap = <String, List<Video>>{};
                      for (var video in videos) {
                        final galleryName = video.galleryName;
                        if (!galleryMap.containsKey(galleryName)) {
                          galleryMap[galleryName] = [];
                        }
                        galleryMap[galleryName]!.add(video);
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListView(
                          children: galleryMap.entries.map((entry) {
                            final galleryName = entry.key;
                            final galleryVideos = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    galleryName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 150.h,
                                    child: _buildSelectedView(galleryVideos),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    } else if (state is VideoFailure) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else {
                      return const Center(child: Text('Something went wrong'));
                    }
                  },
                ),
              ),
            ],
          ),
          if (_isFullScreen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFullScreen = false;
                    SystemChrome.setEnabledSystemUIMode(
                        SystemUiMode.edgeToEdge);
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]);
                  });
                },
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child:
                        VideoPlayerWidget(controller: _videoPlayerController!),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
