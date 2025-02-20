import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class ErrorSnackBar {
  static OverlayEntry? _overlayEntry;

  static void show({
    required BuildContext context,
    required String message,
    Color backgroundColor = AppPalette.primaryWhite,
    Color textColor = AppPalette.red,
    Color iconColor = AppPalette.red,
    int durationInSeconds = 3,
  }) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IntrinsicWidth(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info, color: iconColor),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        message,
                        style: TextStyle(color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(Duration(seconds: durationInSeconds), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }
}
