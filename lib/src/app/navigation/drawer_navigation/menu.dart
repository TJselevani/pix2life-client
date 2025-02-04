import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/app/pages/subscription/subscription_page.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_provider.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:provider/provider.dart';

class MenuPanel extends StatefulWidget {
  const MenuPanel({super.key});

  @override
  State<MenuPanel> createState() => _MenuPanelState();
}

class _MenuPanelState extends State<MenuPanel> {
  late bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    User? authUser;

    final userProvider = Provider.of<MyUserProvider>(context);
    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);
    authUser = userProvider.user;
    return Scaffold(
      backgroundColor:
          isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
      body: SizedBox(
        width: 288,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.h),
              InfoCard(
                name: authUser?.username ?? 'App User',
                title: authUser?.subscriptionPlan ?? '',
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  // Navigate to home or close drawer
                  ZoomDrawer.of(context)!.close();
                },
              ),
              ListTile(
                title: const Text('Subscriptions'),
                onTap: () {
                  // Navigate to subscriptions page
                  ZoomDrawer.of(context)!.close();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SubscriptionsPage(),
                    ),
                  );
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
      leading: CircleAvatar(
        backgroundColor: AppPalette.navyBlue,
        child: Icon(
          CupertinoIcons.person,
          color: Colors.white,
        ),
      ),
      title: Text(
        name,
        overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
        maxLines: 1,
        style: const TextStyle(
          color: AppPalette.fontGrey,
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
