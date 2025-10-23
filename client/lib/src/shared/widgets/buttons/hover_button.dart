import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class HoverButton extends StatefulWidget {
  final String? name;
  final bool isWidget;
  final Widget? widget;
  final VoidCallback? onPressed;

  const HoverButton({
    super.key,
    this.name,
    this.onPressed,
    this.isWidget = false,
    this.widget,
  });
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
      duration: const Duration(seconds: 2),
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
            child: widget.isWidget
                ? GestureDetector(
                    onTap: widget.onPressed,
                    child: widget.widget,
                  )
                : ElevatedButton(
                    onPressed: widget.onPressed,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        textStyle: const TextStyle(fontSize: 18),
                        backgroundColor: AppPalette.primaryBlack),
                    child: Text(
                      widget.name!,
                      style: const TextStyle(color: AppPalette.primaryWhite),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
