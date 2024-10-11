import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix2life/src/shared/widgets/media-selection-container/video_selection_container.dart';


// Video preview grid
Widget buildVideosGridPreview({
  required List<XFile> videoFiles,
  required BuildContext context,
  required Function(int index) onRemove, // Callback for removing videos
}) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    ),
    itemCount: videoFiles.length,
    shrinkWrap: true,
    physics: const AlwaysScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return VideoSelectionContainer(
        mediaPath: videoFiles[index].path,
        onRemove: () => onRemove(index), // Call the passed callback
        context: context,
      );
    },
  );
}