import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ProgressIndicatorOverlayWidget extends StatelessWidget {
  final VideoPlayerController controller;
  const ProgressIndicatorOverlayWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      // controller.value.isPlaying ? controller.pause() : controller.play,
      child: Stack(
        children: [
          buildPlay(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: buildIndicator(),
          ),
        ],
      ),
    );
  }

  Widget buildIndicator() {
    return VideoProgressIndicator(controller, allowScrubbing: true);
  }

  Widget buildPlay() {
    return controller.value.isPlaying
        ? Container()
        : Container(
            alignment: Alignment.center,
            color: Colors.black26,
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 80,
            ),
          );
  }
}
