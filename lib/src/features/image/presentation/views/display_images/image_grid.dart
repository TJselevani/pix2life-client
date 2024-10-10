import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';
import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';
import 'package:pix2life/src/features/image/presentation/widgets/image_popup_dialog.dart';

class ImageGridPage extends StatefulWidget {
  const ImageGridPage({super.key});

  @override
  State<ImageGridPage> createState() => _ImageGridPageState();
}

class _ImageGridPageState extends State<ImageGridPage>
    with SingleTickerProviderStateMixin {
  String _selectedImageName = 'Image Gallery';
  // ignore: unused_field
  String? _selectedImageUrl;
  late AnimationController _controller;
  bool isTapped = false;
  double targetValue = 0.8;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          setState(() => isTapped = true);
        } else if (status == AnimationStatus.dismissed) {
          setState(() => isTapped = false);
        }
      });

    final currentState = context.read<ImageBloc>().state;
    if (currentState is! ImagesLoaded) {
      context.read<ImageBloc>().add(ImagesFetchEvent());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showImageDialog(Photo image) {
    showDialog(
      context: context,
      builder: (context) {
        return ImageDialog(
          image: image,
          targetValue: targetValue,
          controller: _controller,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppPalette.primaryWhite,
      appBar: AppBar(
        title: Text(
          _selectedImageName,
          style: TextStyle(fontSize: 20.sp),
        ),
        centerTitle: true,
        // backgroundColor: AppPalette.primaryWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.refresh, size: 24.sp),
          onPressed: () {
            context.read<ImageBloc>().add(ImagesFetchEvent());
          },
        ),
      ),
      body: BlocConsumer<ImageBloc, ImageState>(
        listener: (context, state) {
          if (state is ImageFailure) {
            ErrorSnackBar.show(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is ImageFailure) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is ImageLoading) {
            return Center(
              child: LoadingAnimationWidget.waveDots(
                color: AppPalette.red,
                size: 50.sp,
              ),
            );
          } else if (state is ImagesLoaded) {
            final images = state.images;

            if (images.isEmpty) {
              return const Center(child: Text('No images found'));
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Stack(
                children: [
                  GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Three images per row
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.0, // Square images
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImageName = image.filename;
                            _selectedImageUrl = image.url;
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            currentIndex = index;
                            targetValue = 1;
                          });
                          _controller.forward();
                          _showImageDialog(image);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.w),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(2.w, 2.h),
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: image.url,
                            fadeInCurve: Curves.easeIn,
                            placeholder: (context, url) => Center(
                              child: LoadingAnimationWidget.twoRotatingArc(
                                color: AppPalette.red,
                                size: 30.sp,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error, size: 24.sp),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
