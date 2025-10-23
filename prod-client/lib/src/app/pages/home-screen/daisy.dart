import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/app/pages/home-screen/gallery_card.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_provider.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/features/gallery/data/data_source/gallery_provider.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:pix2life/src/features/gallery/presentation/views/create_gallery_form.dart';
import 'package:pix2life/src/features/gallery/presentation/views/exemplar_galleries.dart';
import 'package:pix2life/src/features/gallery/domain/entities/gallery.dart';
import 'package:pix2life/src/features/image/presentation/widgets/gallery_popup_dialog.dart';
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
  final logger = createLogger(Daisy);
  late List<Gallery> fetchedGalleries;
  late List<String> galleryNames;
  User? authUser;

  final List<String> _imageUrls = [
    AppImage.img1,
    AppImage.img2,
    AppImage.img3,
    AppImage.img4,
    AppImage.img5,
    AppImage.img6,
    AppImage.img7,
    AppImage.img8,
    AppImage.img9,
    AppImage.img10,
    AppImage.img11,
    AppImage.img12,
    AppImage.img13,
  ];

  final List<Map<String, dynamic>> pix2lifeGalleries = [
    {
      'name': 'Pix2life Gallery',
      'description': 'A collection of life photos',
      'image': 'assets/images/A.jpg',
    },
  ];

  final ValueNotifier<int> _currentImageIndexNotifier = ValueNotifier<int>(0);
  final Map<String, PageController> _pageControllers = {};
  final Map<String, int> _currentPageMap = {};
  final List<Timer> _gallerySlideTimers = [];
  Timer? _imageShuffleTimer;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _startImageShuffle();
    _initializePageControllers();

    final userState = BlocProvider.of<AuthBloc>(context).state;
    if (userState is! AuthenticatedUser) {
      BlocProvider.of<AuthBloc>(context)
          .add(AuthRetrieveAuthenticatedUserEvent());
    }

    final galleryState = BlocProvider.of<GalleryBloc>(context).state;
    if (galleryState is! GalleriesLoaded) {
      BlocProvider.of<GalleryBloc>(context).add(GalleryFetchGalleriesEvent());
    }
  }

  void _startImageShuffle() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      // Check if the widget is still mounted before updating the ValueNotifier
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (_imageUrls.isNotEmpty) {
        _currentImageIndexNotifier.value =
            (_currentImageIndexNotifier.value + 1) % _imageUrls.length;
      }
    });
  }

  void _initializePageControllers() {
    for (var gallery in pix2lifeGalleries) {
      final galleryName = gallery['name'];
      if (!_pageControllers.containsKey(galleryName)) {
        _pageControllers[galleryName] = PageController();
        _startGallerySlide(galleryName, _imageUrls);
      }
    }
  }

  void _startGallerySlide(String galleryName, List<String> imagePaths) {
    if (imagePaths.isEmpty) return;
    _currentPageMap.putIfAbsent(galleryName, () => 0);

    _gallerySlideTimers.add(Timer.periodic(const Duration(seconds: 3), (timer) {
      final nextPage = (_currentPageMap[galleryName]! + 1) % imagePaths.length;
      _currentPageMap[galleryName] = nextPage;

      final controller = _pageControllers[galleryName];
      if (controller != null && controller.hasClients) {
        controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    }));
  }

  void _showPix2lifeImages(BuildContext context, String galleryName) {
    GalleryDialog.showPix2lifeImagesDialog(
      context: context,
      images: _imageUrls, // Pass the loaded images
      galleryName: galleryName, // Pass the gallery name
    );
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
      SuccessSnackBar.show(context: context, message: 'refreshing');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _imageShuffleTimer?.cancel();
    for (var timer in _gallerySlideTimers) {
      timer.cancel();
    }
    for (var controller in _pageControllers.values) {
      controller.dispose();
    }
    _currentImageIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<MyUserProvider>(context);
    final galleryProvider = Provider.of<MyGalleryProvider>(context);
    authUser = userProvider.user;
    fetchedGalleries = galleryProvider.galleries;

    return MultiBlocListener(
      listeners: [
        BlocListener<GalleryBloc, GalleryState>(
          listener: (context, state) {
            if (state is GalleriesLoaded) {
              fetchedGalleries.clear();
              fetchedGalleries = state.galleries;
            }

            // if (state is! GalleriesLoaded) {
            //   BlocProvider.of<GalleryBloc>(context)
            //       .add(GalleryFetchGalleriesEvent());
            // }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedInUser) {
              BlocProvider.of<AuthBloc>(context)
                  .add(AuthRetrieveAuthenticatedUserEvent());
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 5.h),
        body: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildProfileHeader(),
                SizedBox(height: 10.h),
                _buildSectionTitleContainer('Galleries'),
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
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: Offset(-15.w, 0), // Shift left by 10 pixels; adjust as needed
        child: SizedBox(
          width: ScreenUtil().setWidth(200),
          height: ScreenUtil().setHeight(50),
          child: const Pix2lifeLogo(),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogo(),
            Row(
              children: [
                _buildText('Hello', 20),
                SizedBox(width: 4.w),
                if (authUser?.username != null)
                  SizedBox(
                      width: 160.w,
                      child:
                          FadeInText(text: authUser!.username.split('/')[0])),
              ],
            ),
            SizedBox(height: 4.h),
            _buildText('Have a nice day!', 18),
          ],
        ),
        SizedBox(
            width: 100.w, height: 100.h, child: const UserAvatar(radius: 60)),
      ],
    );
  }

  Widget _buildGalleryListView() {
    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: fetchedGalleries.length + 1,
        itemBuilder: (context, index) {
          return index == 0
              ? GestureDetector(
                  onLongPress: () {
                    _showPix2lifeImages(context, pix2lifeGalleries[0]['name']!);
                  },
                  onTap: () {
                    _showPix2lifeImages(context, pix2lifeGalleries[0]['name']!);
                  },
                  // onDoubleTap: () {
                  //   _showPix2lifeImages(context, pix2lifeGalleries[0]['name']!);
                  // },
                  child: GalleryCard(
                    title: pix2lifeGalleries[0]['name']!,
                    description: pix2lifeGalleries[0]['description']!,
                    imagePaths: _imageUrls,
                    controller: _pageControllers[pix2lifeGalleries[0]['name']!],
                    isAsset: true,
                  ),
                )
              : GestureDetector(
                  onLongPress: () {
                    _showGalleryImages(
                        context, fetchedGalleries[index - 1].name);
                  },
                  onTap: () {
                    _showGalleryImages(
                        context, fetchedGalleries[index - 1].name);
                  },
                  // onDoubleTap: () {
                  //   _showGalleryImages(
                  //       context, fetchedGalleries[index - 1].name);
                  // },
                  child: GalleryCard(
                    title: fetchedGalleries[index - 1].name,
                    description: fetchedGalleries[index - 1].description,
                    backgroundImage: fetchedGalleries[index - 1].iconUrl,
                  ),
                );
        },
      ),
    );
  }

  Widget _buildCreateGalleryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitleContainer('Create Gallery'),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentImageIndexNotifier,
                  builder: (context, currentIndex, child) {
                    return Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppPalette.red.withOpacity(.7),
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage(
                              AppImage.welcomeImage), //_imageUrls[currentIndex]
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 10.w),
            IconButton(
              icon: const Icon(CupertinoIcons.add_circled,
                  size: 50, color: AppPalette.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      const AlertDialog(content: GalleryForm()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildText(
    String text,
    double fontSize, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize.sp, fontWeight: fontWeight),
    );
  }

  Widget _buildSectionTitleContainer(String label) {
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
}
