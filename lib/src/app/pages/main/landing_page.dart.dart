import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/shared/widgets/logo/app_logo.dart';

class Daisy extends StatelessWidget {
  const Daisy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.lightBackground,
        toolbarHeight: 5.h,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Profile Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            buildText('Hello', 20),
                            buildText(' Daisy!', 24,
                                fontWeight: FontWeight.bold),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setHeight(50),
                          child: const Pix2lifeLogo(),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: buildText('Have a nice day!', 18),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 40.r, // Responsive radius
                    backgroundImage: const NetworkImage(
                      'https://random.imagecdn.app/150/150',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Media Containers Section
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildMediaContainer('images'),
                  SizedBox(width: 5.w),
                  buildMediaContainer('videos'),
                  SizedBox(width: 5.w),
                  buildMediaContainer('audios'),
                ],
              ),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: Icon(Icons.settings, size: 24.sp),
              // ),
              SizedBox(height: 20.h),

              // Task List Section (Horizontal ListView)
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: SizedBox(
                  height: 240.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return buildTaskCard(
                        'UI Design',
                        'Due: ${index + 1} days left',
                        color: AppPalette.red.withOpacity(.6),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Back End Development Task
              buildTaskCard(
                'Back End Development',
                'Due: 2 days left',
                color: AppPalette.red.withOpacity(.4),
              ),
              SizedBox(height: 20.h),

              // Progress Section
              buildText('Progress', 18, fontWeight: FontWeight.bold),
              SizedBox(height: 4.h),
              buildText('Project Name Here', 16),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable method for text styling
  Widget buildText(String text, double fontSize,
      {FontWeight fontWeight = FontWeight.normal}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize.sp, // Using .sp for font scaling
        fontWeight: fontWeight,
      ),
    );
  }

  // Reusable method for creating media containers
  Widget buildMediaContainer(String label) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppPalette.red.withOpacity(.4),
        borderRadius: BorderRadius.circular(20.r), // Using .r for radius
      ),
      child: Text(label),
    );
  }

  // Reusable method for task cards
  Widget buildTaskCard(String taskTitle, String dueInfo,
      {Color? color = AppPalette.red}) {
    return Container(
      width: 200.w,
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        color: color, // Passed color or default
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildText(taskTitle, 18, fontWeight: FontWeight.bold),
            SizedBox(height: 4.h),
            Text(dueInfo,
                style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }
}
