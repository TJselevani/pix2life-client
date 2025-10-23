import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/app/navigation/drawer_navigation/drawer_provider.dart';
import 'package:pix2life/src/app/navigation/drawer_navigation/menu.dart';
import 'package:pix2life/src/app/navigation/tab_navigation/media_tab_navigation.dart';
import 'package:pix2life/src/app/pages/home-screen/daisy.dart';
import 'package:pix2life/src/app/pages/upload-screen/media_upload.dart';
import 'package:pix2life/src/features/image/presentation/views/match_image/match_images.dart';
import 'package:provider/provider.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/app/pages/profile-screen/profile_screen.dart';

class BottomTabNavigation extends StatefulWidget {
  const BottomTabNavigation({super.key});

  static Route createRoute() {
    return MaterialPageRoute(builder: (context) => const BottomTabNavigation());
  }

  @override
  State<BottomTabNavigation> createState() => _BottomTabNavigationState();
}

class _BottomTabNavigationState extends State<BottomTabNavigation>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool isDarkMode = false;

  // Animation Controller for drawer open/close
  late AnimationController _animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Pages for navigation
  static final List<Widget> _pages = <Widget>[
    const Daisy(),
    const MediaTabNavigation(),
    const MediaUploadScreen(),
    const ImageMatchScreen(),
    const MyProfileScreen(), // Profile page where drawer toggle happens
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use ZoomDrawerProvider here
    final zoomDrawerProvider = Provider.of<MyZoomDrawerProvider>(context);
    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return ZoomDrawer(
      controller: zoomDrawerProvider.drawerController,
      menuScreen: const MenuPanel(),
      mainScreen: Scaffold(
        backgroundColor:
            isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: scaleAnimation.value,
                  child: _pages[_selectedIndex],
                );
              },
            ),
            if (_selectedIndex == _pages.length - 1)
              Positioned(
                top: 30.h,
                left: 5.w,
                child: IconButton(
                  icon: Icon(
                    CupertinoIcons.app_fill,
                    color: AppPalette.transparent,
                    size: 24.sp,
                  ),
                  onPressed: () {
                    zoomDrawerProvider
                        .toggleDrawer(); // Use the provider's toggle
                  },
                ),
              ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
      borderRadius: 24.0,
      showShadow: true,
      angle: 0,
      slideWidth: MediaQuery.of(context).size.width * 0.55,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.easeInBack,
      duration: const Duration(milliseconds: 300),
      menuBackgroundColor:
          isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0,
      items: [
        _buildBottomNavigationBarItem(CupertinoIcons.home, 'Home'),
        _buildBottomNavigationBarItem(CupertinoIcons.memories, 'Media'),
        _buildBottomNavigationBarItem(
            CupertinoIcons.add_circled, 'Upload Media'),
        _buildBottomNavigationBarItem(
            CupertinoIcons.photo_on_rectangle, 'Match Images'),
        _buildBottomNavigationBarItem(CupertinoIcons.person, 'Profile'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppPalette.red,
      unselectedItemColor: AppPalette.red,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Container(
        decoration: BoxDecoration(
          color: AppPalette.red,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      label: label,
    );
  }
}
