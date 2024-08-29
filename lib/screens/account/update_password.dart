import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/input_fields.dart';
import 'package:pix2life/config/common/button_widgets.dart';
import 'package:pix2life/config/common/all_images.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/token.services.dart';
import 'package:pix2life/functions/services/user.services.dart';
import 'package:pix2life/screens/auth/signUp/create_password_success.dart';
import 'package:pix2life/provider/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserUpdatePasswordPage extends StatefulWidget {
  final String userEmail;
  final String resetCode;

  const UserUpdatePasswordPage({
    super.key,
    required this.userEmail,
    required this.resetCode,
  });

  @override
  State<UserUpdatePasswordPage> createState() => _UserUpdatePasswordPageState();
}

class _UserUpdatePasswordPageState extends State<UserUpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final UserService userService = UserService();
  final TokenService tokenService = TokenService();
  final log = logger(UserUpdatePasswordPage);
  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _togglePasswordVisibility2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final password = _passwordController.text.trim();
        final confirmPassword = _confirmPasswordController.text.trim();
        final userData = {
          'email': widget.userEmail,
          'resetCode': widget.resetCode,
          'password': password,
          'confirmPassword': confirmPassword,
        };

        final response = await userService.resetPassword(userData);

        if (!mounted) return;

        context
            .read<AuthBloc>()
            .add(LoginEvent(email: widget.userEmail, password: password));

        _showSuccess(response.message);
      } catch (e) {
        _handleError(e);
      }
    }
  }

  void _showSuccess(String message) {
    setState(() {
      _isLoading = false;
    });

    SuccessSnackBar.show(context: context, message: message);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateAccountSuccessPage(userEmail: widget.userEmail),
      ),
    );
  }

  void _handleError(dynamic error) {
    setState(() {
      _isLoading = false;
    });

    log.e('Error: $error');
    ErrorSnackBar.show(message: '$error', context: context);
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
              SizedBox(height: 30.h),
              _buildWelcomeImage(),
              SizedBox(height: 30.h),
              _buildPasswordInputFields(),
              SizedBox(height: 40.h),
              _buildActionButton(),
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
          text: 'Update password',
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
          text: 'Finishing up',
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

  Widget _buildWelcomeImage() {
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

  Widget _buildPasswordInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPasswordField(),
        SizedBox(height: 20.h),
        _buildConfirmPasswordField(),
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
        SizedBox(height: 20.h),
        SizedBox(
          width: 315.w,
          height: 50.h,
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

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: 315.w,
          height: 50.h,
          child: AuthInputField(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            hintText: 'Confirm Password',
            isObscureText: _obscureText2,
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: AppPalette.redColor1,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText2
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              color: AppPalette.redColor1,
              onPressed: _togglePasswordVisibility2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return _isLoading
        ? const CircularProgressIndicator()
        : RoundedButton(
            name: 'Update Password',
            onPressed: _submitForm,
          );
  }
}
