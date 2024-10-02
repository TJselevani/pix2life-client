import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaPickerService {
  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>?> pickImages() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    return (await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    ))
        ?.files
        .map((file) => XFile(file.path!))
        .toList();
  }

  Future<XFile?> pickVideo() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    return await _picker.pickVideo(source: ImageSource.gallery);
  }

  Future<List<XFile>?> pickAudios() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    return (await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    ))
        ?.files
        .map((file) => XFile(file.path!))
        .toList();
  }
}
