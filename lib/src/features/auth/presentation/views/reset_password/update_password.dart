import 'package:flutter/material.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_round_button.dart';

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
  // final UserService userService = UserService();
  // final TokenService tokenService = TokenService();
  final log = createLogger(UserUpdatePasswordPage);
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
        // ignore: unused_local_variable
        final userData = {
          'email': widget.userEmail,
          'resetCode': widget.resetCode,
          'password': password,
          'confirmPassword': confirmPassword,
        };

        // final response = await userService.resetPassword(userData);

        if (!mounted) return;

        // context
        //     .read<AuthBloc>()
        //     .add(LoginEvent(email: widget.userEmail, password: password));

        // _showSuccess(response.message);
      } catch (e) {
        _handleError(e);
      }
    }
  }

  void _handleError(dynamic error) {
    setState(() {
      _isLoading = false;
    });

    log.e('Error: $error');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.primaryBlack,
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
      color: AppPalette.primaryBlack,
    );
  }

  Widget _buildTitleText() {
    return SizedBox(
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'Update password',
          style: TextStyle(
            color: AppPalette.fontBlack,
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
            color: AppPalette.fontGrey,
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
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: AppPalette.red,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              color: AppPalette.red,
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
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              size: 20,
              color: AppPalette.red,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText2
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              color: AppPalette.red,
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
