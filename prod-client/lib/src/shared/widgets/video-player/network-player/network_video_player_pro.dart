import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerProWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerProWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerProWidget> createState() => _VideoPlayerProWidgetState();
}

class _VideoPlayerProWidgetState extends State<VideoPlayerProWidget> {
  VideoPlayerController? _videoPlayerController;
  bool _isVisible = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((_) {
            setState(() {});
          });
  }

  void _togglePlayPause() {
    if (_videoPlayerController != null) {
      setState(() {
        if (_videoPlayerController!.value.isPlaying) {
          _videoPlayerController!.pause();
          _isPlaying = false;
        } else {
          _videoPlayerController!.play();
          _isPlaying = true;
        }
      });
    }
  }

  void _showFullScreenVideo() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: Chewie(
                  controller: ChewieController(
                    videoPlayerController: _videoPlayerController!,
                    autoPlay: true,
                    looping: false,
                    fullScreenByDefault: true,
                    showControls: true, // Show full controls in fullscreen mode
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0) {
          if (!_isVisible) {
            _isVisible = true;
            _initializeVideoPlayer();
          }
        } else {
          if (_isVisible) {
            _isVisible = false;
            dispose();
          }
        }
      },
      child: GestureDetector(
        onTap: _togglePlayPause,
        onLongPress: _showFullScreenVideo,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _videoPlayerController != null &&
                    _videoPlayerController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController!),
                  )
                : Container(
                    height: 100,
                    width: 160,
                    color: Colors.black,
                    child: Center(child: CircularProgressIndicator()),
                  ),
            if (!_isPlaying)
              Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
          ],
        ),
      ),
    );
  }
}
