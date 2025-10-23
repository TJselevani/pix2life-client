import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix2life/src/shared/widgets/media-selection-container/image_selection_container.dart';

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
