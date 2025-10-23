import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:camera/camera.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/pick-media/media_picker_service.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_round_button.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';
import 'package:pix2life/src/features/image/presentation/widgets/gallery_popup_dialog.dart';
import 'package:pix2life/src/shared/widgets/text-animation/disappearing_text.dart';

class ImageMatchScreen extends StatefulWidget {
  const ImageMatchScreen({super.key});

  @override
  State<ImageMatchScreen> createState() => _UploadImageMatchPageState();
}

class _UploadImageMatchPageState extends State<ImageMatchScreen> {
  final MediaPickerService _picker = MediaPickerService();
  final log = createLogger(ImageMatchScreen);
  List<CameraDescription>? cameras;
  bool _isLoading = false;
  bool _isSet = false;
  bool _isReady = false;
  File? _imageFile;
  String? _matchedImage;
  String? _galleryName;
  // ignore: unused_field
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _initializeCameras();
  }

  Future<void> _initializeCameras() async {
    try {
      cameras = await availableCameras();
      setState(() {});
    } catch (e) {
      log.e('Failed to initialize cameras: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickSingleImageCmp();

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isReady = true;
      });
    } else {
      setState(() {
        _isReady = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImageFromCamera();

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isReady = true;
      });
    } else {
      setState(() {
        _isReady = false;
      });
    }
  }

  Future<void> _uploadImage(FormData formData) async {
    BlocProvider.of<ImageBloc>(context)
        .add(ImageMatchEvent(formData: formData));
  }

  Future<void> _uploadMatchImage(
      File? media, Function(FormData) uploadFunction) async {
    if (media == null) {
      ErrorSnackBar.show(context: context, message: 'No media to upload');
      return;
    }

    setState(() {
      _matchedImage = null;
      _isLoading = true;
      _isSet = false;
    });

    File image = media;
    final filename = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(image.path, filename: filename),
    });
    log.i('Uploading file: $filename, path: ${image.path}');

    try {
      await uploadFunction(formData); // Trigger the actual upload function
      setState(() {
        _isSet = true;
      });
    } catch (e) {
      log.e('Image Matching Failed $filename: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showGalleryImages(
      BuildContext context, String galleryName) async {
    // Dispatch the event to fetch gallery images
    BlocProvider.of<GalleryBloc>(context)
        .add(GalleryFetchImagesEvent(galleryName: galleryName));

    // Listen to the Bloc state for images
    final galleryState = BlocProvider.of<GalleryBloc>(context).state;

    if (galleryState is GalleryImagesLoaded) {
      // Images have been successfully loaded
      GalleryDialog.showGalleryImagesDialog(
        context: context,
        images: galleryState.images, // Pass the loaded images
        galleryName: galleryName, // Pass the gallery name
      );
    } else if (galleryState is GalleryFailure) {
      // Handle the failure case
      ErrorSnackBar.show(
        context: context,
        message: 'Failed to fetch gallery images',
      );
    } else if (galleryState is GalleryLoading) {
      SuccessSnackBar.show(context: context, message: 'Fetching Gallery ...');
    }
  }

  Widget _buildFileImageContainer({
    required String label,
    File? imageFile,
  }) {
    return Container(
      width: ScreenUtil().setWidth(150),
      height: ScreenUtil().setHeight(150),
      decoration: BoxDecoration(
        color: AppPalette.red,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
      ),
      child: imageFile != null
          ? Image.file(
              imageFile,
              fit: BoxFit.cover,
            )
          : Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: ScreenUtil().setSp(12),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  Widget _buildNetworkImageContainer({
    required String label,
    String? imageUrl,
    bool isLoading = false,
  }) {
    return BlocConsumer<ImageBloc, ImageState>(
      listener: (context, state) {
        // Listening for ImageLoaded state to set imageUrl and galleryName
        if (state is ImageLoaded) {
          setState(() {
            _imageUrl = state.image.url;
            _galleryName = state.image.galleryName;
          });
        }
      },
      builder: (context, state) {
        if (isLoading) {
          // Show loading widget when uploading
          return Center(
            child: LoadingAnimationWidget.beat(
              color: AppPalette.red,
              size: ScreenUtil().setWidth(50),
            ),
          );
        } else if (state is ImageLoaded &&
            imageUrl != null &&
            imageUrl.isNotEmpty) {
          // Show the network image when loaded and available
          return GestureDetector(
            onTap: () {
              // On tap, show gallery images if galleryName is set
              if (_galleryName != null) {
                _showGalleryImages(context, _galleryName!);
              }
            },
            child: Container(
              width: ScreenUtil().setWidth(150),
              height: ScreenUtil().setHeight(150),
              decoration: BoxDecoration(
                color: AppPalette.red,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
              ),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
          );
        } else if (state is ImageLoading) {
          // Show a loading animation when the image is being loaded
          return Center(
            child: LoadingAnimationWidget.beat(
              color: AppPalette.red,
              size: ScreenUtil().setWidth(50),
            ),
          );
        } else {
          // Default view when no image is available or loading
          return Container(
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setHeight(150),
            decoration: BoxDecoration(
              color: AppPalette.red,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: ScreenUtil().setSp(12),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: ScreenUtil().setWidth(40),
            color: AppPalette.red,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          // Listener to show loading while uploading image
          BlocListener<ImageBloc, ImageState>(
            listener: (context, state) {
              if (state is ImageLoading) {
                setState(() {
                  _isLoading = true;
                });
              } else if (state is ImageLoaded) {
                setState(() {
                  _isLoading = false;
                  _matchedImage = state.image.url;
                  _galleryName = state.image.galleryName;
                });
                SuccessSnackBar.show(context: context, message: 'Match Found');
              } else if (state is ImageFailure) {
                setState(() {
                  _isLoading = false;
                });
                ErrorSnackBar.show(
                    context: context, message: 'Image Match failed');
              }
            },
          ),
          // Listener to handle fetching of gallery images
          BlocListener<GalleryBloc, GalleryState>(
            listener: (context, state) {
              if (state is GalleryImagesLoaded) {
                // SuccessSnackBar.show(
                //     context: context,
                //     message:
                //         'Successfully fetched ${state.images.length} gallery images');
              }

              if (state is GalleryFailure) {
                ErrorSnackBar.show(
                    context: context,
                    message: 'Failed to fetch gallery images');
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: ScreenUtil().setHeight(40)),
              Center(
                child: Text(
                  'Image Matching',
                  style: TextStyle(
                    color: AppPalette.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),

              Hero(
                tag: 'image-hero', // Hero tag for matched image animation
                child: Container(
                  margin: EdgeInsets.only(top: 30.h, left: 20.w, right: 20.w),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(18)),
                  width: double.infinity,
                  height:
                      ScreenUtil().setHeight(300), // Adjust height as needed
                  child: !_isLoading && _matchedImage == null
                      ? _buildFileImageContainer(
                          label: 'Your Image',
                          imageFile: _imageFile,
                        )
                      : BlocBuilder<ImageBloc, ImageState>(
                          builder: (context, state) {
                            return _buildNetworkImageContainer(
                              label: 'Matched Image',
                              imageUrl: _matchedImage,
                            );
                          },
                        ),
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(20)),

              SizedBox(height: ScreenUtil().setHeight(20)),
              if (_matchedImage != null && _matchedImage!.isNotEmpty)
                DisappearingText(
                  text: 'Tap on the Matched Image',
                  isVisible: _isSet,
                ),

              // Match button that triggers the hero animation
              if (_isReady)
                Padding(
                  padding: EdgeInsets.all(20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hero widget for image container animation
                      if (_isLoading)
                        Hero(
                          tag: 'file-image-hero', // Tag for animation
                          child: _imageFile != null
                              ? SizedBox(
                                  width: ScreenUtil().setWidth(100),
                                  height: ScreenUtil().setHeight(100),
                                  child: _buildFileImageContainer(
                                    label: 'Your Image',
                                    imageFile: _imageFile,
                                  ),
                                )
                              : Container(),
                        ),
                      SizedBox(width: ScreenUtil().setWidth(20)),

                      // Match Image Button
                      _isLoading
                          // ? LoadingAnimationWidget.bouncingBall(
                          //     color: AppPalette.red,
                          //     size: ScreenUtil().setWidth(30),
                          //   )
                          ? Container()
                          : Flexible(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18.w, vertical: 10.h),
                                child: RoundedButton(
                                  name: "Match Image",
                                  onPressed: () {
                                    if (_imageFile != null) {
                                      _uploadMatchImage(
                                          _imageFile, _uploadImage);
                                    }
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                ),

              // const Spacer(), // Pushes the following content to the bottom

              // Row for action buttons (Take Photo and Search Gallery)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(Icons.camera, 'Take Photo', _takePhoto),
                  _buildActionButton(Icons.browse_gallery, 'Search Gallery',
                      _pickImageFromGallery),
                ],
              ),

              SizedBox(height: ScreenUtil().setHeight(40)),

              // Description text at the bottom
              SizedBox(
                width: ScreenUtil().setWidth(319),
                child: RichText(
                  text: TextSpan(
                    text:
                        'Using your camera, take a photo to match the image you have in one of your saved PIX2LIFE galleries',
                    style: TextStyle(
                      color: AppPalette.primaryGrey,
                      fontFamily: 'Poppins',
                      fontSize: ScreenUtil().setSp(14),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(40)),
            ],
          ),
        ),
      ),
    );
  }
}
