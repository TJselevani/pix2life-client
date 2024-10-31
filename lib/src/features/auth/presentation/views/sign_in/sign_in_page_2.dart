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

class SignInSuccessPage extends StatefulWidget {
  const SignInSuccessPage({super.key});

  static void routeToHomePage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/Home');
  }

  @override
  State<SignInSuccessPage> createState() => _SignInSuccessPageState();
}

class _SignInSuccessPageState extends State<SignInSuccessPage> {
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
            _buildExploreButton(context),
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
            color: AppPalette.primaryGrey,
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
        SignInSuccessPage.routeToHomePage(context);
      },
    );
  }
}
