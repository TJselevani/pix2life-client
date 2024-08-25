import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/images.dart';
import 'package:pix2life/config/common/normal_rounded_button.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/provider/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static void routeSignIn(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/SignIn');
  }

  static void routeHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/Home');
  }

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
      appBar: AppBar(
        backgroundColor: AppPalette.whiteColor,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: _buildBackgroundDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.h),
            _buildTopBarIndicator(),
            SizedBox(height: 70.h),
            _buildPageView(context),
            SizedBox(height: 10.h),
            _buildPageIndicator(),
            SizedBox(height: 20.h),
            _buildTitleText(),
            SizedBox(height: 10.h),
            _buildSubtitleText(),
            SizedBox(height: 20.h),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  // Private methods to structure the code better
  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(37.r),
        topRight: Radius.circular(37.r),
      ),
      gradient: LinearGradient(
        colors: [AppPalette.blackColor, AppPalette.blackColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildTopBarIndicator() {
    return Container(
      width: 50.w,
      height: 5.h,
      color: AppPalette.whiteColor,
    );
  }

  Widget _buildPageView(BuildContext context) {
    return Container(
      height: 307.h,
      width: 285.w,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemCount: 4,
        itemBuilder: (context, index) {
          return _buildPageViewItem(context, index);
        },
      ),
    );
  }

  Widget _buildPageViewItem(BuildContext context, int index) {
    final double leftPercent = index * 0.25;
    final double rightPercent = (index + 1) * 0.25;

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppPalette.redColor1,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: OverflowBox(
                maxWidth: MediaQuery.of(context).size.width,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  alignment: Alignment(-1.0 + 2.5 * leftPercent, rightPercent),
                  child: Image.asset(
                    AppImage.welcomeImage,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          width: 8.w,
          height: 8.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? AppPalette.redColor1
                : AppPalette.redColor.withOpacity(0.3),
          ),
        );
      }),
    );
  }

  Widget _buildTitleText() {
    return SizedBox(
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'PIX2LIFE',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 54.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitleText() {
    return SizedBox(
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'Bringing your memories to life',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          SuccessSnackBar.show(context: context, message: state.message);
          WelcomePage.routeHome(context);
        } else if (state is Unauthenticated) {
          WelcomePage.routeSignIn(context);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Container(
            margin: EdgeInsets.only(top: 30.h),
            child: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: AppPalette.redColor1,
                size: 30.sp,
              ),
            ),
          );
        } else {
          return SizedBox(
            width: 200.w,
            height: 65.h,
            child: RoundedButton(
              name: 'Get Started',
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(CheckAuthStatusEvent());
              },
            ),
          );
        }
      },
    );
  }
}
