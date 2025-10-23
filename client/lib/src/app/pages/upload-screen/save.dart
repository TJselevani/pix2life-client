// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pix2life/core/constants.dart';
// import 'package:pix2life/core/utils/alerts/failure.dart';
// import 'package:pix2life/core/utils/alerts/success.dart';
// import 'package:pix2life/core/utils/logger/logger.dart';
// import 'package:pix2life/core/utils/permissions.dart';
// import 'package:pix2life/core/utils/theme/app_palette.dart';
// import 'package:pix2life/core/utils/pick-media/media_picker_service.dart';
// import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
// import 'package:pix2life/src/features/audio/presentation/bloc/audio_bloc.dart';
// import 'package:pix2life/src/features/auth/data/data_source/auth_provider.dart';
// import 'package:pix2life/src/features/auth/domain/entities/user.dart';
// import 'package:pix2life/src/features/gallery/data/data_source/gallery_provider.dart';
// import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
// import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
// import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';
// import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';
// import 'package:pix2life/src/shared/widgets/media-preview-container/audios_preview.dart';
// import 'package:pix2life/src/shared/widgets/media-preview-container/images_preview.dart';
// import 'package:pix2life/src/shared/widgets/media-preview-container/videos_preview.dart';
// import 'package:provider/provider.dart';

// class MediaUploadScreen extends StatefulWidget {
//   const MediaUploadScreen({super.key});

//   @override
//   State<MediaUploadScreen> createState() => _MediaUploadScreenState();
// }

// class _MediaUploadScreenState extends State<MediaUploadScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final MediaPickerService mediaPickerService = MediaPickerService();
//   final log = createLogger(MediaUploadScreen);
//   List<XFile>? _images = [];
//   List<XFile>? _videos = [];
//   List<XFile>? _audios = [];
//   List<XFile>? _copyMedia = [];
//   List<String> _uploadingMedia = [];
//   List<String> _uploadDone = [];
//   List<String> _uploadFailed = [];
//   List<XFile>? _selectedMedia = [];
//   List<Gallery>? fetchedGalleries;
//   bool _galleriesLoading = true;
//   User? authUser;
//   List<String> galleryNames = [];
//   String _selectedMediaType = ''; // Stores the selected media type
//   bool _isLoading = false;
//   String? _selectedGallery;
//   bool isDarkMode = false;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize isDarkMode based on themeProvider's current theme
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final themeProvider =
//           Provider.of<MyThemeProvider>(context, listen: false);
//       setState(() {
//         isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
//             (themeProvider.themeMode == ThemeMode.system &&
//                 MediaQuery.of(context).platformBrightness == Brightness.dark);
//       });
//     });

//     final galleryState = BlocProvider.of<GalleryBloc>(context).state;
//     if (galleryState is! GalleriesLoaded) {
//       BlocProvider.of<GalleryBloc>(context).add(GalleryFetchGalleriesEvent());
//     }

//     requestPermissions();
//   }

//   // Media pick methods
//   Future<void> _pickImages() async {
//     setState(() {
//       if (_selectedMediaType != 'images') {
//         _selectedMedia = [];
//         _videos = [];
//         _audios = [];
//       }
//       _selectedMediaType = 'images'; // Set media type
//     });

//     final List<XFile>? selectedImages =
//         await mediaPickerService.pickMultipleImages();

//     if (selectedImages != null && selectedImages.isNotEmpty) {
//       setState(() {
//         _images!.addAll(selectedImages); // Append to existing images
//         _selectedMedia!.addAll(selectedImages); // Append to selected media
//       });
//     }
//   }

//   Future<void> _pickVideo() async {
//     setState(() {
//       if (_selectedMediaType != 'videos') {
//         _selectedMedia = [];
//         _images = [];
//         _audios = [];
//       }
//       _selectedMediaType = 'videos'; // Set media type
//     });

//     final List<XFile>? selectedVideos =
//         await mediaPickerService.pickMultipleVideos();
//     if (selectedVideos != null) {
//       setState(() {
//         _videos!.addAll(selectedVideos); // Append to existing videos
//         _selectedMedia!.addAll(selectedVideos); // Append to selected media
//       });
//     }
//   }

