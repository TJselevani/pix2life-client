import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.navyBlue,
      body: Container(
        width: 288,
        height: double.infinity,
        color: AppPalette.navyBlue,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.h),
              const infoCard(
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

class infoCard extends StatelessWidget {
  final String name;
  final String title;
  const infoCard({
    super.key,
    required this.name,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
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
