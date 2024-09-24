import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/app/navigation/media_tab_navigation.dart';
import 'package:pix2life/src/app/navigation/upload_tab_navigation.dart';
import 'package:pix2life/src/app/pages/main/landing_page.dart.dart';
import 'package:pix2life/src/app/pages/profile%20screen/profile_screen.dart';
import 'package:pix2life/src/app/pages/upload-screen/select_media_upload.dart';
import 'package:pix2life/src/shared/widgets/logo/app_logo.dart';

class MainPageNavigation extends StatefulWidget {
  const MainPageNavigation({super.key});

  static Route createRoute() {
    return MaterialPageRoute(builder: (context) => const MainPageNavigation());
  }

  @override
  State<MainPageNavigation> createState() => _MainPageNavigationState();
}

class _MainPageNavigationState extends State<MainPageNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const Daisy(), //FirstPage
    const MediaTabNavigation(), // Third Page
    const UploadScreen(), //Second Page
    const UploadTabNavigation(), // Fourth Page
    const ProfileScreen(), // Fourth Page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil to adapt sizes based on screen size
    ScreenUtil.init(context,
        designSize: const Size(375, 804), minTextAdapt: true);

    return Scaffold(
      backgroundColor: AppPalette.lightBackground,
      // appBar: _buildAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppPalette.lightBackground,
      title: _buildAuthLogo(),
    );
  }

  Widget _buildAuthLogo() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {},
        child: SizedBox(
          width: ScreenUtil().setWidth(200),
          height: ScreenUtil().setHeight(190),
          child: const Pix2lifeLogo(),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      elevation: 0,
      selectedFontSize: ScreenUtil().setSp(17),
      items: <BottomNavigationBarItem>[
        _buildBottomNavigationBarItem(
          icon: CupertinoIcons.home, //Icons.airplay_rounded, //home_filled
          label: 'Home',
        ),
        _buildBottomNavigationBarItem(
          icon: CupertinoIcons.app, //all_inclusive_rounded,
          label: 'Blocks', //perm_media_rounded
        ),
        _buildBottomNavigationBarItem(
          icon: CupertinoIcons.add_circled, // Icons.architecture_rounded,
          label: 'upload',
        ),
        _buildBottomNavigationBarItem(
          icon: CupertinoIcons.app, // Icons.architecture_rounded,
          label: 'cells',
        ),
        _buildBottomNavigationBarItem(
          icon: CupertinoIcons.person, // Icons.architecture_rounded,
          label: 'Menu',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppPalette.red,
      unselectedItemColor: AppPalette.blueAccent,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: ScreenUtil().setSp(16),
        color: AppPalette.red,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: ScreenUtil().setSp(12),
      ),
      onTap: _onItemTapped,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      backgroundColor: AppPalette.lightBackground,
      icon: Icon(
        icon,
        color: AppPalette.red,
      ),
      label: label,
    );
  }
}
