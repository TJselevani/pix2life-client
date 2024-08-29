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
import 'package:pix2life/screens/auth/signUp/create_password_page.dart';
import 'package:pix2life/provider/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDetailsSignUpPage extends StatefulWidget {
  final String? userEmail;

  const UserDetailsSignUpPage({super.key, this.userEmail});

  @override
  State<UserDetailsSignUpPage> createState() => _UserDetailsSignUpPageState();
}

class _UserDetailsSignUpPageState extends State<UserDetailsSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _addressController = TextEditingController();
  final _postCodeController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final UserService userService = UserService();
  final TokenService tokenService = TokenService();
  final log = logger(UserDetailsSignUpPage);

  @override
  void dispose() {
    _usernameController.dispose();
    _addressController.dispose();
    _postCodeController.dispose();
    _phoneNumberController.dispose();
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
      body: Container(
        padding: EdgeInsets.all(8.w), // Responsive padding
        margin: EdgeInsets.symmetric(horizontal: 1.w), // Responsive margin
        width: double.infinity,
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
                _buildImage(),
                SizedBox(height: 20.h),
                _buildInputFields(),
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
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        width: 50.w,
        height: 5.h,
        color: AppPalette.blackColor,
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        SizedBox(
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
        ),
        SizedBox(height: 1.h),
        SizedBox(
          width: 247.w,
          child: RichText(
            text: TextSpan(
              text: 'Next step to create your account',
              style: TextStyle(
                color: AppPalette.fontTextGreyColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Poppins',
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: AppImage.welcomeImage,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        height: 178.h,
        width: 330.w,
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

  Widget _buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
            'Username', _usernameController, Icons.account_circle_outlined),
        _buildInputField(
            'Address', _addressController, Icons.add_business_sharp),
        _buildInputField(
            'Phone Number', _phoneNumberController, Icons.add_call),
        _buildInputField('City or Area Code', _postCodeController,
            Icons.location_city_outlined),
      ],
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, IconData icon) {
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
        SizedBox(height: 10.h),
        SizedBox(
          width: 315.w,
          child: AuthInputField(
            controller: controller,
            labelText: label,
            hintText: 'Enter your $label',
            prefixIcon: Icon(
              icon,
              size: 20.sp,
              color: AppPalette.redColor1,
            ),
            suffixIcon: null,
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          SuccessSnackBar.show(context: context, message: state.message);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserCreatePasswordPage()),
          );
        } else if (state is AuthFailure) {
          ErrorSnackBar.show(message: state.message, context: context);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CircularProgressIndicator();
        } else {
          return RoundedButton(
            name: 'Continue',
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(
                SignUpEvent(
                  username: _usernameController.text.trim(),
                  email: widget.userEmail!,
                  address: _addressController.text.trim(),
                  phoneNumber: _phoneNumberController.text.trim(),
                  postCode: _postCodeController.text.trim(),
                ),
              );
            },
          );
        }
      },
    );
  }
}
