import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaPickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<XFile?> pickSingleImage() async {
    // Check permission only if necessary
    if (await _requestPermission()) {
      // Open the system gallery for single image selection
      return await _imagePicker.pickImage(source: ImageSource.gallery);
    }
    return null;
  }

  Future<XFile?> pickSingleVideo() async {
    // Check permission only if necessary
    if (await _requestPermission()) {
      // Open the system gallery for single video selection
      return await _imagePicker.pickVideo(source: ImageSource.gallery);
    }
    return null;
  }

  Future<List<XFile>?> pickMultipleImages() async {
    // Check permission only if necessary
    if (await _requestPermission()) {
      // Use ImagePicker to allow multiple image selection
      final List<XFile> images = await _imagePicker.pickMultiImage();
      return images;
    }
    return null;
  }

  Future<List<XFile>?> pickMultipleVideos() async {
    if (await _requestPermission()) {
      // Use FilePicker for multiple video selection
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );

      // Convert selected files to a list of XFile objects
      return result?.files.map((file) => XFile(file.path!)).toList();
    }
    return null;
  }

  Future<XFile?> pickSingleAudio() async {
    // Use FilePicker for single audio file selection
    if (await _requestPermission()) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      return result != null ? XFile(result.files.first.path!) : null;
    }
    return null;
  }

  Future<List<XFile>?> pickMultipleAudios() async {
    if (await _requestPermission()) {
      // Use FilePicker for multiple audio file selection
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      return result?.files.map((file) => XFile(file.path!)).toList();
    }
    return null;
  }

  // Permission check
  Future<bool> _requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }
}



// import 'dart:async';
// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MediaPickerService {
//   final ImagePicker _picker = ImagePicker();

//   Future<List<XFile>?> pickImages() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     return (await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//     ))
//         ?.files
//         .map((file) => XFile(file.path!))
//         .toList();
//   }

//   Future<XFile?> pickVideo() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     return await _picker.pickVideo(source: ImageSource.gallery);
//   }

//   Future<List<XFile>?> pickAudios() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     return (await FilePicker.platform.pickFiles(
//       type: FileType.audio,
//       allowMultiple: true,
//     ))
//         ?.files
//         .map((file) => XFile(file.path!))
//         .toList();
//   }
// }