//   Future<void> _pickAudios() async {
//     setState(() {
//       if (_selectedMediaType != 'audios') {
//         _selectedMedia = [];
//         _images = [];
//         _videos = [];
//       }
//       _selectedMediaType = 'audios'; // Set media type
//     });

//     final List<XFile>? audioFiles =
//         await mediaPickerService.pickMultipleAudios();

//     if (audioFiles != null && audioFiles.isNotEmpty) {
//       setState(() {
//         _audios!.addAll(audioFiles); // Append to existing audios
//         _selectedMedia!.addAll(audioFiles); // Append to selected media
//       });
//     }
//   }

//   Future<void> _uploadImages(FormData formData, String galleryName) async {
//     context
//         .read<ImageBloc>()
//         .add(ImageUploadEvent(formData: formData, galleryName: galleryName));
//   }

//   Future<void> _uploadVideos(FormData formData, String galleryName) async {
//     context
//         .read<VideoBloc>()
//         .add(VideoUploadEvent(formData: formData, galleryName: galleryName));
//   }

//   Future<void> _uploadAudios(FormData formData, String galleryName) async {
//     context
//         .read<AudioBloc>()
//         .add(AudioUploadEvent(formData: formData, galleryName: galleryName));
//   }

//   Future<void> _uploadMedia<T>(
//     List<XFile>? mediaList,
//     Future Function(FormData formData, String galleryName) uploadFunction,
//   ) async {
//     if (mediaList == null || mediaList.isEmpty) {
//       ErrorSnackBar.show(context: context, message: 'No media to upload');
//       return;
//     }
//     final galleryName = _nameController.text.trim();
//     if (galleryName.isEmpty ||
//         galleryName == '' ||
//         galleryName == 'galleryName') {
//       ErrorSnackBar.show(context: context, message: 'No Gallery Selected');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _copyMedia!.addAll(mediaList);
//     });

//     // Iterate over the mediaList for uploads
//     for (XFile media in mediaList) {
//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(media.path, filename: media.name),
//       });

//       setState(() {
//         _uploadingMedia.add(media.name); // Mark as uploading
//       });

//       try {
//         await uploadFunction(formData, galleryName);

//         if (!mounted) return;

//         setState(() {
//           _uploadDone.add(media.name); // Mark as uploaded
//           _uploadingMedia.remove(media.name); // Remove from uploading
//         });
//       } catch (e) {
//         if (!mounted) return;

//         setState(() {
//           _uploadFailed.add(media.name); // Track failed uploads
//           _uploadingMedia.remove(media.name); // Remove from uploading
//         });
//       }
//     }

//     if (_uploadDone.length == _copyMedia!.length) {
//       log.i('All media files uploaded successfully. Resetting...');
//       _reset(); // Reset state only after all media is uploaded
//     }

//     setState(() {
//       _isLoading = false; // Stop loading after upload completes
//     });
//   }

// // Retry logic for failed uploads
//   // void _retryUpload(XFile media) async {
//   //   if (_uploadFailed.contains(media.name)) {
//   //     setState(() {
//   //       _uploadFailed.remove(media.name); // Remove from failed list
//   //     });

//   //     FormData formData = FormData.fromMap({
//   //       "file": await MultipartFile.fromFile(media.path, filename: media.name),
//   //     });

//   //     try {
//   //       final galleryName = _nameController.text.trim();
//   //       await _uploadMedia([media], _uploadImages); // Retry the upload

//   //       setState(() {
//   //         _uploadDone.add(media.name); // Add to done after retry success
//   //       });
//   //     } catch (e) {
//   //       setState(() {
//   //         _uploadFailed.add(media.name); // If retry fails, add back to failed
//   //       });
//   //     }
//   //   }
//   // }

//   // Future<void> _uploadMedia<T>(
//   //   List<XFile>? mediaList,
//   //   Future Function(FormData formData, String galleryName) uploadFunction,
//   // ) async {
//   //   if (mediaList == null || mediaList.isEmpty) {
//   //     ErrorSnackBar.show(context: context, message: 'No media to upload');
//   //     return;
//   //   }

//   //   setState(() {
//   //     _isLoading = true;
//   //     _copyMedia!.addAll(mediaList);
//   //   });

