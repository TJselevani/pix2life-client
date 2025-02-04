import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix2life/src/shared/widgets/selection-container/audio_selection_container.dart';

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
      final audio = audioFiles[index];
      return AudioSelectionContainer(
          audioName: audio.name,
          onPressed: () => onRemove(index),
          context: context);

      // ListTile(
      //   title: Text(audioFiles[index].name),
      //   trailing: IconButton(
      //     icon: const Icon(Icons.delete),
      //     onPressed: () => onRemove(index), // Call the passed callback
      //   ),
      // );
    },
  );
}
