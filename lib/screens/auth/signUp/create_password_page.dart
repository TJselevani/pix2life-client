import 'package:flutter/material.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/auth_input_field.dart';
import 'package:pix2life/config/common/images.dart';
import 'package:pix2life/config/common/normal_rounded_button.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:pix2life/functions/notifications/success.dart';
import 'package:pix2life/functions/services/token.services.dart';
import 'package:pix2life/functions/services/user.services.dart';
import 'package:pix2life/screens/auth/signUp/create_password_success.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserCreatePasswordPage extends StatefulWidget {
  const UserCreatePasswordPage({super.key});

  @override
  _UserCreatePasswordPageState createState() => _UserCreatePasswordPageState();
}

class _UserCreatePasswordPageState extends State<UserCreatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserService userService = UserService();
  final TokenService tokenService = TokenService();
  final log = logger(UserCreatePasswordPage);
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
        final response =
            await userService.createPassword(password, confirmPassword);

        if (!mounted) return; // Check if the widget is still mounted

        setState(() {
          _isLoading = false;
        });

        SuccessSnackBar.show(
            context: context,
            message: '${response.userEmail} ${response.message}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CreateAccountSuccessPage(userEmail: response.userEmail),
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        log.e('Error: $e');
        ErrorSnackBar.show(message: '$e', context: context);
      }
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTopBar(),
                _buildTitle(),
                _buildSubtitle(),
                _buildImage(),
                _buildPasswordFields(),
                _buildSubmitButton(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      child: Container(
        width: 50.w,
        height: 5.h,
        color: AppPalette.blackColor,
      ),
    );
  }

  Widget _buildTitle() {
    return SizedBox(
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'Create password',
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

  Widget _buildImage() {
    return Hero(
      tag: AppImage.welcomeImage,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        width: 333.w,
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

  Widget _buildPasswordFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPasswordField('Password', _passwordController, _obscureText,
            _togglePasswordVisibility),
        SizedBox(height: 25.h),
        _buildPasswordField('Confirm Password', _confirmPasswordController,
            _obscureText2, _togglePasswordVisibility2),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool isObscure, VoidCallback toggleVisibility) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          width: 315.w,
          height: 50.h,
          child: AuthInputField(
            controller: controller,
            labelText: label,
            hintText: 'Enter your $label',
            isObscureText: isObscure,
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              size: 20.sp,
              color: AppPalette.redColor1,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              color: AppPalette.redColor1,
              onPressed: toggleVisibility,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return _isLoading
        ? const CircularProgressIndicator()
        : RoundedButton(
            name: 'Create Password',
            onPressed: _submitForm,
          );
  }
}
