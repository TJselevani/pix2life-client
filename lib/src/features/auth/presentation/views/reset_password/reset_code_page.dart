import 'package:flutter/material.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_round_button.dart';

class UserResetCodePage extends StatefulWidget {
  final String userEmail;

  static void route(BuildContext context) {
    Navigator.pushReplacementNamed(context, '');
  }

  const UserResetCodePage({super.key, required this.userEmail});

  @override
  State<UserResetCodePage> createState() => _UserResetCodePageState();
}

class _UserResetCodePageState extends State<UserResetCodePage> {
  final _formKey = GlobalKey<FormState>();
  final _resetCodeController = TextEditingController();
  final log = createLogger(UserResetCodePage);
  bool _isLoading = false;
  late bool isDarkMode;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final resetCode = _resetCodeController.text.trim();
      // ignore: unused_local_variable
      final userData = {'email': widget.userEmail, 'resetCode': resetCode};

      try {
        // final response = await userService.verifyResetCode(userData);

        if (!mounted) return;

        // _showSuccess(response.message, resetCode);
      } catch (e) {
        _handleError(e);
      }
    }
  }

  // void _showSuccess(String message, String resetCode) {
  //   setState(() {
  //     _isLoading = false;
  //   });

  //   SuccessSnackBar.show(message: message, context: context);

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => UserUpdatePasswordPage(
  //         resetCode: resetCode,
  //         userEmail: widget.userEmail,
  //       ),
  //     ),
  //   );
  // }

  void _handleError(dynamic error) {
    setState(() {
      _isLoading = false;
    });

    log.e('Error: $error');
  }

  @override
  void dispose() {
    _resetCodeController.dispose();
    super.dispose();
  }

  // isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
  //                (themeProvider.themeMode == ThemeMode.system &&
  //                 MediaQuery.of(context).platformBrightness == Brightness.dark);


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
              SizedBox(height: 40.h),
              _buildTitleText(),
              SizedBox(height: 20.h),
              _buildSubtitleText(),
              SizedBox(height: 20.h),
              _buildLogo(),
              SizedBox(height: 10.h),
              _buildWelcomeImage(context),
              SizedBox(height: 40.h),
              _buildResetCodeInputField(),
              SizedBox(height: 50.h),
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
          text: 'Reset your Account',
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
          text: 'Enter the reset code sent to your email address',
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

  Widget _buildLogo() {
    return Hero(
      tag: AppLogo.pix2lifeLogo,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 60.w,
        child: Image.asset(AppLogo.pix2lifeLogo),
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

  Widget _buildResetCodeInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reset Code',
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
            controller: _resetCodeController,
            labelText: 'Code',
            hintText: 'Enter your verification Code',
            prefixIcon: const Icon(
              Icons.email_outlined,
              size: 20,
              color: AppPalette.red,
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
}
