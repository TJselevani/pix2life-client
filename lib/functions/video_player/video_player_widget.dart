import 'package:flutter/material.dart';
import 'package:pix2life/functions/video_player/basic_overlay_widget.dart';
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
            child: BuildVideo(),
          )
        : Container(
            // height: 200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget BuildVideo() {
    return Stack(children: [
      buildVideoPlayer(),
      Positioned.fill(
        child: BasicOverlayWidget(controller: widget.controller),
      ),
    ]);
  }

  Widget buildVideoPlayer() {
    return AspectRatio(
        aspectRatio: widget.controller.value.aspectRatio,
        child: VideoPlayer(widget.controller));
  }
}
