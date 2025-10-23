// import 'package:pix2life/core/utils/logger/logger.dart';
// import 'package:hl_image_picker/hl_image_picker.dart';
// import 'package:pix2life/core/utils/permissions.dart';

// class MediaPickerServiceHl {
//   final HLImagePicker _picker = HLImagePicker();
//   final logger = createLoggerInstance(MediaPickerServiceHl);

//   /// Request permissions for media and camera access.
//   Future<bool> _requestPermissions() async {
//     await requestPermissions();
//     return true;
//   }

//   /// Select a single image from the gallery with advanced options.
//   Future selectImage({
//     bool enablePreview = true,
//     bool cropping = true,
//     List<String> selectedIds = const [],
//     double compressQuality = 80,
//     CompressFormat compressFormat = CompressFormat.jpg,
//     MaxSizeOutput? maxSizeOutput,
//   }) async {
//     // Request permissions for storage and camera access
//     if (await _requestPermissions()) {
//       try {
//         // Open the image picker with specified options
//         return await _picker.openPicker(
//           selectedIds: selectedIds,
//           pickerOptions: HLPickerOptions(
//             mediaType: MediaType.image,
//             maxSelectedAssets: 1,
//             enablePreview: enablePreview, // Enable or disable preview
//           ),
//           cropping: cropping, // Enable or disable cropping
//           cropOptions: HLCropOptions(
//             croppingStyle: CroppingStyle.normal, // Normal cropping style
//             aspectRatio: CropAspectRatio(
//                 ratioX: 2, ratioY: 2), // Aspect ratio for cropping
//             aspectRatioPresets: <CropAspectRatioPreset>[
//               CropAspectRatioPreset.original, // Original aspect ratio
//               CropAspectRatioPreset.ratio16x9, // 16:9 aspect ratio
//               CropAspectRatioPreset.square, // Square aspect ratio
//             ],
//             compressQuality: compressQuality, // Quality of the compressed image
//             compressFormat: compressFormat, // Format of the compressed image
//             maxSizeOutput: maxSizeOutput ??
//                 MaxSizeOutput(
//                     maxHeight: 800, maxWidth: 800), // Default max size output
//           ),
//           localized:
//               LocalizedImagePicker(), // Localized options for the image picker
//         );
//       } catch (e) {
//         logger.e('Error selecting a single image: $e');
//         throw Exception('Error selecting a single image');
//       }
//     } else {
//       logger.e('Permissions not granted for selecting a single image.');
//       throw Exception('Permissions not granted');
//     }
//   }

//   /// Select a single image from the gallery.
//   Future selectSingleImage() async {
//     if (await _requestPermissions()) {
//       return await _picker.openPicker(
//         selectedIds: [],
//         pickerOptions: HLPickerOptions(
//           mediaType: MediaType.image,
//           maxSelectedAssets: 1,
//           enablePreview: true,
//         ),
//         cropping: true,
//         cropOptions: HLCropOptions(
//           croppingStyle: CroppingStyle.normal,
//           aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 2),
//           aspectRatioPresets: <CropAspectRatioPreset>[
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio16x9,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio5x3,
//             CropAspectRatioPreset.ratio5x4,
//             CropAspectRatioPreset.square,
//           ],
//           compressQuality: 80,
//           compressFormat: CompressFormat.jpg,
//           maxSizeOutput: MaxSizeOutput(maxHeight: 40, maxWidth: 40),
//         ),
//       );
//     } else {
//       logger.e('Permissions not granted for selecting a single image.');
//       throw Exception('Permissions not granted');
//     }
//   }

//   /// Select multiple images from the gallery.
//   Future<List?> selectMultipleImages() async {
//     if (await _requestPermissions()) {
//       return await _picker.openPicker(
//         pickerOptions:
//             HLPickerOptions(mediaType: MediaType.image, enablePreview: true),
//         cropping: true,
//       );
//     } else {
//       logger.e('Permissions not granted for selecting multiple images.');
//       throw Exception('Permissions not granted');
//     }
//   }

//   /// Select a single video from the gallery.
//   Future selectSingleVideo() async {
//     if (await _requestPermissions()) {
//       return await _picker.openPicker(
//         pickerOptions: HLPickerOptions(
//           mediaType: MediaType.video,
//           maxSelectedAssets: 1,
//         ),
//       );
//     } else {
//       logger.e('Permissions not granted for selecting a single video.');
//       throw Exception('Permissions not granted');
//     }
//   }

//   /// Select multiple videos from the gallery.
//   Future<List?> selectMultipleVideos() async {
//     if (await _requestPermissions()) {
//       return await _picker.openPicker(
//         pickerOptions: HLPickerOptions(
//           mediaType: MediaType.video,
//         ),
//       );
//     } else {
//       logger.e('Permissions not granted for selecting multiple videos.');
//       throw Exception('Permissions not granted');
//     }
//   }

//   /// Select a single audio file from the gallery.
//   Future selectSingleAudio() async {
//     if (await _requestPermissions()) {
//       return await _picker.openPicker(
//         pickerOptions: HLPickerOptions(
//           mediaType: MediaType.all,
//           maxSelectedAssets: 1,
//         ),
//       );
//     } else {
//       logger.e('Permissions not granted for selecting a single audio file.');
//       throw Exception('Permissions not granted');
//     }
//   }

//   /// Select multiple audio files from the gallery.
//   Future<List?> selectMultipleAudios() async {
//     if (await _requestPermissions()) {
//       return await _picker.openPicker(
//         pickerOptions: HLPickerOptions(
//           mediaType: MediaType.all,
//         ),
//       );
//     } else {
//       logger.e('Permissions not granted for selecting multiple audio files.');
//       throw Exception('Permissions not granted');
//     }
//   }

//   /// Select all file types from the gallery.
//   Future<List?> selectAllFiles() async {
//     if (await _requestPermissions()) {
//       return await _picker.openPicker(
//         pickerOptions: HLPickerOptions(
//           mediaType: MediaType.all,
//         ),
//       );
//     } else {
//       logger.e('Permissions not granted for selecting all file types.');
//       throw Exception('Permissions not granted');
//     }
//   }

//   /// Access the camera with the specified lens (front or back).
//   Future accessCamera({bool useFrontCamera = false}) async {
//     if (await _requestPermissions()) {
//       return await _picker.openCamera(
//         cropping: true,
//         cameraOptions: HLCameraOptions(),
//         cropOptions: HLCropOptions(),
//       );
//     } else {
//       logger.e('Permissions not granted for accessing the camera.');
//       throw Exception('Permissions not granted');
//     }
//   }
// }
