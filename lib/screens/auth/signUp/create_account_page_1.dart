import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/input_fields.dart';
import 'package:pix2life/config/common/button_widgets.dart';
import 'package:pix2life/config/common/all_images.dart';
import 'package:pix2life/config/common/all_logos.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/services/user.services.dart';
import 'package:pix2life/screens/auth/signUp/create_account_page_2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/logger/logger.dart';

class UserEmailSignUpPage extends StatefulWidget {
  const UserEmailSignUpPage({super.key});

  static void navigateToSignIn(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/SignIn');
  }

  @override
  State<UserEmailSignUpPage> createState() => _UserEmailSignUpPageState();
}

class _UserEmailSignUpPageState extends State<UserEmailSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final UserService userService = UserService();
  final log = logger(UserEmailSignUpPage);
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final userEmail = _emailController.text.trim();
      final userData = {'email': userEmail};

      try {
        final response = await userService.checkUser(userData);
        if (!mounted) return;

        log.i(response);
        setState(() {
          _isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsSignUpPage(userEmail: userEmail),
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        log.e('Error: $e');
        if ('$e' == "type 'String' is not a subtype of type 'int' of 'index'") {
          ErrorSnackBar.show(message: "Service Unavailable", context: context);
        } else {
          ErrorSnackBar.show(message: "$e", context: context);
        }
      }
    }
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
        toolbarHeight: 64,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 1),
      width: double.infinity,
      decoration: _buildBackgroundDecoration(),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 30.h),
              _buildTopBarIndicator(),
              SizedBox(height: 20.h),
              _buildTitle(),
              SizedBox(height: 1.h),
              _buildSubtitle(),
              SizedBox(height: 20.h),
              _buildLogo(),
              SizedBox(height: 10.h),
              _buildWelcomeImage(),
              SizedBox(height: 10.h),
              _buildEmailField(),
              SizedBox(height: 30.h),
              _buildContinueButton(),
              SizedBox(height: 40.h),
              _buildSignInLink(context),
              SizedBox(height: 60.h),
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

  Widget _buildTitle() {
    return SizedBox(
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'Create your account',
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

  Widget _buildSubtitle() {
    return SizedBox(
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'First step to create your account',
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

  Widget _buildWelcomeImage() {
    return Hero(
      tag: AppImage.welcomeImage,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
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

  Widget _buildEmailField() {
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
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10.h),
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

  Widget _buildContinueButton() {
    return SizedBox(
      width: 315.w,
      child: _isLoading
          ? Center(child: const CircularProgressIndicator())
          : RoundedButton(
              name: 'Continue',
              onPressed: _submitForm,
            ),
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return GestureDetector(
      onTap: () => UserEmailSignUpPage.navigateToSignIn(context),
      child: RichText(
        text: TextSpan(
          text: "Already have an account?",
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
