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
    this.displayDuration = const Duration(seconds: 5),
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
            style: const TextStyle(fontSize: 20),
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

class HoverButton extends StatefulWidget {
  final String name;
  final VoidCallback? onPressed;

  const HoverButton({super.key, required this.name, this.onPressed});
  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppPalette.transparent,
                  AppPalette.transparent,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 12,
                  offset: const Offset(0, 6), // changes position of shadow
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              child: Text(
                '${widget.name}',
                style: TextStyle(color: AppPalette.whiteColor),
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: AppPalette.redColor1.withOpacity(0.3)),
            ),
          ),
        );
      },
    );
  }
}

class ShutterButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color color;

  const ShutterButton({
    Key? key,
    this.onPressed,
    this.size = 60.0,
    this.color = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
          ),
          child: Center(
            child: Container(
              width: size * 0.6,
              height: size * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
