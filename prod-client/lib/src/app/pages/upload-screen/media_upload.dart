import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/permissions.dart';
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

  final List<XFile> _images = [];
  final List<XFile> _videos = [];
  final List<XFile> _audios = [];
  final List<XFile> _copyMedia = [];

  final List<String> _uploadingMedia = [];
  final List<String> _uploadDone = [];
  final List<String> _uploadFailed = [];

  List<XFile>? _selectedMedia = [];
  List<Gallery>? fetchedGalleries;

  bool _galleriesLoading = true;
  User? authUser;
  List<String> galleryNames = [];

  String _selectedMediaType = '';
  bool _isLoading = false;
  String? _selectedGallery;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider =
          Provider.of<MyThemeProvider>(context, listen: false);
      setState(() {
        isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
            (themeProvider.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
      });
    });

    final galleryState = BlocProvider.of<GalleryBloc>(context).state;
    if (galleryState is! GalleriesLoaded) {
      BlocProvider.of<GalleryBloc>(context).add(GalleryFetchGalleriesEvent());
    }
    requestPermissions();
  }

  Future<void> _pickMedia(String mediaType) async {
    setState(() {
      if (_selectedMediaType != mediaType) {
        _selectedMedia = [];
        _images.clear();
        _videos.clear();
        _audios.clear();
      }
      _selectedMediaType = mediaType;
    });

    List<XFile>? selectedFiles;
    switch (mediaType) {
      case 'images':
        selectedFiles = await mediaPickerService.pickMultipleImagesCmp();
        break;
      case 'videos':
        selectedFiles = await mediaPickerService.pickMultipleVideos();
        break;
      case 'audios':
        selectedFiles = await mediaPickerService.pickMultipleAudios();
        break;
    }

    if (selectedFiles != null && selectedFiles.isNotEmpty) {
      setState(() {
        if (mediaType == 'images') {
          _images.addAll(selectedFiles!.map((file) => file));
        } else if (mediaType == 'videos') {
          _videos.addAll(selectedFiles!.map((file) => file));
        } else if (mediaType == 'audios') {
          _audios.addAll(selectedFiles!.map((file) => file));
        }
        _selectedMedia!.addAll(selectedFiles!.map((file) => file));
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

    final galleryName = _nameController.text.trim();
    if (galleryName.isEmpty || galleryName == 'galleryName') {
      ErrorSnackBar.show(context: context, message: 'No Gallery Selected');
      return;
    }

    setState(() {
      _isLoading = true;
      _copyMedia.addAll(mediaList);
    });

    for (XFile media in mediaList) {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(media.path, filename: media.name),
      });

      setState(() {
        _uploadingMedia.add(media.name);
      });

      try {
        await uploadFunction(formData, galleryName);
        if (!mounted) return;

        setState(() {
          _uploadDone.add(media.name);
          _uploadingMedia.remove(media.name);
        });
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _uploadFailed.add(media.name);
          _uploadingMedia.remove(media.name);
        });
      }
    }

    if (_uploadDone.length == _copyMedia.length) {
      log.i('All media files uploaded successfully. Resetting...');
      _reset();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _reset() {
    setState(() {
      _isLoading = false;
      _images.clear();
      _videos.clear();
      _audios.clear();

      // Clear upload states
      _uploadingMedia.clear();
      _uploadDone.clear();
      _copyMedia.clear();
      _uploadFailed.clear();

      // Reset selected media type
      _selectedMediaType = '';
    });
  }

  bool get isUploadingInProgress =>
      _uploadingMedia.isNotEmpty &&
      (_uploadingMedia.length > _uploadDone.length);

  Widget _buildUploadingMediaList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var media in _copyMedia) _buildUploadingListItem(media),
        ],
      ),
    );
  }

  Widget _buildUploadingListItem(XFile media) {
    final isUploading = _uploadingMedia.contains(media.name);
    final isUploaded = _uploadDone.contains(media.name);
    final isFailed = _uploadFailed.contains(media.name);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: SizedBox(
          width: double.infinity,
          child: ListTile(
            leading: isUploading
                ? const Icon(Icons.cloud_upload)
                : isUploaded
                    ? const Icon(Icons.cloud_done, color: Colors.green)
                    : const Icon(Icons.cloud_off, color: Colors.red),
            title: Text(
              media.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 16.sp),
            ),
            trailing: isUploaded
                ? const Icon(Icons.check, color: Colors.green)
                : isFailed
                    ? IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => {}, // Handle retry logic here
                      )
                    : const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    switch (_selectedMediaType) {
      case 'images':
        return buildImagesGridPreview(
            context: context, imageFiles: _images, onRemove: removeImage);
      case 'videos':
        return buildVideosGridPreview(
            context: context, videoFiles: _videos, onRemove: removeVideo);
      case 'audios':
        return buildAudiosListPreview(
            context: context, audioFiles: _audios, onRemove: removeAudio);
      default:
        return const Center(child: Text('No media selected.'));
    }
  }

  void removeImage(int index) => setState(() => _images.removeAt(index));
  void removeVideo(int index) => setState(() => _videos.removeAt(index));
  void removeAudio(int index) => setState(() => _audios.removeAt(index));

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
            child: SizedBox(
              height: 60, // Set height for the horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: galleryNames.length,
                itemBuilder: (context, index) {
                  final name = galleryNames[index];
                  final isSelected = _selectedGallery == name;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGallery = name; // Update selected gallery
                        _nameController.text = name; // Update text controller
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppPalette.red
                            : Colors.transparent, // Highlight selected
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDarkMode
                              ? AppPalette.primaryBlack.withAlpha(50)
                              : AppPalette.lightBackground.withAlpha(20),
                        ), // Border color based on theme
                      ),
                      child: Center(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
        body: SingleChildScrollView(
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
              child: _uploadingMedia.isNotEmpty ||
                      // _isUploadingInProgress() ||
                      _isLoading //_copyMedia!.isNotEmpty &&  _copyMedia!.length != _uploadDone.length
                  ? _buildUploadingMediaList()
                  : _buildMediaPreview(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100.w,
                      height: 100.h,
                      child: Image.asset(AppImage.playStoreImg),
                    ),
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 60.w,
              child: _buildGalleryOptions(),
            ),
          ],
        ),
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
              () {
                _pickMedia('images');
              },
              'Photographs, Pictures, Stills',
              'Upload Photos from your Gallery',
              _selectedMediaType == 'images' && _images.isNotEmpty
                  ? GestureDetector(
                      onTap: () async {
                        if (_images.isNotEmpty) {
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
              () {
                _pickMedia('videos');
              },
              'Clips, Recordings, Visuals',
              'Upload Videos from your Gallery',
              _selectedMediaType == 'videos' && _videos.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        if (_videos.isNotEmpty) {
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
              () {
                _pickMedia('audios');
              },
              'Mp3s, Music, Sound Bites',
              'Upload Audios from your Gallery',
              _selectedMediaType == 'audios' && _audios.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        if (_audios.isNotEmpty) {
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
