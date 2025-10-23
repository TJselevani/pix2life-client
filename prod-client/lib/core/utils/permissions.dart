import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    // Permission.microphone,
    Permission.storage,
    Permission.photos,
    Permission.mediaLibrary,
    Permission.videos,
  ].request();

  // Check each permission status
  statuses.forEach((permission, status) {
    if (status.isGranted) {
      print('$permission is granted');
    } else if (status.isDenied) {
      print('$permission is denied');
    } else if (status.isPermanentlyDenied) {
      print('$permission is permanently denied, please enable it in settings');
      // Optionally open app settings
      openAppSettings();
    }
  });
}

/// Request storage permission.
Future<bool> mediaPermission() async {
  final mediaPermission = await Permission.storage.request();
  return mediaPermission.isGranted;
}

/// Request camera permission.
Future<bool> cameraPermission() async {
  final cameraPermission = await Permission.camera.request();
  return cameraPermission.isGranted;
}

/// Request photo library permission.
Future<bool> photoPermission() async {
  final photoPermission = await Permission.photos.request();
  return photoPermission.isGranted;
}

/// Request video permission.
Future<bool> videoPermission() async {
  final videoPermission = await Permission.videos.request();
  return videoPermission.isGranted;
}

/// Request audio permission (using microphone).
Future<bool> audioPermission() async {
  final audioPermission =
      await Permission.microphone.request(); // Using microphone for audio
  return audioPermission.isGranted;
}

/// Request media library permission.
Future<bool> mediaLibraryPermission() async {
  final mediaLibraryPermission = await Permission.mediaLibrary.request();
  return mediaLibraryPermission.isGranted;
}
