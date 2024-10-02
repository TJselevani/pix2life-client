import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix2life/src/shared/widgets/selection-container/image_selection_container.dart';
import 'package:pix2life/src/shared/widgets/selection-container/video_selectionContainer.dart';

// Image preview grid
Widget buildImagesGridPreview({
  required List<XFile> imageFiles,
  required BuildContext context,
  required Function(int index) onRemove, // Callback to handle removal
}) {
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    ),
    itemCount: imageFiles.length,
    shrinkWrap: true,
    physics: const AlwaysScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return ImageSelectionContainer(
        mediaPath: imageFiles[index].path,
        onRemove: () => onRemove(index), // Call the passed callback
        context: context,
      );
    },
  );
}

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

// Audio list preview
Widget buildAudiosListPreview({
  required List<XFile> audioFiles,
  required BuildContext context,
  required Function(int index) onRemove, // Callback to remove audio
}) {
  return ListView.builder(
    itemCount: audioFiles.length,
    shrinkWrap: true,
    physics: const AlwaysScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(audioFiles[index].name),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => onRemove(index), // Call the passed callback
        ),
      );
    },
  );
}
