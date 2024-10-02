// import 'dart:async';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pix2life/core/utils/alerts/failure.dart';
// import 'package:pix2life/core/utils/alerts/success.dart';
// import 'package:pix2life/core/utils/logger/logger.dart';
// import 'package:pix2life/core/utils/theme/app_palette.dart';
// import 'package:pix2life/src/features/audio/presentation/bloc/audio_bloc.dart';
// import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
// import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
// import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';
// import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';
// import 'package:pix2life/src/shared/widgets/video_player/file_video_thumbnail_widget.dart';

// class UploadScreen extends StatefulWidget {
//   const UploadScreen({super.key});

//   @override
//   State<UploadScreen> createState() => _UploadScreenState();
// }

// class _UploadScreenState extends State<UploadScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final log = createLogger(UploadScreen);
//   final ImagePicker _picker = ImagePicker();
//   List<XFile>? _images = [];
//   List<XFile>? _videos = [];
//   List<XFile>? _audios = [];
//   List<XFile> _copyMedia = [];
//   List<String> _uploadingMedia = [];
//   List<String> _uploadDone = [];
//   List<XFile>? _selectedMedia = [];
//   List<Gallery> fetchedGalleries = [];
//   List<String> galleryNames = [];
//   String _selectedMediaType = ''; // Stores the selected media type
//   bool _isLoading = true;

//   String? _selectedGallery;

//   @override
//   void initState() {
//     super.initState();
//     final currentState = context.read<GalleryBloc>().state;

//     // Only trigger the fetch event if the data has not been loaded yet
//     if (currentState is! GalleriesLoaded) {
//       context.read<GalleryBloc>().add(GalleryFetchGalleriesEvent());
//     }
//   }

//   // Media pick methods
//   Future<void> _pickImages() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     setState(() {
//       if (_selectedMediaType != 'images') {
//         _selectedMedia = [];
//         _videos = [];
//         _audios = [];
//       }
//       _selectedMediaType = 'images'; // Set media type
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
//         _images!.addAll(selectedImages); // Append to existing images
//         _selectedMedia!.addAll(selectedImages); // Append to selected media
//       });
//     }
//   }

//   Future<void> _uploadImages(FormData formData, String galleryName) async {
//     context
//         .read<ImageBloc>()
//         .add(ImageUploadEvent(formData: formData, galleryName: 'galleryName'));
//   }

//   Future<void> _pickVideo() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     setState(() {
//       if (_selectedMediaType != 'videos') {
//         _selectedMedia = [];
//         _images = [];
//         _audios = [];
//       }
//       _selectedMediaType = 'videos'; // Set media type
//     });

//     final XFile? videoPicker =
//         await _picker.pickVideo(source: ImageSource.gallery);
//     if (videoPicker != null) {
//       setState(() {
//         _videos!.add(videoPicker); // Append to existing videos
//         _selectedMedia!.add(videoPicker); // Append to selected media
//       });
//     }
//   }

//   Future<void> _uploadVideos(FormData formData, String galleryName) async {
//     context
//         .read<VideoBloc>()
//         .add(VideoUploadEvent(formData: formData, galleryName: 'galleryName'));
//   }

//   Future<void> _pickAudios() async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     setState(() {
//       if (_selectedMediaType != 'audios') {
//         _selectedMedia = [];
//         _images = [];
//         _videos = [];
//       }
//       _selectedMediaType = 'audios'; // Set media type
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
//         _audios!.addAll(audioFiles); // Append to existing audios
//         _selectedMedia!.addAll(audioFiles); // Append to selected media
//       });
//     }
//   }

//   Future<void> _uploadAudios(FormData formData, String galleryName) async {
//     context
//         .read<AudioBloc>()
//         .add(AudioUploadEvent(formData: formData, galleryName: 'galleryName'));
//   }

//   Future<void> _uploadMedia<T>(
//     List<XFile>? mediaList,
//     Future Function(FormData formData, String galleryName) uploadFunction,
//   ) async {
//     // if (!mounted) return;

//     if (mediaList == null || mediaList.isEmpty) {
//       ErrorSnackBar.show(context: context, message: 'No media to upload');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _copyMedia.addAll(mediaList);
//     });

//     await Future.forEach(mediaList, (XFile media) async {
//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(media.path, filename: media.name),
//       });

//       log.i('Uploading file: ${media.name}, path: ${media.path}');
//       log.i('FormData being sent: ${formData.fields}');

//       setState(() {
//         _uploadingMedia.add(media.name);
//       });

//       try {
//         final galleryName = _nameController.text.trim();
//         log.i('Gallery name: $galleryName');

//         await uploadFunction(formData, galleryName);

//         if (!mounted) return;

//         setState(() {
//           log.i('Successfully uploaded ${media.runtimeType}: ${media.name}');
//           _uploadDone.add(media.name);
//         });
//       } catch (e) {
//         if (!mounted) return;

