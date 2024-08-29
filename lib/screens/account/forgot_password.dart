import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/input_fields.dart';
import 'package:pix2life/config/common/button_widgets.dart';
import 'package:pix2life/config/common/all_images.dart';
import 'package:pix2life/config/common/all_logos.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/user.services.dart';
import 'package:pix2life/screens/account/reset_code.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserForgotPasswordPage extends StatefulWidget {
  static void route(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/SignIn');
  }

  const UserForgotPasswordPage({super.key});

  @override
  State<UserForgotPasswordPage> createState() => _UserForgotPasswordPageState();
}

class _UserForgotPasswordPageState extends State<UserForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final UserService userService = UserService();
  final log = logger(UserForgotPasswordPage);
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userEmail = _emailController.text.trim();

      try {
        final response = await userService.forgotPassword({'email': userEmail});
        if (!mounted) return;

        log.i(response);
        _showSuccess(response.message, userEmail);
      } catch (e) {
        _handleError(e);
      }
    }
  }

  void _showSuccess(String message, String userEmail) {
    setState(() {
      _isLoading = false;
    });

    SuccessSnackBar.show(message: message, context: context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserResetCodePage(userEmail: userEmail),
      ),
    );
  }

  void _handleError(dynamic error) {
    setState(() {
      _isLoading = false;
    });

    log.e('Error: $error');
    ErrorSnackBar.show(message: "$error", context: context);
  }

  @override
  void dispose() {
    _emailController.dispose();
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
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      width: double.infinity,
      height: double.infinity,
      decoration: _buildBackgroundDecoration(),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30.h),
              _buildTopBarIndicator(),
              SizedBox(height: 20.h),
              _buildTitleText(),
              SizedBox(height: 10.h),
              _buildSubtitleText(),
              SizedBox(height: 20.h),
              _buildLogo(),
              SizedBox(height: 10.h),
              _buildWelcomeImage(context),
              SizedBox(height: 40.h),
              _buildEmailInputField(),
              SizedBox(height: 50.h),
              _buildActionButton(),
              SizedBox(height: 40.h),
              _buildGoBackText(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(37),
        topRight: Radius.circular(37),
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

  Widget _buildTitleText() {
    return SizedBox(
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'Retrieve your account',
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

  Widget _buildSubtitleText() {
    return SizedBox(
      // width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'Use your email to recover your account',
          style: TextStyle(
            color: AppPalette.fontTextGreyColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: Logo.pix2lifeLogo,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 60.w,
        child: Image.asset(Logo.pix2lifeLogo),
      ),
    );
  }

  Widget _buildWelcomeImage(BuildContext context) {
    return Hero(
      tag: AppImage.welcomeImage,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        width: 333.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            AppImage.welcomeImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: 315.w,
          child: AuthInputField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Enter your Email',
            prefixIcon: Icon(
              Icons.email_outlined,
              size: 20,
              color: AppPalette.redColor1,
            ),
            suffixIcon: null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return _isLoading
        ? const CircularProgressIndicator()
        : RoundedButton(
            name: 'Continue',
            onPressed: _submitForm,
          );
  }

  Widget _buildGoBackText() {
    return GestureDetector(
      onTap: () => UserForgotPasswordPage.route(context),
      child: RichText(
        text: TextSpan(
          text: "Go back?",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: AppPalette.blackColor,
          ),
          children: [
            const TextSpan(text: ' '),
            TextSpan(
              text: 'Sign In here',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: AppPalette.redColor1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
