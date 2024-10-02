import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
// For Bloc usage
import 'package:dio/dio.dart'; // For FormData and MultipartFile
import 'package:flutter/material.dart';

Future<void> pickImages({
  required List<XFile> images,
  required List<XFile> selectedMedia,
  required Function setStateCallback, // Pass setState callback
}) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  setStateCallback(() {
    images.clear(); // Clear if required before picking
    selectedMedia.clear();
  });

  final List<XFile>? selectedImages = (await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: true,
  ))
      ?.files
      .map((file) => XFile(file.path!))
      .toList();

  if (selectedImages != null && selectedImages.isNotEmpty) {
    setStateCallback(() {
      images.addAll(selectedImages); // Append to existing images
      selectedMedia.addAll(selectedImages); // Append to selected media
    });
  }
}

Future<void> pickVideo({
  required List<XFile> videos,
  required List<XFile> selectedMedia,
  required ImagePicker picker,
  required Function setStateCallback,
}) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  setStateCallback(() {
    videos.clear();
    selectedMedia.clear();
  });

  final XFile? videoPicker = await picker.pickVideo(source: ImageSource.gallery);
  if (videoPicker != null) {
    setStateCallback(() {
      videos.add(videoPicker); // Append to existing videos
      selectedMedia.add(videoPicker); // Append to selected media
    });
  }
}

Future<void> pickAudios({
  required List<XFile> audios,
  required List<XFile> selectedMedia,
  required Function setStateCallback,
}) async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }

  setStateCallback(() {
    audios.clear();
    selectedMedia.clear();
  });

  final List<XFile>? audioFiles = (await FilePicker.platform.pickFiles(
    type: FileType.audio,
    allowMultiple: true,
  ))
      ?.files
      .map((file) => XFile(file.path!))
      .toList();

  if (audioFiles != null && audioFiles.isNotEmpty) {
    setStateCallback(() {
      audios.addAll(audioFiles); // Append to existing audios
      selectedMedia.addAll(audioFiles); // Append to selected media
    });
  }
}

Future<void> uploadMedia<T>(
  List<XFile>? mediaList,
  Future Function(FormData formData, String galleryName) uploadFunction,
  TextEditingController nameController,
  Function(List<String>) onUploadSuccess, // Callback for successful upload
  Function(String) onError, // Error callback
  Function setStateCallback, // State update callback
) async {
  if (mediaList == null || mediaList.isEmpty) {
    onError('No media to upload');
    return;
  }

  setStateCallback(() {
    var isLoading = true;
  });

  List<String> uploadingMedia = [];
  List<String> uploadDone = [];

  await Future.forEach(mediaList, (XFile media) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(media.path, filename: media.name),
    });

    setStateCallback(() {
      uploadingMedia.add(media.name);
    });

    try {
      final galleryName = nameController.text.trim();

      await uploadFunction(formData, galleryName);

      setStateCallback(() {
        uploadDone.add(media.name);
      });
    } catch (e) {
      onError(e.toString());
    }
  });

  if (uploadDone.length == mediaList.length) {
    onUploadSuccess(uploadDone);
  }
}
