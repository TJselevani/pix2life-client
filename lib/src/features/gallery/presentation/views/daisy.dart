import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/features/gallery/presentation/views/exemplar_galleries.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:pix2life/src/shared/widgets/logo/app_logo.dart';

class Daisy extends StatefulWidget {
  const Daisy({super.key});

  @override
  State<Daisy> createState() => _DaisyState();
}

class _DaisyState extends State<Daisy> {
  final log = createLogger(Daisy);
  final List<PageController> _pageControllers = [];
  List<Gallery> fetchedGalleries = [];
  List<String> galleryNames = [];

  Timer? _timer;
  int _currentPage = 0;
  String? gallery;

  @override
  void initState() {
    super.initState();
    // Initialize the auto-slider and fetch galleries after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoSlide();
      _initializePageControllers();
    });
    _fetchGalleries();
  }

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
    // Add more galleries as needed
  ];

  // Initializes PageControllers for each gallery
  void _initializePageControllers() {
    for (var i = 0; i < exemplarGalleries.length; i++) {
      _pageControllers.add(PageController());
    }
  }

  // Fetch galleries and trigger events only if they haven't been loaded
  void _fetchGalleries() {
    final currentState = context.read<GalleryBloc>().state;

    if (currentState is! GalleryImagesLoaded) {
      context.read<GalleryBloc>().add(GalleryFetchGalleriesEvent());
    }

    if (gallery != null && currentState is! GalleryImagesLoaded) {
      context
          .read<GalleryBloc>()
          .add(GalleryFetchImagesEvent(galleryName: gallery!));
    }
  }

  // Auto-slide functionality for gallery cards
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
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
  void dispose() {
    // Dispose all PageControllers
    for (var controller in _pageControllers) {
      controller.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GalleryBloc, GalleryState>(
      listener: (context, state) {
        if (state is GalleriesLoaded) {
          setState(() {
            fetchedGalleries = state.galleries;
            galleryNames =
                fetchedGalleries.map((gallery) => gallery.name).toList();
          });
          log.i('Fetched ${fetchedGalleries.length} galleries: $galleryNames');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppPalette.lightBackground,
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
                SizedBox(height: 20.h),
                showcaseGalleries(), // Showcase more galleries if needed
              ],
            ),
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
                  _buildText(' Daisy!', 24, fontWeight: FontWeight.bold),
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
        CircleAvatar(
          radius: 40.r, // Responsive radius
          backgroundImage: const NetworkImage(
            'https://random.imagecdn.app/150/150',
          ),
        ),
      ],
    );
  }

  // Media container section (Images, Videos, Audios)
  Widget _buildMediaContainers() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: _buildMediaContainer('Galleries'),
        ),
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
              fetchedGalleries.length + 1, // Add one for the exemplar gallery
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
              final gallery = fetchedGalleries[index - 1];
              return _buildGalleryCard(
                taskTitle: gallery.name,
                dueInfo: 'Due: ${index + 1} days left',
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
        color: color,
      ),
    );
  }

  // Reusable method for creating media containers
  Widget _buildMediaContainer(String label) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        // color: AppPalette.red,
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
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildText(taskTitle, 18, fontWeight: FontWeight.bold),
                  SizedBox(height: 4.h),
                  Text(
                    dueInfo,
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
    );
  }
}
