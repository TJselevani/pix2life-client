import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/app/navigation/tab_navigation/media_tab_navigation.dart';
import 'package:pix2life/src/features/gallery/presentation/views/daisy.dart';
import 'package:pix2life/src/app/pages/profile%20screen/profile_screen.dart';
import 'package:pix2life/src/app/navigation/drawer_navigation/menu_options.dart';
import 'package:pix2life/src/app/pages/upload-screen/test.dart';
import 'package:pix2life/src/features/image/presentation/views/match_image/match_images.dart';

class MainPageNavigation extends StatefulWidget {
  const MainPageNavigation({super.key});

  static Route createRoute() {
    return MaterialPageRoute(builder: (context) => const MainPageNavigation());
  }

  @override
  State<MainPageNavigation> createState() => _MainPageNavigationState();
}

class _MainPageNavigationState extends State<MainPageNavigation>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  // Drawer controller
  final ZoomDrawerController _drawerController = ZoomDrawerController();

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
    const Daisy(), // FirstPage
    const MediaTabNavigation(), // SecondPage
    const UploadScreen(), // ThirdPage
    const ImageMatchScreen(), // FourthPage
    const ProfileScreen(), // FifthPage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Trigger animations when drawer state changes
  void _onDrawerToggle(bool isOpen) {
    if (isOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive UI
    ScreenUtil.init(context,
        designSize: const Size(375, 804), minTextAdapt: true);

    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: const MenuScreen(),
      mainScreen: Scaffold(
        backgroundColor: AppPalette.lightBackground,
        // Display a button at the top left if the last tab (ProfileScreen) is selected
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
            if (_selectedIndex ==
                _pages.length -
                    1) // Only show button on last page (ProfileScreen)
              Positioned(
                top: 30.h, // Adjust top positioning
                left: 5.w, // Adjust left positioning
                child: IconButton(
                  icon: Icon(CupertinoIcons.arrow_merge,
                      color: AppPalette.navyBlue, size: 24.sp),
                  onPressed: () {
                    _drawerController.toggle!();
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
      menuBackgroundColor: AppPalette.navyBlue,
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0,
      items: [
        _buildBottomNavigationBarItem(CupertinoIcons.home), // Home
        _buildBottomNavigationBarItem(CupertinoIcons.app), // Blocks
        _buildBottomNavigationBarItem(CupertinoIcons.add_circled), // Upload
        _buildBottomNavigationBarItem(CupertinoIcons.app), // Cells
        _buildBottomNavigationBarItem(CupertinoIcons.person), // Profile/Menu
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppPalette.red,
      unselectedItemColor: AppPalette.red,
      backgroundColor: AppPalette.lightBackground,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Container(
        decoration: BoxDecoration(
          color: AppPalette.red, // Filled color for the selected item
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: Colors.white, // White icon color when selected
        ),
      ),
      label: '', // No label
    );
  }
}
