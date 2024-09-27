// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pix2life/src/shared/widgets/video_player/file_video_thumnail_widget.dart';

// class UploadScreen extends StatefulWidget {
//   const UploadScreen({super.key});

//   @override
//   State<UploadScreen> createState() => _UploadScreenState();
// }

// class _UploadScreenState extends State<UploadScreen> {
//   final ImagePicker _picker = ImagePicker();
//   List<XFile>? _images = [];
//   List<XFile>? _videos = [];
//   List<XFile>? _audios = [];
//   List<XFile>? _selectedMedia = [];
//   String _selectedMediaType = ''; // Stores the selected media type

//   // Media pick methods
//   Future<void> _pickImages() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     setState(() {
//       _selectedMediaType = 'images'; // Set media type
//       _selectedMedia = [];
//       _videos = [];
//       _audios = [];
//     });

//     final List<XFile>? selectedImages = (await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//     ))
//         ?.files
//         .map((file) => XFile(file.path!))
//         .toList();

//     if (selectedImages != null && selectedImages.isNotEmpty) {
//       setState(() {
//         _images = selectedImages;
//         _selectedMedia!.addAll(selectedImages);
//       });
//     }
//   }

//   Future<void> _pickVideo() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     setState(() {
//       _selectedMediaType = 'videos'; // Set media type
//       _selectedMedia = [];
//       _images = [];
//       _audios = [];
//     });

//     final XFile? videoPicker =
//         await _picker.pickVideo(source: ImageSource.gallery);
//     if (videoPicker != null) {
//       setState(() {
//         _videos = [videoPicker];
//         _selectedMedia!.add(videoPicker);
//       });
//     }
//   }

//   Future<void> _pickAudios() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     setState(() {
//       _selectedMediaType = 'audios'; // Set media type
//       _selectedMedia = [];
//       _images = [];
//       _videos = [];
//     });

//     final List<XFile>? audioFiles = (await FilePicker.platform.pickFiles(
//       type: FileType.audio,
//       allowMultiple: true,
//     ))
//         ?.files
//         .map((file) => XFile(file.path!))
//         .toList();

//     if (audioFiles != null && audioFiles.isNotEmpty) {
//       setState(() {
//         _audios = audioFiles;
//         _selectedMedia!.addAll(audioFiles);
//       });
//     }
//   }

//   // Unified media preview
//   Widget _buildMediaPreview() {
//     if (_selectedMediaType == 'images' && _images!.isNotEmpty) {
//       return _buildGridPreview(_images!);
//     } else if (_selectedMediaType == 'videos' && _videos!.isNotEmpty) {
//       return _buildGridPreview2(_videos!);
//     } else if (_selectedMediaType == 'audios' && _audios!.isNotEmpty) {
//       return _buildListPreview(_audios!);
//     } else {
//       return const Text('No media selected.');
//     }
//   }

//   // Grid preview for images and videos
//   Widget _buildGridPreview(List<XFile> mediaFiles) {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//       ),
//       itemCount: mediaFiles.length,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return ImageSelectionContainer(
//           mediaPath: mediaFiles[index].path,
//           onRemove: () {
//             setState(() {
//               mediaFiles.removeAt(index);
//             });
//           },
//         );
//       },
//     );
//   }

//   Widget _buildGridPreview2(List<XFile> mediaFiles) {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//       ),
//       itemCount: mediaFiles.length,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return VideoSelectionContainer(
//           mediaPath: mediaFiles[index].path,
//           onRemove: () {
//             setState(() {
//               mediaFiles.removeAt(index);
//             });
//           },
//         );
//       },
//     );
//   }

//   // List preview for audios
//   Widget _buildListPreview(List<XFile> audioFiles) {
//     return ListView.builder(
//       itemCount: audioFiles.length,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(audioFiles[index].name),
//           trailing: IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () {
//               setState(() {
//                 audioFiles.removeAt(index);
//               });
//             },
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Media preview section
//             if (_selectedMediaType.isNotEmpty) _buildMediaPreview(),
//             const SizedBox(height: 20),
//             // Buttons to pick media
//             ElevatedButton(
//               onPressed: _pickImages,
//               child: const Text('Pick Images'),
//             ),
//             ElevatedButton(
//               onPressed: _pickVideo,
//               child: const Text('Pick Video'),
//             ),
//             ElevatedButton(
//               onPressed: _pickAudios,
//               child: const Text('Pick Audios'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Helper widget to display media previews (e.g., images, videos)
// class ImageSelectionContainer extends StatelessWidget {
//   final String mediaPath;
//   final VoidCallback? onRemove;

//   const ImageSelectionContainer({
//     super.key,
//     required this.mediaPath,
//     this.onRemove,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Image.file(
//           File(mediaPath),
//           fit: BoxFit.cover,
//           width: double.infinity,
//           height: double.infinity,
//         ),
//         Positioned(
//           top: 8.0,
//           right: 8.0,
//           child: InkWell(
//             onTap: onRemove,
//             child: const Icon(Icons.close, color: Colors.red),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // Helper widget to display media previews (e.g., images, videos)
// class VideoSelectionContainer extends StatelessWidget {
//   final String mediaPath;
//   final VoidCallback? onRemove;

//   const VideoSelectionContainer({
//     super.key,
//     required this.mediaPath,
//     this.onRemove,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           height: double.infinity,
//           child: FileVideoThumbnailWidget(filePath: mediaPath),
//         ),
//         Positioned(
//           top: 8.0,
//           right: 8.0,
//           child: InkWell(
//             onTap: onRemove,
//             child: const Icon(Icons.close, color: Colors.red),
//           ),
//         ),
//       ],
//     );
//   }
// }