//   //   await Future.forEach(mediaList, (XFile media) async {
//   //     FormData formData = FormData.fromMap({
//   //       "file": await MultipartFile.fromFile(media.path, filename: media.name),
//   //     });

//   //     log.i('Uploading file: ${media.name}, path: ${media.path}');
//   //     log.i('FormData being sent: ${formData.fields}');

//   //     setState(() {
//   //       _uploadingMedia.add(media.name);
//   //     });

//   //     try {
//   //       final galleryName = _nameController.text.trim();
//   //       log.i('Gallery name: $galleryName');

//   //       await uploadFunction(formData, galleryName);

//   //       if (!mounted) return;
//   //       setState(() {
//   //         _uploadDone.add(media.name);
//   //       });
//   //     } catch (e) {
//   //       if (!mounted) return;
//   //       setState(() {
//   //         _uploadFailed.add(media.name); // Track failed uploads
//   //       });
//   //     }
//   //   });
//   //   // Check if all media have been uploaded successfully
//   //   if (_uploadDone.length == _copyMedia!.length) {
//   //     log.i('All media files uploaded successfully. Resetting...');
//   //     // _reset(); // Reset state only after all media is uploaded
//   //   }

//   //   if (!mounted) return;
//   // }

//   _reset() {
//     setState(() {
//       _isLoading = false;
//       _images = [];
//       _videos = [];
//       _audios = [];
//       _uploadingMedia = [];
//       _uploadDone = [];
//       _copyMedia = [];
//       _uploadFailed = [];
//       _selectedMediaType = '';
//     });
//   }

//   bool _isUploadingInProgress() {
//     return _uploadingMedia.isNotEmpty &&
//         _uploadingMedia.length > _uploadDone.length;
//   }

//   // Future<void> _cancelUpload() async {
//   //   // Logic to cancel the upload and clean up the media list
//   //   setState(() {
//   //     _copyMedia!.clear();
//   //     _uploadingMedia.clear();
//   //     _uploadDone.clear();
//   //   });
//   // }

//   Widget _buildUploadingMediaList() {
//     return SingleChildScrollView(
//       child: Column(
//         children: _copyMedia!.map((media) {
//           final isUploading = _uploadingMedia.contains(media.name);
//           final isUploaded = _uploadDone.contains(media.name);
//           final isFailed = _uploadFailed.contains(media.name);

//           return Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 5.h),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ListTile(
//                   leading: isUploading
//                       ? const Icon(Icons.cloud_upload)
//                       : isUploaded
//                           ? const Icon(Icons.cloud_done, color: Colors.green)
//                           : const Icon(Icons.cloud_off, color: Colors.red),
//                   title: Text(
//                     media.name,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,
//                     style: TextStyle(fontSize: 16.sp),
//                   ),
//                   trailing: isUploaded
//                       ? const Icon(Icons.check, color: Colors.green)
//                       : isFailed
//                           ? IconButton(
//                               icon: const Icon(Icons.refresh),
//                               onPressed: () => {} //_retryUpload(media),
//                               )
//                           : const CircularProgressIndicator(),
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   // Widget _buildUploadingMediaList() {
//   //   return SingleChildScrollView(
//   //     child: Column(
//   //       children: _copyMedia!.map((media) {
//   //         final isUploading = _uploadingMedia.contains(media.name);
//   //         final isUploaded = _uploadDone.contains(media.name);

//   //         return Center(
//   //           child: Padding(
//   //             padding: EdgeInsets.symmetric(vertical: 5.h),
//   //             child: SizedBox(
//   //               width: double.infinity,
//   //               child: ListTile(
//   //                 leading: isUploading
//   //                     ? const Icon(Icons.cloud)
//   //                     : const Icon(Icons.cloud_circle),
//   //                 title: Text(
//   //                   media.name,
//   //                   overflow: TextOverflow.ellipsis,
//   //                   maxLines: 1,
//   //                   style: TextStyle(fontSize: 16.sp),
//   //                 ),
//   //                 trailing: isUploaded
//   //                     ? const Icon(Icons.check, color: Colors.green)
//   //                     : _uploadFailed.contains(media.name)
//   //                         ? IconButton(
//   //                             icon: const Icon(Icons.refresh),
//   //                             onPressed: () => {}, //_retryUpload(media),
//   //                           )
//   //                         : null,
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       }).toList(),
//   //     ),
//   //   );
//   // }

