import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_config.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/auth/presentation/views/sign_up/create_password/create_password_page_2.dart';
import 'package:pix2life/src/auth/presentation/widgets/auth_input_field.dart';
import 'package:pix2life/src/auth/presentation/widgets/auth_round_button.dart';

class UserCreatePasswordPage extends StatefulWidget {
  const UserCreatePasswordPage({super.key});

  static void routeToSuccessPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CreateAccountSuccessPage()),
    );
  }

  @override
  _UserCreatePasswordPageState createState() => _UserCreatePasswordPageState();
}

class _UserCreatePasswordPageState extends State<UserCreatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _confirmPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final logger = createLogger(UserCreatePasswordPage);
  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _isLoading = false;

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

  // Future<void> _submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     try {
  //       final password = _passwordController.text.trim();
  //       final confirmPassword = _confirmPasswordController.text.trim();
  //       final response =
  //           await userService.createPassword(password, confirmPassword);

  //       if (!mounted) return; // Check if the widget is still mounted

  //       setState(() {
  //         _isLoading = false;
  //       });

  //       logger.i('User ::: !!!!! ${response.userEmail}');
  //       logger.i(response.message);

  //       SuccessSnackBar.show(
  //           context: context,
  //           message: '${response.userEmail} ${response.message}');
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) =>
  //               CreateAccountSuccessPage(userEmail: response.userEmail),
  //         ),
  //       );
  //     } catch (e) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       logger.e('Error: $e');
  //       ErrorSnackBar.show(message: '$e', context: context);
  //     }
  //   }
  // }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                SizedBox(height: 30.h),
                _buildTopBar(),
                SizedBox(height: 20.h),
                _buildTitle(),
                SizedBox(height: 10.h),
                _buildSubtitle(),
                SizedBox(height: 20.h),
                _buildImage(),
                SizedBox(height: 30.h),
                _buildPasswordFields(),
                SizedBox(height: 30.h),
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
    return BlocConsumer(
      listener: (context, state) {
        if (state is AuthFailure) {
          ErrorSnackBar.show(context: context, message: state.message);
        }

        if (state is Authenticated) {
          SuccessSnackBar.show(context: context, message: state.message);
          UserCreatePasswordPage.routeToSuccessPage(context);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator();
        } else {
          return RoundedButton(
            name: 'Create Password',
            onPressed: () {
              // _submitForm;
              if (_formKey.currentState!.validate()) {
                BlocProvider.of<AuthBloc>(context).add(
                  AuthCreatePasswordEvent(
                    password: _passwordController.text.trim(),
                    confirmPassword: _confirmPasswordController.text.trim(),
                  ),
                );
              }
            },
          );
        }
        ;
      },
    );
  }
}
