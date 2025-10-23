import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_round_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static void routeToSignInPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/SignIn');
  }

  static void routeToHomePage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/Home');
  }

  static void routeToStartPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/Start');
  }

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add((AuthIsUserLoggedInEvent()));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50.h,
      ),
      body: Container(
        width: double.infinity,
        decoration: _buildBackgroundDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 1.h),
            _buildTopBarIndicator(),
            SizedBox(height: 40.h),
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
      image: const DecorationImage(
          image: AssetImage(
            AppImage.welcomeImage3,
          ),
          fit: BoxFit.cover),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(37.r),
        topRight: Radius.circular(37.r),
      ),
      gradient: const LinearGradient(
        colors: [AppPalette.primaryBlack, AppPalette.primaryBlack],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildTopBarIndicator() {
    return Container(
      width: 50.w,
      height: 5.h,
      color: AppPalette.primaryWhite,
    );
  }

  Widget _buildPageView(BuildContext context) {
    return SizedBox(
      height: 300.h,
      width: 300.w,
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

    return Padding(
      padding: const EdgeInsets.all(8.0), // Add padding to avoid edge overflow
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppPalette.red,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Use LayoutBuilder to get the actual width/height constraints
                  Positioned.fill(
                    child: OverflowBox(
                      maxWidth: constraints.maxWidth, // Use parent constraints
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        widthFactor: 1.0, // Keep full width
                        alignment:
                            Alignment(-1.0 + 2.5 * leftPercent, rightPercent),
                        child: Image.asset(
                          AppImage.welcomeImage,
                          fit: BoxFit.cover, // Adjust this to avoid overflow
                          width: constraints.maxWidth, // Use constraints
                          height: constraints.maxHeight, // Use constraints
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
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
                ? AppPalette.red
                : AppPalette.red.withOpacity(0.3),
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
        if (state is AuthLoggedInUser) {
          SuccessSnackBar.show(context: context, message: state.message);
          // WelcomePage.routeToStartPage(context);
        } else if (state is AuthUnauthenticated) {
          ErrorSnackBar.show(context: context, message: state.message);
        } else if (state is AuthFailure) {
          ErrorSnackBar.show(context: context, message: state.message);
          WelcomePage.routeToSignInPage(context);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Container(
            margin: EdgeInsets.only(top: 30.h),
            child: Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: AppPalette.red,
                size: 30.sp,
              ),
            ),
          );
        } else {
          return SizedBox(
            width: 200.w,
            height: 65.h,
            child: _isLoading
                ? Center(
                    child: LoadingAnimationWidget.fourRotatingDots(
                      color: AppPalette.red,
                      size: 30.sp,
                    ),
                  )
                : RoundedButton(
                    name: 'Get Started',
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      final currentState = context.read<AuthBloc>().state;
                      Timer(Duration(seconds: 1), () {
                        if (currentState is AuthLoggedInUser ||
                            currentState is AuthenticatedUser) {
                          WelcomePage.routeToStartPage(context);
                        } else if (currentState is AuthUnauthenticated) {
                          WelcomePage.routeToSignInPage(context);
                        } else {
                          WelcomePage.routeToSignInPage(context);
                        }
                      });
                    },
                  ),
          );
        }
      },
    );
  }
}