//   // Unified media preview
//   Widget _buildMediaPreview() {
//     if (_selectedMediaType == 'images' && _images!.isNotEmpty) {
//       return buildImagesGridPreview(
//           context: context,
//           imageFiles: _images!,
//           onRemove: (int index) {
//             setState(() {
//               _images!.removeAt(index); // Handle image removal
//             });
//           });
//     } else if (_selectedMediaType == 'videos' && _videos!.isNotEmpty) {
//       return buildVideosGridPreview(
//           context: context,
//           videoFiles: _videos!,
//           onRemove: (int index) {
//             setState(() {
//               _videos!.removeAt(index); // Handle image removal
//             });
//           });
//     } else if (_selectedMediaType == 'audios' && _audios!.isNotEmpty) {
//       return buildAudiosListPreview(
//           context: context,
//           audioFiles: _audios!,
//           onRemove: (int index) {
//             setState(() {
//               _audios!.removeAt(index); // Handle image removal
//             });
//           });
//     } else {
//       return const Center(child: Text('No media selected.'));
//     }
//   }

//   Widget _buildGalleryOptions() {
//     if (fetchedGalleries != null) {
//       List<String> names =
//           fetchedGalleries!.map((gallery) => gallery.name).toList();
//       setState(() {
//         galleryNames.clear();
//         galleryNames.addAll(names);
//       });
//     }

