import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class DisappearingText extends StatefulWidget {
  final String text;
  final bool isVisible;
  final Duration displayDuration;

  const DisappearingText({
    super.key,
    required this.text,
    this.displayDuration = const Duration(seconds: 3),
    required this.isVisible,
  });

  @override
  State<DisappearingText> createState() => _DisappearingTextState();
}

class _DisappearingTextState extends State<DisappearingText> {
  bool _isVisible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isVisible = widget.isVisible;
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(DisappearingText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isVisible != oldWidget.isVisible) {
      setState(() {
        _isVisible = widget.isVisible;
      });
      _startTimerIfNeeded();
    }
  }

  void _startTimerIfNeeded() {
    // Cancel any existing timer
    _timer?.cancel();

    // If the widget is set to be visible, start a timer to hide it
    if (_isVisible) {
      _timer = Timer(widget.displayDuration, () {
        if (mounted) {
          setState(() {
            _isVisible = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isVisible
        ? Text(
            widget.text,
            style: TextStyle(
              fontSize: 20.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: AppPalette.red,
            ),
          )
        : Container(); // Return an empty container when the text disappears
  }
}
