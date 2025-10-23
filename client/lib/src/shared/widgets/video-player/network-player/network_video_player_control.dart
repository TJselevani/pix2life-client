import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerProWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerProWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  State<VideoPlayerProWidget> createState() => _VideoPlayerProWidgetState();
}

class _VideoPlayerProWidgetState extends State<VideoPlayerProWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVisible = false;

  void _initializeVideoPlayer() {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..initialize().then((_) {
            setState(() {
              _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController!,
                autoPlay: false,
                looping: false,
                allowMuting: true,
                allowPlaybackSpeedChanging: true,
                fullScreenByDefault: false,
                showControls: true,
              );
            });
          });
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.videoUrl),
      onVisibilityChanged: (VisibilityInfo info) {
        // Check if this widget is visible
        if (info.visibleFraction > 0) {
          // If visible and not initialized, initialize the video player
          if (!_isVisible) {
            _isVisible = true;
            _initializeVideoPlayer();
          }
        } else {
          // If not visible, dispose of the controller
          if (_isVisible) {
            _isVisible = false;
            dispose(); // Dispose when not visible
          }
        }
      },
      child: _chewieController != null &&
              _videoPlayerController != null &&
              _videoPlayerController!.value.isInitialized
          ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  minHeight: 100,
                ),
                child: Flexible(
                  child: AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
