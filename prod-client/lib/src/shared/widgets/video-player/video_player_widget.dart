import 'package:flutter/material.dart';
import 'package:pix2life/src/shared/widgets/video-player/video-overlay-widgets/progress_indicator.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoPlayerWidget({super.key, required this.controller});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.controller.value.isInitialized
        ? Container(
            alignment: Alignment.topCenter,
            child: buildVideo(),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget buildVideo() {
    return Stack(children: [
      buildVideoPlayer(),
      Positioned.fill(
        child: ProgressIndicatorOverlayWidget(controller: widget.controller),
      ),
    ]);
  }

  Widget buildVideoPlayer() {
    return AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        child: VideoPlayer(widget.controller));
  }
}
