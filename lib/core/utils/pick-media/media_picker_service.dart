import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/permissions.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:pix2life/core/utils/theme/app_palette.dart';

class MediaPickerService {
  final ImagePicker _imagePicker = ImagePicker();
  final logger = createLoggerInstance(MediaPickerService);

  // Compress image method
  Future<XFile?> _compressImage(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          path.join(tempDir.path, '${path.basename(file.path)}_compressed.jpg');

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80, // Adjust quality (0-100)
        format: CompressFormat.jpeg,
      );

      return compressedFile;
    } catch (e) {
      logger.e("Error compressing image: $e");
      return null;
    }
  }

  // Pick and compress multiple images
  Future<List<XFile>?> pickMultipleImagesCmp() async {
    try {
      if (await _requestPermission()) {
        final List<XFile> images = await _imagePicker.pickMultiImage();
        if (images.isNotEmpty) {
          List<XFile> compressedImages = [];
          for (var image in images) {
            final file = File(image.path);
            final compressedFile = await _compressImage(file);
            if (compressedFile != null) {
              compressedImages.add(XFile(compressedFile.path));
            }
          }
          return compressedImages;
        }
      }
    } catch (e) {
      logger.e("Error picking and compressing multiple images: $e");
    }
    return null;
  }

  // Pick and compress a single image
  Future<XFile?> pickSingleImageCmp() async {
    try {
      if (await _requestPermission()) {
        final pickedImage =
            await _imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          final file = File(pickedImage.path);
          final compressedFile = await _compressImage(file);
          return compressedFile != null ? XFile(compressedFile.path) : null;
        }
      }
    } catch (e) {
      logger.e("Error picking and compressing single image: $e");
    }
    return null;
  }

  // New method to take a photo from the camera and optionally compress it
  Future<XFile?> pickImageFromCamera({bool compress = true}) async {
    try {
      if (await _requestPermission()) {
        final pickedImage =
            await _imagePicker.pickImage(source: ImageSource.camera);
        if (pickedImage != null) {
          final file = File(pickedImage.path);
          final compressedFile = await _compressImage(file);
          return compressedFile != null ? XFile(compressedFile.path) : null;
        }
      }
    } catch (e) {
      logger.e("Error picking image from camera: $e");
    }
    return null;
  }

  // Existing methods
  Future<XFile?> pickSingleImage() async {
    try {
      if (await _requestPermission()) {
        return await _imagePicker.pickImage(source: ImageSource.gallery);
      }
    } catch (e) {
      logger.e("Error picking single image: $e");
    }
    return null;
  }

  Future<XFile?> pickAndCropImage() async {
    try {
      if (await _requestPermission()) {
        final pickedFile =
            await _imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          CroppedFile? croppedFile = await ImageCropper().cropImage(
            sourcePath: pickedFile.path,
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: AppPalette.red,
                toolbarWidgetColor: AppPalette.primaryWhite,
                aspectRatioPresets: [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                ],
              ),
              IOSUiSettings(
                title: 'Cropper',
                aspectRatioPresets: [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                ],
              ),
            ],
          );
          return croppedFile != null ? XFile(croppedFile.path) : null;
        }
      }
    } catch (e) {
      logger.e("Error picking and cropping image: $e");
    }
    return null;
  }

  Future<XFile?> pickSingleVideo() async {
    try {
      if (await _requestPermission()) {
        return await _imagePicker.pickVideo(source: ImageSource.gallery);
      }
    } catch (e) {
      logger.e("Error picking single video: $e");
    }
    return null;
  }

  Future<List<XFile>?> pickMultipleImages() async {
    try {
      if (await _requestPermission()) {
        final List<XFile> images = await _imagePicker.pickMultiImage();
        // ignore: unnecessary_null_comparison
        return images.where((image) => image.path != null).toList();
      }
    } catch (e) {
      logger.e("Error picking multiple images: $e");
    }
    return null;
  }

  Future<List<XFile>?> pickMultipleVideos() async {
    try {
      if (await _requestPermission()) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.video,
          allowMultiple: true,
        );
        return result?.files.map((file) => XFile(file.path!)).toList();
      }
    } catch (e) {
      logger.e("Error picking multiple videos: $e");
    }
    return null;
  }

  Future<XFile?> pickSingleAudio() async {
    try {
      if (await _requestPermission()) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.audio,
          allowMultiple: false,
        );
        return result != null ? XFile(result.files.first.path!) : null;
      }
    } catch (e) {
      logger.e("Error picking single audio: $e");
    }
    return null;
  }

  Future<List<XFile>?> pickMultipleAudios() async {
    try {
      if (await _requestPermission()) {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.audio,
          allowMultiple: true,
        );
        return result?.files.map((file) => XFile(file.path!)).toList();
      }
    } catch (e) {
      logger.e("Error picking multiple audios: $e");
    }
    return null;
  }

  // Permission check
  Future<bool> _requestPermission() async {
    requestPermissions();
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   status = await Permission.storage.request();
    // }
    // return status.isGranted;
    return true;
  }
}
