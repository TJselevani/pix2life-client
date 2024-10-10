import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pix2life/src/shared/widgets/video-player/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class FilePlayerWidget extends StatefulWidget {
  const FilePlayerWidget({super.key});

  @override
  State<FilePlayerWidget> createState() => _FilePlayerWidgetState();
}

class _FilePlayerWidgetState extends State<FilePlayerWidget> {
  final File file = File('');
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.file(file)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller.play());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VideoPlayerWidget(controller: controller),
          buildAddButton(),
        ],
      ),
    );
  }

  Future pickVideoFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result == null) {
      return null;
    }
    final fileRes = result.files.single.path;
    return File(fileRes!);
  }

  buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: FloatingActionButton(
        onPressed: () async {
          final file = await pickVideoFile();
          if (file == null) {
            return;
          }
          controller = VideoPlayerController.file(file)
            ..addListener(() => setState(() {}))
            ..setLooping(true)
            ..initialize().then((_) {
              controller.play();
              setState(() {});
            });
        },
      ),
    );
  }
}
