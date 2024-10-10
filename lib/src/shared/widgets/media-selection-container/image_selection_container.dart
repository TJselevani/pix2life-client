
import 'dart:io';

import 'package:flutter/material.dart';

class ImageSelectionContainer extends StatelessWidget {
  final String mediaPath;
  final VoidCallback? onRemove;
  final BuildContext context;


  const ImageSelectionContainer({
    super.key,
    required this.mediaPath,
    this.onRemove,
    required this.context,

  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.file(
          File(mediaPath),
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
    );
  }
}
