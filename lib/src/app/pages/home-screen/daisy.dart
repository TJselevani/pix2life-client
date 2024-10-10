import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_provider.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/gallery/data/data_source/gallery_provider.dart';
import 'package:pix2life/src/features/gallery/presentation/views/create_gallery_form.dart';
import 'package:pix2life/src/features/gallery/presentation/views/exemplar_galleries.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/shared/widgets/logo/app_logo.dart';
import 'package:pix2life/src/shared/widgets/text-animation/fade_in_text.dart';
import 'package:pix2life/src/shared/widgets/user-avatar/user_avatar.dart';
import 'package:provider/provider.dart';

class Daisy extends StatefulWidget {
  const Daisy({super.key});

  @override
  State<Daisy> createState() => _DaisyState();
}

class _DaisyState extends State<Daisy> {
  final log = createLogger(Daisy);
  final List<PageController> _pageControllers = [];
  List<Gallery>? fetchedGalleries;
  List<String>? galleryNames;
  User? authUser;

  final List<String> _imageUrls = [
    'https://via.placeholder.com/300.png/09f/fff',
    'https://via.placeholder.com/300.png/ff0/000',
    'https://via.placeholder.com/300.png/0ff/000',
  ];

  final List<Map<String, String>> exemplarGalleries = [
    {
      'name': 'Nature Gallery',
      'description': 'A collection of nature photos',
      'image': 'assets/images/A.jpg',
    },
    {
      'name': 'Cityscape',
      'description': 'Urban and city landscape images',
      'image': 'assets/images/R.jpeg',
    },
  ];

  int _currentImageIndex = 0;

  Timer? _gallerySlideTimer;
  Timer? _imageShuffleTimer;
  int _currentPage = 0;
  String? gallery;

  void _startImageShuffle() {
    _imageShuffleTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _imageUrls.length;
      });
    });
  }

  // Auto-slide functionality for gallery cards
  void _startGallerySlide() {
    _gallerySlideTimer =
        Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < exemplarGalleries.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      // Animate each PageController only if it has a listener attached
      for (var controller in _pageControllers) {
        if (controller.hasClients) {
          // Check if the controller is attached
          controller.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize the auto-slider and fetch galleries after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startGallerySlide();
      _startImageShuffle();
      _initializePageControllers();
    });
  }

  // Initializes PageControllers for each gallery
  void _initializePageControllers() {
    for (var i = 0; i < exemplarGalleries.length; i++) {
      _pageControllers.add(PageController());
    }
  }

  // // Fetch galleries and trigger events only if they haven't been loaded
  // void _fetchGalleries() {
  //   final currentState = context.read<GalleryBloc>().state;

  //   if (currentState is! GalleryImagesLoaded) {
  //     context.read<GalleryBloc>().add(GalleryFetchGalleriesEvent());
  //   }

  //   if (gallery != null && currentState is! GalleryImagesLoaded) {
  //     context
  //         .read<GalleryBloc>()
  //         .add(GalleryFetchImagesEvent(galleryName: gallery!));
  //   }
  // }

  @override
  void dispose() {
    // Dispose all PageControllers
    for (var controller in _pageControllers) {
      controller.dispose();
    }
    _gallerySlideTimer?.cancel();
    _imageShuffleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<MyUserProvider>(context);
    final galleryProvider = Provider.of<MyGalleryProvider>(context);
    authUser = userProvider.user;
    fetchedGalleries = galleryProvider.galleries;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5.h,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildProfileHeader(),
              SizedBox(height: 10.h),
              _buildMediaContainers(),
              SizedBox(height: 10.h),
              _buildGalleryListView(),
              SizedBox(height: 10.h),
              _buildCreateGalleryView(),
              SizedBox(height: 20.h),
              showcaseGalleries(),
            ],
          ),
        ),
      ),
    );
  }

  // Profile header section
  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  _buildText('Hello', 20),
                  SizedBox(width: 5.w),
                  if (authUser != null && authUser!.username.isNotEmpty)
                    FadeInText(text: authUser!.username.split('/')[0])
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: ScreenUtil().setWidth(200),
                height: ScreenUtil().setHeight(50),
                child: const Pix2lifeLogo(),
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: _buildText('Have a nice day!', 18),
            ),
          ],
        ),
        SizedBox(
          width: 100.w,
          height: 100.h,
          child: const UserAvatar(radius: 60),
        ),
      ],
    );
  }

  // Media container section (Images, Videos, Audios)
  Widget _buildMediaContainers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildMediaContainer('Galleries'),
      ],
    );
  }

  // Gallery list view with auto-slide functionality for the first gallery
  Widget _buildGalleryListView() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: SizedBox(
        height: 240.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount:
              fetchedGalleries!.length + 1, // Add one for the exemplar gallery
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _buildGalleryCard(
                taskTitle: exemplarGalleries[0]['name']!,
                dueInfo: exemplarGalleries[0]['description']!,
                color: AppPalette.red.withOpacity(.6),
                imagePaths: exemplarGalleries.map((e) => e['image']!).toList(),
                isAsset: true,
              );
            } else {
              final gallery = fetchedGalleries![index - 1];
              return _buildGalleryCard(
                taskTitle: gallery.name,
                dueInfo: gallery.description,
                background: gallery.iconUrl,
                color: AppPalette.red.withOpacity(.6),
              );
            }
          },
        ),
      ),
    );
  }

  // Reusable method for text styling
  Widget _buildText(String text, double fontSize,
      {FontWeight fontWeight = FontWeight.normal,
      Color color = AppPalette.fontBlack}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
      ),
    );
  }

  // Reusable method for creating media containers
  Widget _buildMediaContainer(String label) {
    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppPalette.red,
          fontFamily: 'Poppins',
          fontSize: 30.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // Reusable method for building gallery cards with optional auto-slide
  Widget _buildGalleryCard({
    required String taskTitle,
    required String dueInfo,
    Color? color = AppPalette.red,
    List<String>? imagePaths,
    bool isAsset = false,
    bool isAutoSlide = false,
    String? background,
  }) {
    final PageController pageController = isAutoSlide && imagePaths != null
        ? _pageControllers[
            exemplarGalleries.indexWhere((e) => e['name'] == taskTitle)]
        : PageController(); // Use specific PageController for auto-sliding galleries

    return Container(
        width: 250.w,
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: imagePaths != null && imagePaths.isNotEmpty
            ? Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    itemCount: imagePaths.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          image: DecorationImage(
                            image: isAsset
                                ? AssetImage(imagePaths[index])
                                : NetworkImage(imagePaths[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildText(
                            taskTitle,
                            18,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.fontWhite,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            dueInfo,
                            style: TextStyle(
                                color: AppPalette.fontWhite, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      image: DecorationImage(
                        image: NetworkImage(background != ''
                            ? background!
                            : AppImage.randomImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildText(
                            taskTitle,
                            18,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.fontWhite,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            dueInfo,
                            style: TextStyle(
                                color: AppPalette.fontWhite, fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
  }

  Widget _buildCreateGalleryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMediaContainer('Create Gallery'),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppPalette.red.withOpacity(.7),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(_imageUrls[_currentImageIndex]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox.shrink(),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: IconButton(
                  icon: const Icon(CupertinoIcons.add_circled,
                      size: 50, color: AppPalette.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: GalleryForm(),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
