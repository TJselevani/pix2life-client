import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnailWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
      _controller.setLooping(false);
      _controller.pause();
    } catch (e) {
      // Handle the exception and set _hasError to true
      setState(() {
        _hasError = true;
      });
      debugPrint("Error initializing video player: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.grey,
        child: const Center(
          child: Icon(
            Icons.videocam_off_rounded, // Icon to indicate video load failure
            color: Colors.white,
            size: 50.0,
          ),
        ),
      );
    }

    return _isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.isInitialized
                ? _controller.value.aspectRatio
                : 1.0,
            child: Stack(
              children: [
                VideoPlayer(_controller),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
