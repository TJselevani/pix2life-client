import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FileVideoThumbnailWidget extends StatefulWidget {
  final String filePath;

  const FileVideoThumbnailWidget({
    super.key,
    required this.filePath,
  });

  @override
  State<FileVideoThumbnailWidget> createState() =>
      _FileVideoThumbnailWidgetState();
}

class _FileVideoThumbnailWidgetState extends State<FileVideoThumbnailWidget> {
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
      _controller = VideoPlayerController.file(File(widget.filePath));
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
    // If there was an error, show a video-related icon
    if (_hasError) {
      return Container(
        color: Colors.grey,
        child: const Center(
          child: Icon(
            Icons.videocam, // Icon to indicate video load failure
            color: Colors.white,
            size: 50.0,
          ),
        ),
      );
    }

    // If the video is initialized, show the video player thumbnail
    return _isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
