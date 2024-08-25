import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/images.dart';
import 'package:pix2life/config/common/normal_rounded_button.dart';
import 'package:confetti/confetti.dart';
import 'package:pix2life/models/entities/user.model.dart';
import 'package:pix2life/screens/navigation/main_navigation_page.dart';
import 'package:pix2life/provider/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInSuccessPage extends StatefulWidget {
  const SignInSuccessPage({super.key});

  static void navigateToMainPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  @override
  State<SignInSuccessPage> createState() => _SignInSuccessPageState();
}

class _SignInSuccessPageState extends State<SignInSuccessPage> {
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
    final authUser =
        (BlocProvider.of<AuthBloc>(context).state as AuthSuccess).user;

    return Scaffold(
      backgroundColor: AppPalette.blackColor,
      appBar: AppBar(
        backgroundColor: AppPalette.transparent,
        elevation: 0,
        toolbarHeight: 64,
      ),
      body: _buildBody(context, authUser),
    );
  }

  Widget _buildBody(BuildContext context, User authUser) {
    return Container(
      padding: EdgeInsets.all(8.w),
      width: double.infinity,
      height: double.infinity,
      decoration: _buildBackgroundDecoration(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            _buildConfetti(),
            _buildTopBarIndicator(),
            SizedBox(height: 30.h),
            _buildUserEmail(authUser),
            _buildWelcomeImage(),
            SizedBox(height: 20.h),
            _buildSuccessText(),
            SizedBox(height: 30.h),
            _buildInfoText(),
            SizedBox(height: 20.h),
            _buildExploreButton(context),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(37.r),
        topRight: Radius.circular(37.r),
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

  Widget _buildTopBarIndicator() {
    return Container(
      width: 50.w,
      height: 5.h,
      color: AppPalette.blackColor,
    );
  }

  Widget _buildUserEmail(User authUser) {
    return SizedBox(
      width: 357.w,
      child: RichText(
        text: TextSpan(
          text: authUser.email,
          style: TextStyle(
            color: AppPalette.fontTitleBlackColor2,
            fontFamily: 'Poppins',
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildWelcomeImage() {
    return Hero(
      tag: AppImage.welcomeImage,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.h),
        height: 278.h,
        width: 283.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.grey,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.asset(
            AppImage.welcomeImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessText() {
    return Text(
      'Yey! Login Successful',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInfoText() {
    return SizedBox(
      width: 319.w,
      child: RichText(
        text: TextSpan(
          text:
              'You will be moved to the home screen right now. Enjoy the features!',
          style: TextStyle(
            color: AppPalette.greyColor0,
            fontFamily: 'Poppins',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildExploreButton(BuildContext context) {
    return RoundedButton(
      name: "Let's Explore",
      onPressed: () {
        _controller.play();
        SignInSuccessPage.navigateToMainPage(context);
      },
    );
  }
}
