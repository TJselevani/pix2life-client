import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/features/audio/presentation/pages/display_audios/audio_grid.dart';
import 'package:pix2life/src/features/image/presentation/views/display_images/image_grid.dart';
import 'package:pix2life/src/features/video/presentation/views/display_videos/video_grid.dart';
import 'package:provider/provider.dart';

class MediaTabNavigation extends StatefulWidget {
  const MediaTabNavigation({super.key});

  @override
  State<MediaTabNavigation> createState() => _MediaTabNavigationState();
}

class _MediaTabNavigationState extends State<MediaTabNavigation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize isDarkMode based on themeProvider's current theme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider =
          Provider.of<MyThemeProvider>(context, listen: false);
      setState(() {
        isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
            (themeProvider.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildTabBarView(),
          _buildTabBar(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: ScreenUtil().setHeight(10),
    );
  }

  Widget _buildTabBarView() {
    return Container(
      margin: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(5),
        ScreenUtil().setHeight(95),
        ScreenUtil().setWidth(5),
        ScreenUtil().setHeight(20),
      ),
      decoration: BoxDecoration(
        color:
            isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: ScreenUtil().setWidth(5),
            blurRadius: ScreenUtil().setWidth(7),
            offset: Offset(0, ScreenUtil().setHeight(3)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: TabBarView(
          controller: _tabController,
          children: const [
            ImageGridPage(),
            AudioGridPage(),
            VideoGridPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Positioned(
      top: ScreenUtil().setHeight(25),
      left: ScreenUtil().setWidth(10),
      right: ScreenUtil().setWidth(10),
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(25)),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppPalette.red,
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
          ),
          unselectedLabelColor: AppPalette.red,
          dividerColor: AppPalette.transparent,
          labelColor: AppPalette.primaryWhite,
          labelPadding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(5),
            vertical: ScreenUtil().setHeight(5),
          ),
          tabs: _buildTabs(),
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return [
      _buildTab(text: 'Photos'),
      _buildTab(text: 'Audio'),
      _buildTab(text: 'Videos'),
    ];
  }

  Widget _buildTab({required String text}) {
    return InkWell(
      splashColor: AppPalette.red,
      highlightColor: AppPalette.red,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(8),
          horizontal: ScreenUtil().setWidth(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: ScreenUtil().setSp(14),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
