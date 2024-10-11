import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class RedCameraIcon extends CustomPainter {
  final ImageInfo imageInfo;

  RedCameraIcon({required this.imageInfo});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..colorFilter = const ColorFilter.mode(
        AppPalette.red, // Apply red tint
        BlendMode.modulate, // Blend mode to apply the color
      );

    // Draw the preloaded image
    canvas.drawImageRect(
      imageInfo.image,
      Rect.fromLTRB(0, 0, imageInfo.image.width.toDouble(),
          imageInfo.image.height.toDouble()),
      Rect.fromLTRB(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint if the image changes
  }
}

class RedCircleAvatar extends StatefulWidget {
  final String imagePath;

  const RedCircleAvatar({required this.imagePath, super.key});

  @override
  State<RedCircleAvatar> createState() => _RedCircleAvatarState();
}

class _RedCircleAvatarState extends State<RedCircleAvatar> {
  ImageInfo? _imageInfo;
  late ImageStream _imageStream;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  // Preload the image
  void _loadImage() {
    _imageStream =
        AssetImage(widget.imagePath).resolve(ImageConfiguration.empty);
    _imageStream.addListener(
      ImageStreamListener((ImageInfo info, bool synchronousCall) {
        setState(() {
          _imageInfo = info;
        });
      }),
    );
  }

  @override
  void dispose() {
    _imageStream.removeListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: _imageInfo != null
            ? CustomPaint(
                size: const Size(100, 100),
                painter: RedCameraIcon(imageInfo: _imageInfo!),
              )
            : const Center(
                child:
                    CircularProgressIndicator()), // Show a loader while the image is loading
      ),
    );
  }
}
