import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/app/menu/menu-options.dart';
import 'package:pix2life/src/app/navigation/main_navigation_page.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen>
    with SingleTickerProviderStateMixin {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  late AnimationController _animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Adjust animation duration
    );

    // Scale animation when drawer opens/closes
    scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    super.initState();
  }

  // Trigger the animations when drawer state changes
  // ignore: unused_element
  void _onDrawerToggle(bool isOpen) {
    if (isOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: const MenuScreen(),
      mainScreen: AnimatedBuilder(
        animation: scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: const MainPageNavigation(),
          );
        },
      ),
      borderRadius: 24.0,
      showShadow: true,
      angle: 0,
      slideWidth: MediaQuery.of(context).size.width * 0.55,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.easeInBack,
      duration:
          const Duration(milliseconds: 300), // Adjust drawer animation duration
      menuBackgroundColor: AppPalette.navyBlue,
      // onOpened: () => _onDrawerToggle(true), // When drawer opens
      // onClosed: () => _onDrawerToggle(false), // When drawer closes
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// import 'package:pix2life/core/utils/theme/app_palette.dart';
// import 'package:pix2life/src/app/menu/menu.dart';
// import 'package:pix2life/src/app/pages/tests/task.dart';

// class AppDrawer extends StatefulWidget {
//   const AppDrawer({super.key});

//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }

// class _AppDrawerState extends State<AppDrawer>
//     with SingleTickerProviderStateMixin {
//   final ZoomDrawerController _drawerController = ZoomDrawerController();

//   late AnimationController _animationController;
//   late Animation<double> animation;
//   late Animation<double> scaleAnimation;

//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(microseconds: 200),
//     )..addListener(() {
//         setState(() {});
//       });

//     animation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.fastOutSlowIn,
//       ),
//     );

//     scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.fastOutSlowIn,
//       ),
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: ZoomDrawer(
//         controller: _drawerController,
//         menuScreen: const MenuScreen(),
//         mainScreen: const TaskHomePage(),
//         borderRadius: 24.0,
//         showShadow: true,
//         angle: 0,
//         slideWidth: MediaQuery.of(context).size.width * 0.55,
//         openCurve: Curves.fastEaseInToSlowEaseOut,
//         closeCurve: Curves.fastOutSlowIn,
//         duration: const Duration(milliseconds: 200),
//         menuBackgroundColor: AppPalette.navyBlue,
//       ),
//     );
//   }
// }