//         setState(() {
//           ErrorSnackBar.show(context: context, message: '$e');
//           log.e('Upload failed for ${media.runtimeType} ${media.name}: $e');
//         });
//       }
//     });
//     // Check if all media have been uploaded successfully
//     if (_uploadDone.length == _copyMedia.length) {
//       log.i('All media files uploaded successfully. Resetting...');
//       _reset(); // Reset state
//     }

//     if (!mounted) return;
//   }

//   _reset() {
//     setState(() {
//       _isLoading = false;
//       _images = [];
//       _videos = [];
//       _audios = [];
//       _uploadingMedia = [];
//       _uploadDone = [];
//       _copyMedia = [];
//       _selectedMediaType = '';
//     });
//   }

//   Widget _buildUploadingMediaList() {
//     return SingleChildScrollView(
//       child: Column(
//         children: _copyMedia.map((media) {
//           final isUploading = _uploadingMedia.contains(media.name);
//           final isUploaded = _uploadDone.contains(media.name);

//           return Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                   vertical: 5.h), // Add padding between items
//               child: SizedBox(
//                 width: double.infinity, // Ensure it takes full width of parent
//                 child: ListTile(
//                   leading: isUploading
//                       ? const Icon(Icons.cloud)
//                       : const Icon(Icons.cloud_circle),
//                   title: Text(
//                     media.name,
//                     overflow: TextOverflow.ellipsis, // Text overflow handling
//                     maxLines: 1, // Restrict to one line
//                     style: TextStyle(fontSize: 16.sp),
//                   ),
//                   trailing: isUploaded
//                       ? const Icon(Icons.check,
//                           color: Colors.green) // Show check when done
//                       : null,
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   String? getCurrentUploadingFile() {
//     if (_uploadingMedia.isNotEmpty) {
//       return _uploadingMedia.last; // Get the last file in the uploading list
//     }
//     return null; // Return null if no file is being uploaded
//   }

//   Widget _buildUploadingStatus() {
//     String? currentFile = getCurrentUploadingFile();
//     return currentFile != null
//         ? Container(
//             padding: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const CircularProgressIndicator(), // Progress indicator
//                 const SizedBox(width: 10),
//                 Text(
//                   'Uploading: $currentFile',
//                   style: const TextStyle(fontSize: 16, color: Colors.black87),
//                 ),
//               ],
//             ),
//           )
//         : const SizedBox
//             .shrink(); // Return an empty container if no file is uploading
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
//       return const Center(child: Text('No media selected.'));
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
//       physics: const AlwaysScrollableScrollPhysics(),
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
//         crossAxisCount: 2,
//         crossAxisSpacing: 8.0,
//         mainAxisSpacing: 8.0,
//       ),
//       itemCount: mediaFiles.length,
//       shrinkWrap: true,
//       physics: const AlwaysScrollableScrollPhysics(),
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
//       physics: const AlwaysScrollableScrollPhysics(),
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

//   Widget _buildGalleryOptions() {
//     return Padding(
//       padding: const EdgeInsets.all(5),
//       child: DropdownButton<String>(
//         value: _selectedGallery,
//         hint: const Text('Select gallery'),
//         items: galleryNames.map((String name) {
//           return DropdownMenuItem<String>(
//             value: name,
//             child: Text(name),
//           );
//         }).toList(),
//         onChanged: (String? newValue) {
//           setState(() {
//             _selectedGallery = newValue;
//             // Pass the selected gallery name to your function here
//             _nameController.text = newValue ?? '';
//           });
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentState = context.read<GalleryBloc>().state;
//     if (currentState is GalleryInitial) {
//       context.read<GalleryBloc>().add(GalleryFetchGalleriesEvent());

//       final nextState = context.read<GalleryBloc>().state;
//       if (nextState is GalleriesLoaded) {
//         final data =
//             (BlocProvider.of<GalleryBloc>(context).state as GalleriesLoaded)
//                 .galleries;
//         log.i('successfully fetch galleries');
//         setState(() {
//           fetchedGalleries = data;
//           galleryNames =
//               fetchedGalleries.map((gallery) => gallery.name).toList();
//         });
//       }
//     }

//     return Scaffold(
//       backgroundColor: AppPalette.lightBackground,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               _buildProfileSection(),
//               _buildOverviewSection(),
//               _buildActionCards(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileSection() {
//     return Container(
//       height: 300.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: AppPalette.secondaryBlack.withOpacity(0.1),
//             blurRadius: 10.r,
//             spreadRadius: 5,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//       child: _selectedMediaType.isNotEmpty && _selectedMediaType != ''
//           ? SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//               child: _copyMedia.isNotEmpty && _isLoading
//                   ? _buildUploadingMediaList()
//                   : _buildMediaPreview(),
//             )
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(Icons.menu, size: 30, color: Colors.grey),
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: NetworkImage(
//                         'https://random.imagecdn.app/150/150', // Replace with actual profile image URL
//                       ),
//                     ),
//                     Icon(Icons.more_vert, size: 30, color: Colors.grey),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'tjselevani',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 const Text(
//                   'UX/UI Designer',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildStatColumn('Income', '\$8900'),
//                     _buildStatColumn('Expenses', '\$5500'),
//                     _buildStatColumn('Loan', '\$890'),
//                   ],
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildStatColumn(String label, String amount) {
//     return Column(
//       children: [
//         Text(
//           amount,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildOverviewSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _buildGalleryOptions(),
//           // Wrap(
//           //   children: [
//           //     Text(
//           //       'Select Gallery',
//           //       style: TextStyle(
//           //         fontSize: 18,
//           //         fontWeight: FontWeight.bold,
//           //         color: Colors.black87,
//           //       ),
//           //     ),
//           //     SizedBox(width: 10),
//           //     Icon(Icons.perm_media, color: Colors.grey),
//           //   ],
//           // ),
//           // Text('12 May 2024')
//         ],
//       ),
//     );
//   }

//   Widget _buildActionCards(BuildContext context) {
//     return Column(
//       children: [
//         BlocConsumer<ImageBloc, ImageState>(
//           listener: (context, state) {
//             if (state is ImageSuccess) {
//               SuccessSnackBar.show(context: context, message: state.message);
//             } else if (state is ImageFailure) {
//               ErrorSnackBar.show(context: context, message: state.message);
//             }
//           },
//           builder: (context, state) {
//             return _buildActionCard(
//               CupertinoIcons.camera,
//               _pickImages,
//               'Photographs, Pictures, Stills',
//               'Upload Photos from your Gallery',
//               _selectedMediaType == 'images' && _images!.isNotEmpty
//                   ? GestureDetector(
//                       onTap: () async {
//                         if (_images!.isNotEmpty) {
//                           await _uploadMedia(_images, _uploadImages);
//                         }
//                       },
//                       child: const Icon(CupertinoIcons.cloud_upload_fill))
//                   : const SizedBox.shrink(),
//               state,
//             );
//           },
//         ),
//         BlocConsumer<VideoBloc, VideoState>(
//           listener: (context, state) {
//             if (state is VideoSuccess) {
//               SuccessSnackBar.show(context: context, message: state.message);
//             } else if (state is VideoFailure) {
//               ErrorSnackBar.show(context: context, message: state.message);
//             }
//           },
//           builder: (context, state) {
//             return _buildActionCard(
//               CupertinoIcons.video_camera,
//               _pickVideo,
//               'Clips, Recordings, Visuals',
//               'Upload Videos from your Gallery',
//               _selectedMediaType == 'videos' && _videos!.isNotEmpty
//                   ? GestureDetector(
//                       onTap: () {
//                         if (_videos!.isNotEmpty) {
//                           _uploadMedia(_videos, _uploadVideos);
//                         }
//                       },
//                       child: const Icon(CupertinoIcons.cloud_upload_fill))
//                   : const SizedBox.shrink(),
//               state,
//             );
//           },
//         ),
//         BlocConsumer<AudioBloc, AudioState>(
//           listener: (context, state) {
//             if (state is AudioSuccess) {
//               SuccessSnackBar.show(context: context, message: state.message);
//             } else if (state is AudioFailure) {
//               ErrorSnackBar.show(context: context, message: state.message);
//             }
//           },
//           builder: (context, state) {
//             return _buildActionCard(
//               CupertinoIcons.music_albums,
//               _pickAudios,
//               'Mp3s, Music, Sound Bites',
//               'Upload Audios from your Gallery',
//               _selectedMediaType == 'audios' && _audios!.isNotEmpty
//                   ? GestureDetector(
//                       onTap: () {
//                         if (_audios!.isNotEmpty) {
//                           _uploadMedia(_audios, _uploadAudios);
//                         }
//                       },
//                       child: const Icon(CupertinoIcons.cloud_upload_fill))
//                   : const SizedBox.shrink(),
//               state,
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildActionCard(
//     IconData icon,
//     VoidCallback onPress,
//     String title,
//     String subtitle,
//     Widget uploadIcon,
//     dynamic state,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
//       child: GestureDetector(
//         onTap: null,
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(15),
//             boxShadow: [
//               BoxShadow(
//                 color: AppPalette.secondaryBlack.withOpacity(0.1),
//                 blurRadius: 10,
//                 spreadRadius: 5,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: onPress,
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: AppPalette.red,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(icon, size: 30, color: AppPalette.primaryWhite),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       subtitle,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     if (state is ImageLoading ||
//                         state is AudioLoading ||
//                         state is VideoLoading)
//                       const LinearProgressIndicator(),
//                   ],
//                 ),
//               ),
//               uploadIcon,
//             ],
//           ),
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
//             child: Container(
//               padding: const EdgeInsets.all(4.0),
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//               ),
//               child: const Icon(
//                 Icons.close,
//                 color: Colors.black,
//                 size: 18.0,
//               ),
//             ),
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
//             child: Container(
//               padding: const EdgeInsets.all(4.0),
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//               ),
//               child: const Icon(
//                 Icons.close,
//                 color: Colors.black,
//                 size: 18.0,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
