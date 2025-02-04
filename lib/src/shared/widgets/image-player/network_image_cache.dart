import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/cache-manager/image_cache_manager.dart';

class ImagePlayerProCachedWidget extends StatefulWidget {
  final String imageUrl;

  const ImagePlayerProCachedWidget({super.key, required this.imageUrl});

  @override
  State<ImagePlayerProCachedWidget> createState() =>
      _ImagePlayerProCachedWidgetState();
}

class _ImagePlayerProCachedWidgetState
    extends State<ImagePlayerProCachedWidget> {
  File? _cachedImage;
  bool _isFullScreen = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cacheImage();
  }

  Future<void> _cacheImage() async {
    try {
      final file = await PhotoCacheManager().getSingleFile(widget.imageUrl);
      if (mounted) {
        setState(() {
          _cachedImage = file;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error caching image: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _showFullScreenImage() {
    showDialog(
      context: context,
      builder: (context) => Stack(
        alignment: Alignment.center,
        children: [
          // Transparent blur background
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),

          // Animated container for smooth transition
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: GestureDetector(
                        onDoubleTap: _toggleFullScreen,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black, // Background for image
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _cachedImage != null
                              ? Hero(
                                  tag: _cachedImage!,
                                  child: Image.file(_cachedImage!,
                                      fit: BoxFit.contain))
                              : Hero(
                                  tag: widget.imageUrl,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.imageUrl,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error, color: Colors.red),
                                    fit:
                                        BoxFit.contain, // Image fully contained
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showFullScreenImage,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: _isLoading
            ? Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: Center(child: CircularProgressIndicator()),
              )
            : _cachedImage != null
                ? Hero(
                    tag: _cachedImage!,
                    child: Image.file(
                      _cachedImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Hero(
                    tag: widget.imageUrl,
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(strokeWidth: 2),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error, color: Colors.red),
                    ),
                  ),
      ),
    );
  }
}
