import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:provider/provider.dart';

class MenuPanel extends StatelessWidget {
  const MenuPanel({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: SizedBox(
        width: 288,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.h),
              const InfoCard(
                name: 'tjselevani',
                title: 'Developer',
              ),
              ListTile(
                title:
                    const Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navigate to home or close drawer
                  ZoomDrawer.of(context)!.close();
                },
              ),
              ListTile(
                title: const Text('Profile',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navigate to profile
                  // ZoomDrawer.of(context)!.context;
                },
              ),
              ListTile(
                title: const Text('Settings',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Navigate to settings
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String name;
  final String title;
  const InfoCard({
    super.key,
    required this.name,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppPalette.navyBlue,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: AppPalette.fontWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        title,
        style: const TextStyle(
          color: AppPalette.fontGrey,
        ),
      ),
    );
  }
}
