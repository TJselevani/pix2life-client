import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/pick-media/media_picker_service.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_provider.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/gallery/data/data_source/gallery_provider.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';
import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';
import 'package:pix2life/src/shared/widgets/media-preview-container/audios_preview.dart';
import 'package:pix2life/src/shared/widgets/media-preview-container/images_preview.dart';
import 'package:pix2life/src/shared/widgets/media-preview-container/videos_preview.dart';
import 'package:provider/provider.dart';

class MediaUploadScreen extends StatefulWidget {
  const MediaUploadScreen({super.key});

  @override
  State<MediaUploadScreen> createState() => _MediaUploadScreenState();
}

class _MediaUploadScreenState extends State<MediaUploadScreen> {
  final TextEditingController _nameController = TextEditingController();
  final MediaPickerService mediaPickerService = MediaPickerService();
  final log = createLogger(MediaUploadScreen);
  List<XFile>? _images = [];
  List<XFile>? _videos = [];
  List<XFile>? _audios = [];
  List<XFile>? _copyMedia = [];
  List<String> _uploadingMedia = [];
  List<String> _uploadDone = [];
  List<String> _uploadFailed = [];
  List<XFile>? _selectedMedia = [];
  List<Gallery>? fetchedGalleries;
  bool _galleriesLoading = true;
  User? authUser;
  List<String> galleryNames = [];
  String _selectedMediaType = ''; // Stores the selected media type
  bool _isLoading = true;
  String? _selectedGallery;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
  }

  // Media pick methods
  Future<void> _pickImages() async {
    setState(() {
      if (_selectedMediaType != 'images') {
        _selectedMedia = [];
        _videos = [];
        _audios = [];
      }
      _selectedMediaType = 'images'; // Set media type
    });

    final List<XFile>? selectedImages = await mediaPickerService.pickImages();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _images!.addAll(selectedImages); // Append to existing images
        _selectedMedia!.addAll(selectedImages); // Append to selected media
      });
    }
  }

  Future<void> _pickVideo() async {
    setState(() {
      if (_selectedMediaType != 'videos') {
        _selectedMedia = [];
        _images = [];
        _audios = [];
      }
      _selectedMediaType = 'videos'; // Set media type
    });

    final XFile? videoPicker = await mediaPickerService.pickVideo();
    if (videoPicker != null) {
      setState(() {
        _videos!.add(videoPicker); // Append to existing videos
        _selectedMedia!.add(videoPicker); // Append to selected media
      });
    }
  }

  Future<void> _pickAudios() async {
    setState(() {
      if (_selectedMediaType != 'audios') {
        _selectedMedia = [];
        _images = [];
        _videos = [];
      }
      _selectedMediaType = 'audios'; // Set media type
    });

    final List<XFile>? audioFiles = await mediaPickerService.pickAudios();

    if (audioFiles != null && audioFiles.isNotEmpty) {
      setState(() {
        _audios!.addAll(audioFiles); // Append to existing audios
        _selectedMedia!.addAll(audioFiles); // Append to selected media
      });
    }
  }

  Future<void> _uploadImages(FormData formData, String galleryName) async {
    context
        .read<ImageBloc>()
        .add(ImageUploadEvent(formData: formData, galleryName: galleryName));
  }

  Future<void> _uploadVideos(FormData formData, String galleryName) async {
    context
        .read<VideoBloc>()
        .add(VideoUploadEvent(formData: formData, galleryName: galleryName));
  }

  Future<void> _uploadAudios(FormData formData, String galleryName) async {
    context
        .read<AudioBloc>()
        .add(AudioUploadEvent(formData: formData, galleryName: galleryName));
  }

  Future<void> _uploadMedia<T>(
    List<XFile>? mediaList,
    Future Function(FormData formData, String galleryName) uploadFunction,
  ) async {
    if (mediaList == null || mediaList.isEmpty) {
      ErrorSnackBar.show(context: context, message: 'No media to upload');
      return;
    }

    setState(() {
      _isLoading = true;
      _copyMedia!.addAll(mediaList);
    });

    await Future.forEach(mediaList, (XFile media) async {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(media.path, filename: media.name),
      });

      log.i('Uploading file: ${media.name}, path: ${media.path}');
      log.i('FormData being sent: ${formData.fields}');

      setState(() {
        _uploadingMedia.add(media.name);
      });

      try {
        final galleryName = _nameController.text.trim();
        log.i('Gallery name: $galleryName');

        await uploadFunction(formData, galleryName);

        if (!mounted) return;
        setState(() {
          _uploadDone.add(media.name);
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _uploadFailed.add(media.name); // Track failed uploads
        });
      }
    });
    // Check if all media have been uploaded successfully
    if (_uploadDone.length == _copyMedia!.length) {
      log.i('All media files uploaded successfully. Resetting...');
      // _reset(); // Reset state only after all media is uploaded
    }

    if (!mounted) return;
  }

  _reset() {
    setState(() {
      _isLoading = false;
      _images = [];
      _videos = [];
      _audios = [];
      _uploadingMedia = [];
      _uploadDone = [];
      _copyMedia = [];
      _uploadFailed = [];
      _selectedMediaType = '';
    });
  }

  bool _isUploadingInProgress() {
    return _uploadingMedia.isNotEmpty &&
        _uploadingMedia.length > _uploadDone.length;
  }

  Future<void> _cancelUpload() async {
    // Logic to cancel the upload and clean up the media list
    setState(() {
      _uploadingMedia.clear();
      _uploadDone.clear();
    });
  }

  Widget _buildUploadingMediaList() {
    return SingleChildScrollView(
      child: Column(
        children: _copyMedia!.map((media) {
          final isUploading = _uploadingMedia.contains(media.name);
          final isUploaded = _uploadDone.contains(media.name);

          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: SizedBox(
                width: double.infinity,
                child: ListTile(
                  leading: isUploading
                      ? const Icon(Icons.cloud)
                      : const Icon(Icons.cloud_circle),
                  title: Text(
                    media.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  trailing: isUploaded
                      ? const Icon(Icons.check, color: Colors.green)
                      : _uploadFailed.contains(media.name)
                          ? IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => {}, //_retryUpload(media),
                            )
                          : null,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Unified media preview
  Widget _buildMediaPreview() {
    if (_selectedMediaType == 'images' && _images!.isNotEmpty) {
      return buildImagesGridPreview(
          context: context,
          imageFiles: _images!,
          onRemove: (int index) {
            setState(() {
              _images!.removeAt(index); // Handle image removal
            });
          });
    } else if (_selectedMediaType == 'videos' && _videos!.isNotEmpty) {
      return buildVideosGridPreview(
          context: context,
          videoFiles: _videos!,
          onRemove: (int index) {
            setState(() {
              _videos!.removeAt(index); // Handle image removal
            });
          });
    } else if (_selectedMediaType == 'audios' && _audios!.isNotEmpty) {
      return buildAudiosListPreview(
          context: context,
          audioFiles: _audios!,
          onRemove: (int index) {
            setState(() {
              _audios!.removeAt(index); // Handle image removal
            });
          });
    } else {
      return const Center(child: Text('No media selected.'));
    }
  }

  Widget _buildGalleryOptions() {
    if (fetchedGalleries != null) {
      List<String> names =
          fetchedGalleries!.map((gallery) => gallery.name).toList();
      setState(() {
        galleryNames.clear();
        galleryNames.addAll(names);
      });
    }

    return _galleriesLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isDarkMode
                        ? AppPalette.primaryBlack.withAlpha(50)
                        : AppPalette.lightBackground
                            .withAlpha(20) // Border color based on theme
                    ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: DropdownButton<String>(
                value: _selectedGallery,
                hint: Text(
                  'Select gallery',
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color, // Responsive to theme
                  ),
                ),
                isExpanded: true, // Ensures the dropdown expands to full width
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Theme.of(context)
                      .colorScheme
                      .primary, // Arrow color based on theme
                ),
                dropdownColor: Theme.of(context)
                    .colorScheme
                    .surface, // Matches Material You colors
                items: galleryNames.map((String name) {
                  return DropdownMenuItem<String>(
                    value: name,
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color, // Text color based on theme
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGallery = newValue;
                    _nameController.text = newValue ?? '';
                  });
                },
                underline: const SizedBox.shrink(), // Removes default underline
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<MyUserProvider>(context);
    final galleryProvider = Provider.of<MyGalleryProvider>(context);
    authUser = userProvider.user;
    fetchedGalleries = galleryProvider.galleries;
    _galleriesLoading = galleryProvider.isLoading;

    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
        body: MultiBlocListener(
      listeners: [
        // Listener to show loading while uploading image
        BlocListener<ImageBloc, ImageState>(
          listener: (context, state) {
            if (state is ImageLoading) {
              setState(() {
                // _isLoading = true;
              });
            } else if (state is ImageSuccess) {
              setState(() {
                // _isLoading = false;
                // _matchedImage = state.image.url;
                // _galleryName = state.image.galleryName;
              });
              SuccessSnackBar.show(context: context, message: state.message);
            } else if (state is ImageFailure) {
              setState(() {
                // _isLoading = false;
              });
              ErrorSnackBar.show(context: context, message: state.message);
            }
          },
        ),

        // Listener to show loading while uploading audio
        BlocListener<AudioBloc, AudioState>(
          listener: (context, state) {
            if (state is ImageLoading) {
              setState(() {
                // _isLoading = true;
              });
            } else if (state is AudioSuccess) {
              setState(() {
                // _isLoading = false;
                // _matchedImage = state.image.url;
                // _galleryName = state.image.galleryName;
              });
              SuccessSnackBar.show(context: context, message: state.message);
            } else if (state is AudioFailure) {
              setState(() {
                // _isLoading = false;
              });
              ErrorSnackBar.show(context: context, message: state.message);
            }
          },
        ),

        // Listener to show loading while uploading video
        BlocListener<VideoBloc, VideoState>(
          listener: (context, state) {
            if (state is ImageLoading) {
              setState(() {
                // _isLoading = true;
              });
            } else if (state is VideoSuccess) {
              setState(() {
                // _isLoading = false;
                // _matchedImage = state.image.url;
                // _galleryName = state.image.galleryName;
              });
              SuccessSnackBar.show(context: context, message: state.message);
            } else if (state is VideoFailure) {
              setState(() {
                // _isLoading = false;
              });
              ErrorSnackBar.show(context: context, message: state.message);
            }
          },
        ),

        // Listener to handle fetching of gallery images
        BlocListener<GalleryBloc, GalleryState>(
          listener: (context, state) {
            if (state is GalleriesLoaded) {
              setState(() {
                fetchedGalleries = state.galleries;
              });
            }

            if (state is GalleryFailure) {
              ErrorSnackBar.show(
                  context: context, message: 'Failed to fetch galleries');
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              _buildProfileSection(),
              _buildOverviewSection(),
              _buildActionCards(context),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildProfileSection() {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppPalette.primaryBlack.withAlpha(50)
            : AppPalette.lightBackground.withAlpha(220),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: AppPalette.secondaryBlack.withOpacity(0.1),
            blurRadius: 10.r,
            spreadRadius: 5.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: _selectedMediaType.isNotEmpty && _selectedMediaType != ''
          ? SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: _copyMedia!.isNotEmpty && _isLoading
                  ? _buildUploadingMediaList()
                  : _buildMediaPreview(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      CupertinoIcons.info_circle,
                      size: 30,
                      color: Colors.grey,
                    ),
                    SvgPicture.asset(
                      'assets/svg/camera-square-svgrepo-com.svg',
                      height: 100,
                      color: AppPalette.red,
                    ),
                    const Icon(Icons.more_vert, size: 30, color: Colors.grey),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'Media Upload',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? null : Colors.black87,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'Select a Gallery and upload media',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                        'Galleries', '${fetchedGalleries!.length} Galleries'),
                    _buildStatColumn('Account', authUser!.subscriptionPlan),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? null : Colors.black87,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 170.w,
            // height: 200.h,
            child: _buildGalleryOptions(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(BuildContext context) {
    return Column(
      children: [
        BlocConsumer<ImageBloc, ImageState>(
          listener: (context, state) {
            if (state is ImageSuccess) {
              SuccessSnackBar.show(context: context, message: state.message);
            } else if (state is ImageFailure) {
              ErrorSnackBar.show(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            return _buildActionCard(
              CupertinoIcons.camera,
              _pickImages,
              'Photographs, Pictures, Stills',
              'Upload Photos from your Gallery',
              _selectedMediaType == 'images' && _images!.isNotEmpty
                  ? GestureDetector(
                      onTap: () async {
                        if (_images!.isNotEmpty) {
                          await _uploadMedia(_images, _uploadImages);
                        }
                      },
                      child: const Icon(CupertinoIcons.cloud_upload_fill))
                  : const SizedBox.shrink(),
              state,
            );
          },
        ),
        BlocConsumer<VideoBloc, VideoState>(
          listener: (context, state) {
            if (state is VideoSuccess) {
              SuccessSnackBar.show(context: context, message: state.message);
            } else if (state is VideoFailure) {
              ErrorSnackBar.show(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            return _buildActionCard(
              CupertinoIcons.video_camera,
              _pickVideo,
              'Clips, Recordings, Visuals',
              'Upload Videos from your Gallery',
              _selectedMediaType == 'videos' && _videos!.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        if (_videos!.isNotEmpty) {
                          _uploadMedia(_videos, _uploadVideos);
                        }
                      },
                      child: const Icon(CupertinoIcons.cloud_upload_fill))
                  : const SizedBox.shrink(),
              state,
            );
          },
        ),
        BlocConsumer<AudioBloc, AudioState>(
          listener: (context, state) {
            if (state is AudioSuccess) {
              SuccessSnackBar.show(context: context, message: state.message);
            } else if (state is AudioFailure) {
              ErrorSnackBar.show(context: context, message: state.message);
            }
          },
          builder: (context, state) {
            return _buildActionCard(
              CupertinoIcons.music_albums,
              _pickAudios,
              'Mp3s, Music, Sound Bites',
              'Upload Audios from your Gallery',
              _selectedMediaType == 'audios' && _audios!.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        if (_audios!.isNotEmpty) {
                          _uploadMedia(_audios, _uploadAudios);
                        }
                      },
                      child: const Icon(CupertinoIcons.cloud_upload_fill))
                  : const SizedBox.shrink(),
              state,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    IconData icon,
    VoidCallback onPress,
    String title,
    String subtitle,
    Widget uploadIcon,
    dynamic state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
      child: GestureDetector(
        onTap: onPress,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: EdgeInsets.all(
                  constraints.maxWidth * 0.05), // Adaptive padding
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppPalette.primaryBlack.withAlpha(50)
                    : AppPalette.lightBackground.withAlpha(220),
                borderRadius: BorderRadius.circular(15.r), // Responsive radius
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.secondaryBlack.withOpacity(0.1),
                    blurRadius: 10.r,
                    spreadRadius: 5.r,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onPress,
                    child: Container(
                      padding: EdgeInsets.all(
                          constraints.maxWidth * 0.03), // Adaptive padding
                      decoration: BoxDecoration(
                        color: AppPalette.red,
                        borderRadius: BorderRadius.circular(
                            10.r), // Responsive border radius
                      ),
                      child: Icon(icon,
                          size: 30.sp, color: AppPalette.primaryWhite),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16.sp, // Adaptive font size
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? null : Colors.black87,
                          ),
                          maxLines: 1, // Ensure text doesn't overflow
                          overflow:
                              TextOverflow.ellipsis, // Ellipsis for long text
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14.sp, // Adaptive font size
                            color: Colors.grey,
                          ),
                          maxLines: 2, // Limit subtitle to two lines
                          overflow: TextOverflow
                              .ellipsis, // Ellipsis for long subtitle
                        ),
                        SizedBox(height: 10.h),
                        if (state is ImageLoading ||
                            state is AudioLoading ||
                            state is VideoLoading)
                          const LinearProgressIndicator(),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  uploadIcon,
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
