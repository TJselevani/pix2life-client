import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pix2life/functions/video_player/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class NetworkPlayerWidget extends StatefulWidget {
  const NetworkPlayerWidget({super.key});

  @override
  State<NetworkPlayerWidget> createState() => _NetworkPlayerWidgetState();
}

class _NetworkPlayerWidgetState extends State<NetworkPlayerWidget> {
  final TextEditingController _textController = TextEditingController(text: '');
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(''))
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
      padding: EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: _textController,
            decoration: InputDecoration(hintText: 'Enter Video Url'),
          )),
          SizedBox(width: 12),
          FloatingActionButton(
            onPressed: () async {
              if (_textController.text.trim().isEmpty) return;
              controller = VideoPlayerController.networkUrl(
                  Uri.parse(_textController.text))
                ..addListener(() => setState(() {}))
                ..setLooping(true)
                ..initialize().then((_) => controller.play());
            },
          ),
        ],
      ),
    );
  }
}
