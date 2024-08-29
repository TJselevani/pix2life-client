import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/button_widgets.dart';
import 'package:pix2life/config/common/all_images.dart';
import 'package:confetti/confetti.dart';
import 'package:pix2life/screens/billet/upload_profile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccountSuccessPage extends StatefulWidget {
  static Route(context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UploadProfilePicPage()),
    );
  }

  final String userEmail;

  const CreateAccountSuccessPage({super.key, required this.userEmail});

  @override
  _CreateAccountSuccessPageState createState() =>
      _CreateAccountSuccessPageState();
}

class _CreateAccountSuccessPageState extends State<CreateAccountSuccessPage> {
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 2));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.blackColor,
      appBar: AppBar(
        backgroundColor: AppPalette.transparent,
        elevation: 0,
        toolbarHeight: 64.h,
      ),
      body: Container(
        padding: EdgeInsets.all(8.w), // Responsive padding
        margin: EdgeInsets.symmetric(horizontal: 1.w), // Responsive margin
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(37.w),
            topRight: Radius.circular(37.w),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.h),
              _buildConfetti(),
              _buildTopBar(),
              SizedBox(height: 10.h),
              _buildSuccessMessage(),
              SizedBox(height: 10.h),
              _buildImage(),
              SizedBox(height: 10.h),
              _buildButton(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfetti() {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _controller,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: true,
          colors: [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            AppPalette.redColor1,
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: 50.w,
      height: 5.h,
      color: AppPalette.blackColor,
    );
  }

  Widget _buildSuccessMessage() {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: widget.userEmail,
            style: TextStyle(
              color: AppPalette.fontTitleBlackColor2,
              fontFamily: 'Poppins',
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        RichText(
          text: TextSpan(
            text: 'Yey! Account setup Successful',
            style: TextStyle(
              color: AppPalette.fontTitleBlackColor2,
              fontFamily: 'Poppins',
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: 319.w,
          child: RichText(
            text: TextSpan(
              text:
                  'You will be moved to home screen momentarily. Enjoy the features!',
              style: TextStyle(
                color: AppPalette.greyColor0,
                fontFamily: 'Poppins',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: AppImage.welcomeImage,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        width: 330.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.w),
          color: Colors.grey,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.w),
          child: Image.asset(
            AppImage.welcomeImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.only(top: 60.h, bottom: 80.h),
      child: RoundedButton(
        name: "Let's Explore",
        onPressed: () {
          _controller.play();
          CreateAccountSuccessPage.Route(context);
        },
      ),
    );
  }
}
