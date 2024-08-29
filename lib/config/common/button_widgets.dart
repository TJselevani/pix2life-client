import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';

class AuthFlatButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  const AuthFlatButton({super.key, required this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.blueColor, AppPalette.blueColor],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(300, 55),
          backgroundColor: AppPalette.transparent,
          shadowColor: AppPalette.transparent,
          elevation: 0,
        ),
        child: Text(
          name,
          style: const TextStyle(
            color: AppPalette.whiteColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AuthGradientButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  const AuthGradientButton({super.key, required this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.blueColor5, AppPalette.blueColor5],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 55),
          backgroundColor: AppPalette.transparent,
          shadowColor: AppPalette.transparent,
          elevation: 0,
        ),
        child: Text(
          name,
          style: const TextStyle(
            color: AppPalette.whiteColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ChooseButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  const ChooseButton({super.key, required this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.blackColor, AppPalette.blackColor],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AppPalette.whiteColor,
          width: 1.0,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(300, 45),
          padding: EdgeInsets.zero, // Remove padding to align text left
          alignment: Alignment.centerLeft, // Align text to the left
          backgroundColor: AppPalette.transparent,
          shadowColor: AppPalette.transparent,
          elevation: 0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0), // Add padding for text
          alignment: Alignment
              .centerLeft, // Align text to the left within the container
          child: Text(
            name,
            textAlign: TextAlign.left, // Align text to the left
            style: const TextStyle(
              color: AppPalette.greyColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;

  const IconTextButton(
      {super.key, required this.name, this.onPressed, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppPalette.redColor1,
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 10), // text color
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(prefixIcon), // Your icon here
          const SizedBox(width: 20), // Space between icon and text
          Text(
            name, // Your text here
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class NormalFlatButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  const NormalFlatButton({super.key, required this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.whiteColor2, AppPalette.whiteColor3],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(300, 55),
          backgroundColor: AppPalette.transparent,
          shadowColor: AppPalette.transparent,
          elevation: 0,
        ),
        child: Text(
          name,
          style: const TextStyle(
            color: AppPalette.greyColor2,
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;
  final bool useColor;

  const RoundedButton(
      {super.key, required this.name, this.onPressed, this.useColor = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: useColor
              ? [AppPalette.greenColor, AppPalette.greenColor]
              : [AppPalette.redColor1, AppPalette.redColor1],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(300, 55),
          backgroundColor: AppPalette.transparent,
          shadowColor: AppPalette.transparent,
          elevation: 0,
        ),
        child: Text(
          name,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: AppPalette.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String name;
  final VoidCallback? onPressed;

  const SquareButton({super.key, required this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.redColor1, AppPalette.redColor],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(-3, 3), // changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(200, 55),
          backgroundColor: AppPalette.transparent,
          shadowColor: AppPalette.transparent,
          elevation: 0,
        ),
        child: Text(
          name,
          style: const TextStyle(
            color: AppPalette.whiteColor2,
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
                  backgroundColor: AppPalette.blackColor),
            ),
          ),
        );
      },
    );
  }
}
