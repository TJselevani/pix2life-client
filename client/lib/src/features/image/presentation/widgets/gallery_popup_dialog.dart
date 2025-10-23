import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/src/features/image/domain/entities/image.dart';

class GalleryDialog {
  static void showGalleryImagesDialog({
    required BuildContext context,
    required List<Photo> images,
    required String galleryName,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return FullScreenGallery(images: images, galleryName: galleryName);
      },
    );
  }

  static void showPix2lifeImagesDialog({
    required BuildContext context,
    required List<String> images,
    required String galleryName,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return FullScreenGallery2(images: images, galleryName: galleryName);
      },
    );
  }
}

class FullScreenGallery extends StatefulWidget {
  final List<Photo> images;
  final String galleryName;

  const FullScreenGallery({
    super.key,
    required this.images,
    required this.galleryName,
  });

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;
  bool isAutoScrollEnabled = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (isAutoScrollEnabled) {
      _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
        if (_currentIndex < widget.images.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0; // Loop back to the first image
        }
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _toggleAutoScroll() {
    setState(() {
      isAutoScrollEnabled = !isAutoScrollEnabled;
      if (isAutoScrollEnabled) {
        _startAutoScroll();
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Background blur effect with tap-to-dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // Fullscreen PageView for images
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                final image = widget.images[index];
                return Image.network(
                  image.url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 60,
                  ),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          // Overlay title and auto-scroll toggle button
          Positioned(
            bottom: 30.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Use Expanded to prevent overflow and ensure proper alignment
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: 300.w), // Set max width for the text
                    child: Text(
                      widget.galleryName,
                      overflow:
                          TextOverflow.ellipsis, // Cut off text with ellipsis
                      maxLines: 1, // Ensure single line
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 10.w),
                    IconButton(
                      icon: Icon(
                        isAutoScrollEnabled
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white,
                      ),
                      onPressed: _toggleAutoScroll,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//####################################################################################################

class FullScreenGallery2 extends StatefulWidget {
  final List<String> images;
  final String galleryName;

  const FullScreenGallery2({
    super.key,
    required this.images,
    required this.galleryName,
  });

  @override
  State<FullScreenGallery2> createState() => _FullScreenGallery2State();
}

class _FullScreenGallery2State extends State<FullScreenGallery2> {
  late PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;
  bool isAutoScrollEnabled = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (isAutoScrollEnabled) {
      _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
        if (_currentIndex < widget.images.length - 1) {
          _currentIndex++;
        } else {
          _currentIndex = 0; // Loop back to the first image
        }
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _toggleAutoScroll() {
    setState(() {
      isAutoScrollEnabled = !isAutoScrollEnabled;
      if (isAutoScrollEnabled) {
        _startAutoScroll();
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Background blur effect with tap-to-dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // Fullscreen PageView for images
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                final image = widget.images[index];
                return Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.white,
                    size: 60,
                  ),
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          // Overlay title and auto-scroll toggle button
          Positioned(
            bottom: 30.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.galleryName,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 10.w),
                    IconButton(
                      icon: Icon(
                        isAutoScrollEnabled
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.white,
                      ),
                      onPressed: _toggleAutoScroll,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
