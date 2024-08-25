import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/auth_logo.dart';
import 'package:pix2life/screens/billet/upload_profile.dart';
import 'package:pix2life/screens/main/menu/index.dart';
import 'package:pix2life/screens/navigation/media_tab_navigation.dart';
import 'package:pix2life/screens/navigation/upload_tab_navigation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static Route createRoute() {
    return MaterialPageRoute(builder: (context) => const MainPage());
  }

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    MediaTabNavigation(),
    UploadTabNavigation(),
    MenuPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil to adapt sizes based on screen size
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor:
          _selectedIndex == 2 ? AppPalette.whiteColor : AppPalette.whiteColor,
      title: _selectedIndex != 2 ? _buildAuthLogo() : const SizedBox.shrink(),
    );
  }

  Widget _buildAuthLogo() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UploadProfilePicPage()),
        ),
        child: SizedBox(
          width: ScreenUtil().setWidth(200),
          height: ScreenUtil().setHeight(190),
          child: const AuthLogo(),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor:
          _selectedIndex == 2 ? AppPalette.whiteColor : AppPalette.whiteColor,
      elevation: 0,
      selectedFontSize: ScreenUtil().setSp(17),
      items: <BottomNavigationBarItem>[
        _buildBottomNavigationBarItem(
          icon: Icons.home_filled,
          label: 'Home',
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.perm_media_rounded,
          label: 'Media',
        ),
        _buildBottomNavigationBarItem(
          icon: Icons.menu,
          label: 'Menu',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor:
          _selectedIndex != 2 ? AppPalette.redColor1 : AppPalette.redColor1,
      unselectedItemColor:
          _selectedIndex != 2 ? AppPalette.redColor1 : AppPalette.redColor1,
      selectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: ScreenUtil().setSp(14),
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        fontSize: ScreenUtil().setSp(14),
      ),
      onTap: _onItemTapped,
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color:
            _selectedIndex != 2 ? AppPalette.redColor1 : AppPalette.redColor1,
      ),
      label: label,
    );
  }
}