//     return _galleriesLoading
//         ? const Center(child: CircularProgressIndicator())
//         : Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               width: 300, // Set the width of the dropdown container
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(
//                     color: isDarkMode
//                         ? AppPalette.primaryBlack.withAlpha(50)
//                         : AppPalette.lightBackground
//                             .withAlpha(20)), // Border color based on theme
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               child: DropdownButton<String>(
//                 value: _selectedGallery,
//                 hint: Text(
//                   'Select gallery',
//                   style: TextStyle(
//                     color: Theme.of(context)
//                         .textTheme
//                         .bodyLarge
//                         ?.color, // Responsive to theme
//                   ),
//                 ),
//                 isExpanded: true, // Ensures the dropdown expands to full width
//                 icon: Icon(
//                   Icons.arrow_drop_down,
//                   color: Theme.of(context)
//                       .colorScheme
//                       .primary, // Arrow color based on theme
//                 ),
//                 dropdownColor: Theme.of(context)
//                     .colorScheme
//                     .surface, // Matches Material You colors
//                 items: galleryNames.map((String name) {
//                   return DropdownMenuItem<String>(
//                     value: name,
//                     child: Container(
//                       width: 300, // Ensure each item has the same width
//                       padding: const EdgeInsets.all(8.0), // Padding around text
//                       decoration: BoxDecoration(
//                         border: Border.all(
//                             color: Colors.grey), // Border around each item
//                         borderRadius: BorderRadius.circular(
//                             4), // Rounded corners for items
//                       ),
//                       child: Text(
//                         name,
//                         overflow: TextOverflow
//                             .ellipsis, // Handle overflow with ellipsis
//                         maxLines: 1, // Limit to a single line
//                         style: TextStyle(
//                           color: Theme.of(context)
//                               .textTheme
//                               .bodyLarge
//                               ?.color, // Text color based on theme
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedGallery = newValue;
//                     _nameController.text = newValue ?? '';
//                   });
//                 },
//                 underline: const SizedBox.shrink(), // Removes default underline
//               ),
//             ),
//           );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<MyUserProvider>(context);
//     final galleryProvider = Provider.of<MyGalleryProvider>(context);
//     authUser = userProvider.user;
//     fetchedGalleries = galleryProvider.galleries;
//     _galleriesLoading = galleryProvider.isLoading;

//     final themeProvider = Provider.of<MyThemeProvider>(context);
//     isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
//         (themeProvider.themeMode == ThemeMode.system &&
//             MediaQuery.of(context).platformBrightness == Brightness.dark);

//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(18.0),
//         child: Column(
//           children: [
//             SizedBox(height: 20.h),
//             _buildProfileSection(),
//             _buildOverviewSection(),
//             _buildActionCards(context),
//           ],
//         ),
//       ),
//     ));
//   }

//   Widget _buildProfileSection() {
//     return Container(
//       height: 300.h,
//       decoration: BoxDecoration(
//         color: isDarkMode
//             ? AppPalette.primaryBlack.withAlpha(50)
//             : AppPalette.lightBackground.withAlpha(220),
//         borderRadius: BorderRadius.circular(15.r),
//         boxShadow: [
//           BoxShadow(
//             color: AppPalette.secondaryBlack.withOpacity(0.1),
//             blurRadius: 10.r,
//             spreadRadius: 5.r,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
//       child: _selectedMediaType.isNotEmpty && _selectedMediaType != ''
//           ? SizedBox(
//               width: double.infinity,
//               height: double.infinity,
//               child: _uploadingMedia.isNotEmpty ||
//                       _isUploadingInProgress() ||
//                       _isLoading //_copyMedia!.isNotEmpty &&  _copyMedia!.length != _uploadDone.length
//                   ? _buildUploadingMediaList()
//                   : _buildMediaPreview(),
//             )
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 100.w,
//                       height: 100.h,
//                       child: Image.asset(AppImage.playStoreImg),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.h),
//                 Text(
//                   'Media Upload',
//                   style: TextStyle(
//                     fontSize: 22.sp,
//                     fontWeight: FontWeight.bold,
//                     color: isDarkMode ? null : Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Text(
//                   'Select a Gallery and upload media',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _buildStatColumn(
//                         'Galleries', '${fetchedGalleries!.length} Galleries'),
//                     _buildStatColumn('Account', authUser!.subscriptionPlan),
//                   ],
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _buildStatColumn(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//             color: isDarkMode ? null : Colors.black87,
//           ),
//         ),
//         SizedBox(height: 5.h),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 16.sp,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildOverviewSection() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: 170.w,
//             // height: 200.h,
//             child: _buildGalleryOptions(),
//           ),
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
//         onTap: onPress,
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Container(
//               padding: EdgeInsets.all(
//                   constraints.maxWidth * 0.05), // Adaptive padding
//               decoration: BoxDecoration(
//                 color: isDarkMode
//                     ? AppPalette.primaryBlack.withAlpha(50)
//                     : AppPalette.lightBackground.withAlpha(220),
//                 borderRadius: BorderRadius.circular(15.r), // Responsive radius
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppPalette.secondaryBlack.withOpacity(0.1),
//                     blurRadius: 10.r,
//                     spreadRadius: 5.r,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   GestureDetector(
//                     onTap: onPress,
//                     child: Container(
//                       padding: EdgeInsets.all(
//                           constraints.maxWidth * 0.03), // Adaptive padding
//                       decoration: BoxDecoration(
//                         color: AppPalette.red,
//                         borderRadius: BorderRadius.circular(
//                             10.r), // Responsive border radius
//                       ),
//                       child: Icon(icon,
//                           size: 30.sp, color: AppPalette.primaryWhite),
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title,
//                           style: TextStyle(
//                             fontSize: 16.sp, // Adaptive font size
//                             fontWeight: FontWeight.bold,
//                             color: isDarkMode ? null : Colors.black87,
//                           ),
//                           maxLines: 1, // Ensure text doesn't overflow
//                           overflow:
//                               TextOverflow.ellipsis, // Ellipsis for long text
//                         ),
//                         SizedBox(height: 5.h),
//                         Text(
//                           subtitle,
//                           style: TextStyle(
//                             fontSize: 14.sp, // Adaptive font size
//                             color: Colors.grey,
//                           ),
//                           maxLines: 2, // Limit subtitle to two lines
//                           overflow: TextOverflow
//                               .ellipsis, // Ellipsis for long subtitle
//                         ),
//                         SizedBox(height: 10.h),
//                         if (state is ImageLoading ||
//                             state is AudioLoading ||
//                             state is VideoLoading)
//                           const LinearProgressIndicator(),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 10.w),
//                   uploadIcon,
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
