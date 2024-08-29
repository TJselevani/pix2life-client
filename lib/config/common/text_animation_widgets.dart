import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pix2life/config/app/app_palette.dart';

class DisappearingText extends StatefulWidget {
  final String text;
  final bool isVisible;
  final Duration displayDuration;

  const DisappearingText({
    Key? key,
    required this.text,
    this.displayDuration = const Duration(seconds: 3),
    required this.isVisible,
  }) : super(key: key);

  @override
  _DisappearingTextState createState() => _DisappearingTextState();
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
            style: const TextStyle(
              fontSize: 10,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: AppPalette.redColor1,
            ),
          )
        : Container(); // Return an empty container when the text disappears
  }
}

class Confetti extends StatefulWidget {
  final controller;
  const Confetti({super.key, this.controller});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {
  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: widget.controller,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: true,
      colors: [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        AppPalette.redColor1,
      ],
    );
  }
}

class FadeInText extends StatelessWidget {
  const FadeInText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'PIX2LIFE',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: AppPalette.blackColor3),
    ).animate().fadeIn(duration: const Duration(seconds: 2));
  }
}

class SlideInText extends StatelessWidget {
  const SlideInText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Slide In',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: AppPalette.blackColor3),
    )
        .animate()
        .slideX(begin: -1.0, end: 0.0, duration: const Duration(seconds: 2));
  }
}

class ScaleText extends StatelessWidget {
  const ScaleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Scale',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: AppPalette.blackColor3),
    ).animate().scale(
        begin: const Offset(0, 0),
        end: const Offset(1, 2),
        duration: const Duration(seconds: 2));
  }
}

class RotateText extends StatelessWidget {
  const RotateText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Rotate',
      style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: AppPalette.blackColor3),
    )
        .animate()
        .rotate(begin: -1.0, end: 0.0, duration: const Duration(seconds: 2));
  }
}

