

import 'package:flutter/material.dart';
import 'package:pix2life/src/shared/widgets/video-player/thumbnail/file_video_thumbnail_widget.dart';

class VideoSelectionContainer extends StatelessWidget {
  final String mediaPath;
  final VoidCallback? onRemove;
  final BuildContext context;

  const VideoSelectionContainer({
    super.key,
    required this.mediaPath,
    this.onRemove,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FileVideoThumbnailWidget(filePath: mediaPath),
        ),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 18.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
