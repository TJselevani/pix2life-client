import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/cache-manager/video_cache_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPlayerProCachedWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerProCachedWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerProCachedWidget> createState() =>
      _VideoPlayerProCachedWidgetState();
}

class _VideoPlayerProCachedWidgetState
    extends State<VideoPlayerProCachedWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    if (_videoPlayerController != null) return;

    try {
      final file = await VideoCacheManager().getSingleFile(widget.videoUrl);
      _videoPlayerController = VideoPlayerController.file(file)
        ..initialize().then((_) {
          setState(() {
            _isInitialized = true;
          });
        });
    } catch (e) {
      debugPrint("Error initializing video: $e");
    }
  }

  void togglePlayPause() {
    if (_videoPlayerController == null) return;
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

  void _showFullScreenVideo() {
    if (_videoPlayerController == null || !_isInitialized) return;

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      autoPlay: true,
      looping: false,
      showControls: true,
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Stack(
        alignment: Alignment.center,
        children: [
          // Transparent blurred background
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color:
                    Colors.black.withOpacity(0.5), // Semi-transparent overlay
              ),
            ),
          ),

          // Smooth scaling animation
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        // Video Player
                        AspectRatio(
                          aspectRatio:
                              _videoPlayerController!.value.aspectRatio,
                          child: Chewie(controller: _chewieController!),
                        ),

                        // Close Button
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.close,
                                color: Colors.white, size: 30),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ).then((_) {
      _chewieController?.pause();
      _chewieController?.dispose();
      _chewieController = null;
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
        if (info.visibleFraction > 0) {
          _initializeVideoPlayer();
        } else {
          _videoPlayerController?.pause();
        }
      },
      child: GestureDetector(
        onTap: _showFullScreenVideo, //_togglePlayPause,
        onLongPress: _showFullScreenVideo,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _isInitialized
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
