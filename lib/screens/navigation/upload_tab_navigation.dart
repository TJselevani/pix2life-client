import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/screens/main/media/explore_collage.dart';
import 'package:pix2life/screens/main/media/create_gallery.dart';
import 'package:pix2life/screens/main/media/match_images.dart';
import 'package:pix2life/screens/main/media/upload_media.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadTabNavigation extends StatefulWidget {
  const UploadTabNavigation({super.key});

  @override
  State<UploadTabNavigation> createState() => _UploadTabNavigationState();
}

class _UploadTabNavigationState extends State<UploadTabNavigation>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil to adapt sizes based on screen size
    ScreenUtil.init(context, designSize: Size(375, 812), minTextAdapt: true);

    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
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
      backgroundColor: AppPalette.transparent,
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
        color: AppPalette.whiteColor,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: ScreenUtil().setWidth(5),
            blurRadius: ScreenUtil().setWidth(7),
            offset: Offset(
                0, ScreenUtil().setHeight(3)), // changes position of shadow
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: TabBarView(
          controller: _tabController,
          children: const [
            GalleryScreen(),
            UploadMediaPage(),
            ImageMatchScreen(),
            CollageScreen(),
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
            color: AppPalette.redColor1,
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(20)),
          ),
          unselectedLabelColor: AppPalette.redColor1,
          dividerColor: AppPalette.transparent,
          labelColor: Colors.white,
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
      _buildTab(text: 'Gallery'),
      _buildTab(text: 'Upload'),
      _buildTab(text: 'Match'),
      _buildTab(text: 'Collage'),
    ];
  }

  Widget _buildTab({required String text}) {
    return InkWell(
      splashColor: AppPalette.redColor1,
      highlightColor: AppPalette.redColor1,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(8),
          horizontal: ScreenUtil().setWidth(10),
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
