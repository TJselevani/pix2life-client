import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';
import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';
import 'package:pix2life/src/shared/widgets/text-animation/text_animation_widgets.dart';

class Save extends StatefulWidget {
  const Save({super.key});

  @override
  State<Save> createState() => _SaveState();
}

class _SaveState extends State<Save> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final log = createLogger(Save);
  List<XFile>? _images = [];
  List<XFile>? _videos = [];
  List<XFile>? _audios = [];
  List<XFile>? _copyMedia = [];
  List<String> _uploadingMedia = [];
  List<String> _uploadDone = [];
  List<Gallery> fetchedGalleries = [];
  List<String> galleryNames = [];
  late String _selectedMediaType = '';
  String? _selectedOption;
  bool _isLoading = false;

  Future<void> _pickImages() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    setState(() {
      if (_selectedMediaType != 'images') {
        _copyMedia = [];
      }
      _videos = [];
      _audios = [];
      // _selectedMediaType = 'images';
    });
    final List<XFile>? selectedImages = (await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    ))
        ?.files
        .map((file) => XFile(file.path!))
        .toList();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        _images!.addAll(selectedImages);
        _copyMedia!.addAll(selectedImages);
      });
    }
  }

  Future<void> _pickVideo() async {
    setState(() {
      if (_selectedMediaType != 'videos') {
        _copyMedia = [];
      }
      _images = [];
      _audios = [];
      // _selectedMediaType = 'videos';
    });
    final XFile? videoPicker =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (videoPicker != null) {
      setState(() {
        _videos!.add(videoPicker);
        _copyMedia!.add(videoPicker);
      });
    }
  }

  Future<void> _pickAudios() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    setState(() {
      if (_selectedMediaType != 'audios') {
        _copyMedia = [];
      }
      _images = [];
      _videos = [];
      // _selectedMediaType = 'audios';
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );
      if (result != null) {
        List<XFile> audioFiles =
            result.paths.map((path) => XFile(path!)).toList();
        setState(() {
          _audios!.addAll(audioFiles);
          _copyMedia!.addAll(audioFiles);
        });
      }
    } catch (e) {
      debugPrint('Error picking audio files: $e');
    }
  }

  Future<void> _uploadMedia<T>(
    List<XFile>? mediaList,
    Future Function(FormData formData, String galleryName) uploadFunction,
  ) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    if (mediaList == null || mediaList.isEmpty) {
      log.w('No media to upload');
      return;
    }

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

        final response = await uploadFunction(formData, galleryName);

        if (!mounted) return;

        setState(() {
          SuccessSnackBar.show(context: context, message: response.message);
          log.i('Successfully uploaded ${media.runtimeType}: ${media.name}');
          _uploadDone.add(media.name);
        });
      } catch (e) {
        if (!mounted) return;

        setState(() {
          ErrorSnackBar.show(context: context, message: '$e');
          log.e('Upload failed for ${media.runtimeType} ${media.name}: $e');
        });
      }
    });

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _images = [];
      _videos = [];
      _audios = [];
      _copyMedia = [];
      _uploadingMedia = [];
      _uploadDone = [];
      _selectedMediaType = '';
    });
  }

  @override
  void initState() {
    super.initState();
    final currentState = context.read<GalleryBloc>().state;

    // Only trigger the fetch event if the data has not been loaded yet
    if (currentState is! GalleriesLoaded) {
      context.read<GalleryBloc>().add(GalleryFetchGalleriesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    // fetchedGalleries =
    //     (BlocProvider.of<GalleryBloc>(context).state as GalleriesLoaded)
    //         .galleries;
    final currentState = context.read<GalleryBloc>().state;
    if (currentState is GalleryInitial) {
      context.read<GalleryBloc>().add(GalleryFetchGalleriesEvent());

      final nextState = context.read<GalleryBloc>().state;
      if (nextState is GalleriesLoaded) {
        fetchedGalleries =
            (BlocProvider.of<GalleryBloc>(context).state as GalleriesLoaded)
                .galleries;
      }
    }

    return Scaffold(
      backgroundColor: AppPalette.lightBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              if (_selectedMediaType.isNotEmpty)
                _buildMediaPreview()
              else
                _buildProfileSection(),
              _buildOverviewSection(),
              _buildActionCards(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppPalette.secondaryBlack.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.menu, size: 30, color: Colors.grey),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://random.imagecdn.app/150/150', // Replace with actual profile image URL
                ),
              ),
              Icon(Icons.more_vert, size: 30, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'tjselevani',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'UX/UI Designer',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('Income', '\$8900'),
              _buildStatColumn('Expenses', '\$5500'),
              _buildStatColumn('Loan', '\$890'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String amount) {
    return Column(
      children: [
        Text(
          amount,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(
            children: [
              Text(
                'Select Gallery',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.perm_media, color: Colors.grey),
            ],
          ),
          Text('12 May 2024')
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Photos uploaded successfully!')),
              );
            } else if (state is ImageFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return _buildActionCard(
              CupertinoIcons.camera,
              _pickImages,
              'Photographs, Pictures, Stills',
              'Upload Photos from your Gallery',
              '\$150',
              () {
                context.read<ImageBloc>().add(ImageUploadEvent(
                    formData: FormData.fromMap({}), galleryName: ''));
              },
              state,
            );
          },
        ),
        BlocConsumer<VideoBloc, VideoState>(
          listener: (context, state) {
            if (state is VideoSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Videos uploaded successfully!')),
              );
            } else if (state is VideoFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return _buildActionCard(
              CupertinoIcons.video_camera,
              _pickVideo,
              'Clips, Recordings, Visuals',
              'Upload Videos from your Gallery',
              '\$250',
              () {
                context.read<VideoBloc>().add(VideoUploadEvent(
                    formData: FormData.fromMap({}), galleryName: ''));
              },
              state,
            );
          },
        ),
        BlocConsumer<AudioBloc, AudioState>(
          listener: (context, state) {
            if (state is AudioSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Audios uploaded successfully!')),
              );
            } else if (state is AudioFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return _buildActionCard(
              CupertinoIcons.music_albums,
              _pickAudios,
              'Mp3s, Music, Sound Bites',
              'Upload Audios from your Gallery',
              '\$400',
              () {
                context.read<AudioBloc>().add(AudioUploadEvent(
                    formData: FormData.fromMap({}), galleryName: ''));
              },
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
    String amount,
    VoidCallback onSubmit,
    dynamic state,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
      child: GestureDetector(
        onTap: null,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppPalette.secondaryBlack.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onPress,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppPalette.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 30, color: AppPalette.primaryWhite),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    if (state is ImageLoading ||
                        state is AudioLoading ||
                        state is VideoLoading)
                      const LinearProgressIndicator(),
                  ],
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (_selectedMediaType == 'images' && _images!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(-3, 3),
            ),
          ],
        ),
        width: ScreenUtil().setWidth(250),
        height: ScreenUtil().setHeight(250),
        child: _isLoading
            ? _buildUploadedMediaList() //Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ImageSelectionContainer(
                        imagePath: _images![index].path,
                        onRemove: () {
                          setState(() {
                            _images!.removeAt(index);
                          });
                        },
                      ),
                    ],
                  );
                },
                itemCount: _images!.length,
              ),
      );
    } else if (_selectedMediaType == 'videos' && _videos!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(-3, 3),
            ),
          ],
        ),
        width: ScreenUtil().setWidth(250),
        height: ScreenUtil().setHeight(250),
        child: _buildUploadedMediaList(),
        // child: ListView.builder(
        //   itemCount: _videos!.length,
        //   itemBuilder: (context, index) {
        //     return ListTile(
        //       title: Text(_videos![index].name),
        //     );
        //   },
        // ),
      );
    } else if (_selectedMediaType == 'audios' && _audios!.isNotEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(-3, 3),
            ),
          ],
        ),
        width: ScreenUtil().setWidth(250),
        height: ScreenUtil().setHeight(250),
        child: _buildUploadedMediaList(),
        // child: ListView.builder(
        //   itemCount: _audios!.length,
        //   itemBuilder: (context, index) {
        //     return ListTile(
        //       title: Text(_audios![index].name),
        //     );
        //   },
        // ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: _copyMedia!.isNotEmpty
                ? Colors.black.withOpacity(0.2)
                : AppPalette.red.withOpacity(0.7),
            spreadRadius: 4,
            blurRadius: 5,
            offset: const Offset(-3, 3),
          ),
        ],
      ),
      width: ScreenUtil().setWidth(250),
      height: ScreenUtil().setHeight(250),
      child: _copyMedia!.isNotEmpty
          ? ListView.builder(
              itemCount: _copyMedia!.length,
              itemBuilder: (context, index) {
                XFile media = _copyMedia![index];
                return SizedBox(
                  width: ScreenUtil().setWidth(230),
                  child: ListTile(
                    leading: _uploadingMedia.contains(media.name)
                        ? const Icon(Icons.cloud)
                        : const Icon(Icons.cloud_circle),
                    title: Text(
                      media.name,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(13),
                      ),
                    ),
                    trailing: _uploadDone.contains(media.name)
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                  ),
                );
              },
            )
          : const Center(child: FadeInText()),
    );
  }

  Widget _buildUploadedMediaList() {
    return Column(
      children: _copyMedia!.map((media) {
        return Center(
          child: SizedBox(
            width: ScreenUtil().setWidth(230),
            child: ListTile(
              leading: _uploadingMedia.contains(media.name)
                  ? const Icon(Icons.cloud)
                  : const Icon(Icons.cloud_circle),
              title: Text(media.name),
              trailing: _uploadDone.contains(media.name)
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGalleryOptions() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(1)),
      child: Column(
        children: [
          Text(
            'Choose a Gallery',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: ScreenUtil().setSp(16),
              fontWeight: FontWeight.w500,
              color: AppPalette.primaryBlack,
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          DropdownButton<String>(
            value: _selectedOption,
            hint: const Text('Select gallery'),
            items: galleryNames.map((String name) {
              return DropdownMenuItem<String>(
                value: name,
                child: Text(name),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedOption = newValue;
                // Pass the selected gallery name to your function here
                _nameController.text = newValue ?? '';
              });
            },
          ),
        ],
      ),
    );
  }
}

class ImageSelectionContainer extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onRemove;

  const ImageSelectionContainer({
    super.key,
    required this.imagePath,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppPalette.primaryGrey,
          width: 1.0,
        ),
      ),
      child: Stack(
        children: [
          Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
