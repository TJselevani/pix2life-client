import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_provider.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_round_button.dart';
import 'package:provider/provider.dart';

class WelcomeBack extends StatefulWidget {
  const WelcomeBack({super.key});

  static void routeToHomePage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/Home');
  }

  static void routeToImageMatching(BuildContext context) {
    Navigator.pushNamed(context, '/Matching');
  }

  @override
  State<WelcomeBack> createState() => _WelcomeBackState();
}

class _WelcomeBackState extends State<WelcomeBack> {
  late final ConfettiController _controller;
  User? authUser;
  bool isDarkMode = false;

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
    final userProvider = Provider.of<MyUserProvider>(context);
    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    authUser = userProvider.user;

    return Scaffold(
      backgroundColor: AppPalette.primaryBlack,
      appBar: AppBar(
        backgroundColor: AppPalette.primaryBlack,
        elevation: 0,
        toolbarHeight: 64,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
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
            _buildUserEmail(),
            SizedBox(height: 20.h),
            _buildWelcomeImage(),
            SizedBox(height: 20.h),
            _buildSuccessText(),
            SizedBox(height: 30.h),
            _buildInfoText(),
            SizedBox(height: 20.h),
            _buildButtonRow(context),
            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      color:
          isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
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
          colors: const [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            AppPalette.red,
          ],
        ),
      ),
    );
  }

  Widget _buildTopBarIndicator() {
    return Container(
      width: 50.w,
      height: 5.h,
      color: isDarkMode ? AppPalette.primaryWhite : AppPalette.primaryBlack,
    );
  }

  Widget _buildUserEmail() {
    return SizedBox(
      width: 357.w,
      child: RichText(
        text: TextSpan(
          text: authUser != null && authUser!.email.isNotEmpty
              ? authUser!.email
              : '',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode ? AppPalette.primaryWhite : AppPalette.primaryBlack,
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
      'Welcome Back!',
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
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              text: 'What do you want to do?',
              style: TextStyle(
                color: AppPalette.primaryGrey,
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          RichText(
            text: TextSpan(
                text: 'MANAGE: ',
                style: TextStyle(
                  color: isDarkMode
                      ? AppPalette.primaryWhite
                      : AppPalette.primaryBlack,
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                      text: 'Create/edit gallery, account, etc.',
                      style: TextStyle(
                        color: AppPalette.primaryGrey,
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ))
                ]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          RichText(
            text: TextSpan(
                text: 'MATCH: ',
                style: TextStyle(
                  color: isDarkMode
                      ? AppPalette.primaryWhite
                      : AppPalette.primaryBlack,
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                      text: 'Take a photo and view the gallery',
                      style: TextStyle(
                        color: AppPalette.primaryGrey,
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ))
                ]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: RoundedButton(
              name: "MANAGE",
              onPressed: () {
                _controller.play();
                WelcomeBack.routeToHomePage(context);
              },
            ),
          ),
          SizedBox(width: 40.w),
          Flexible(
            child: RoundedButton(
              name: "MATCH",
              onPressed: () {
                _controller.play();
                WelcomeBack.routeToImageMatching(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
