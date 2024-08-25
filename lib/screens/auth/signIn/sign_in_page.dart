import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/auth_input_field.dart';
import 'package:pix2life/config/common/logo.dart';
import 'package:pix2life/config/common/normal_rounded_button.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/token.services.dart';
import 'package:pix2life/functions/services/user.services.dart';
import 'package:pix2life/screens/account/forgot_password.dart';
import 'package:pix2life/screens/auth/signIn/sign_in_success_page.dart';
import 'package:pix2life/provider/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserSignInPage extends StatefulWidget {
  const UserSignInPage({super.key});

  static void navigateToSignUp(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/SignUp');
  }

  static void navigateToForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserForgotPasswordPage(),
      ),
    );
  }

  @override
  State<UserSignInPage> createState() => _UserSignInPageState();
}

class _UserSignInPageState extends State<UserSignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserService userService = UserService();
  final TokenService tokenService = TokenService();
  final log = logger(UserSignInPage);
  bool _obscureText = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
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
              _buildTitleText(),
              SizedBox(height: 10.h),
              _buildSubtitleText(),
              SizedBox(height: 20.h),
              _buildLogoImage(),
              SizedBox(height: 30.h),
              _buildInputFields(),
              SizedBox(height: 30.h),
              _buildSignInButton(),
              SizedBox(height: 30.h),
              _buildTermsAndConditionsText(),
              SizedBox(height: 40.h),
              _buildSignUpText(),
              SizedBox(height: 20.h),
            ],
          ),
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
          text: 'Welcome back',
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
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'EVERY PICTURE HAS A STORY TO TELL',
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

  Widget _buildLogoImage() {
    return Hero(
      tag: Logo.pix2lifeLogo,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 60.w,
        child: Image.asset(Logo.pix2lifeLogo),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmailField(),
        SizedBox(height: 20.h),
        _buildPasswordField(),
        SizedBox(height: 10.h),
        _buildRememberMeAndForgotPassword(),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email or Phone Number',
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

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
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
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Enter your Password',
            isObscureText: _obscureText,
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: AppPalette.redColor1,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              color: AppPalette.redColor1,
              onPressed: _togglePasswordVisibility,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return SizedBox(
      width: 315.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Checkbox(
            activeColor: AppPalette.redColor1,
            value: _rememberMe,
            onChanged: (bool? value) {
              setState(() {
                _rememberMe = value!;
              });
            },
            semanticLabel: 'Remember me',
          ),
          Text(
            'Keep me signed in',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              color:
                  _rememberMe ? AppPalette.blackColor : AppPalette.greyColor0,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => UserSignInPage.navigateToForgotPassword(context),
            child: Text(
              'Forgot password',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                color: AppPalette.redColor1,
              ),
            ),
          ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          log.i(state.message);
          SuccessSnackBar.show(context: context, message: state.message);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInSuccessPage()),
          );
        } else if (state is AuthFailure) {
          log.i(state.message);
          ErrorSnackBar.show(message: state.message, context: context);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator();
        } else {
          return RoundedButton(
            name: 'Sign In',
            onPressed: () => _onSignInPressed(context),
          );
        }
      },
    );
  }

  void _onSignInPressed(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      LoginEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  Widget _buildTermsAndConditionsText() {
    return Text(
      'Terms and Conditions',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        fontSize: 13.sp,
        color: AppPalette.greyColor0,
      ),
    );
  }

  Widget _buildSignUpText() {
    return GestureDetector(
      onTap: () => UserSignInPage.navigateToSignUp(context),
      child: RichText(
        text: TextSpan(
          text: "Don't have an account?",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: AppPalette.blackColor,
          ),
          children: [
            const TextSpan(text: ' '),
            TextSpan(
              text: 'Sign up here',
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
