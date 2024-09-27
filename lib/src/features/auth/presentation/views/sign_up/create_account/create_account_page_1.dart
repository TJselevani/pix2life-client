import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/features/auth/presentation/views/sign_up/create_account/create_account_page_2.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_round_button.dart';

class UserEmailSignUpPage extends StatefulWidget {
  const UserEmailSignUpPage({super.key});

  static void routeToSignInPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/SignIn');
  }

  static void routeToSignUpPage(BuildContext context, String userEmail) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => UserDetailsSignUpPage(
                userEmail: userEmail,
              )),
    );
  }

  @override
  State<UserEmailSignUpPage> createState() => _UserEmailSignUpPageState();
}

class _UserEmailSignUpPageState extends State<UserEmailSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final logger = createLogger(UserEmailSignUpPage);

  // Future<void> _submitForm() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     setState(() {
  //       _isLoading = true;
  //     });

  //     final userEmail = _emailController.text.trim();
  //     final userData = {'email': userEmail};

  //     try {
  //       final response = await userService.checkUser(userData);
  //       if (!mounted) return;

  //       logger.i(response);
  //       setState(() {
  //         _isLoading = false;
  //       });

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => UserDetailsSignUpPage(userEmail: userEmail),
  //         ),
  //       );
  //     } catch (e) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //       logger.e('Error: $e');
  //       if ('$e' == "type 'String' is not a subtype of type 'int' of 'index'") {
  //         ErrorSnackBar.show(message: "Service Unavailable", context: context);
  //       } else {
  //         ErrorSnackBar.show(message: "$e", context: context);
  //       }
  //     }
  //   }
  // }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.primaryBlack,
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
      color: AppPalette.primaryBlack,
    );
  }

  Widget _buildTitle() {
    return SizedBox(
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'Create your account',
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

  Widget _buildSubtitle() {
    return SizedBox(
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'First step to create your account',
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

  Widget _buildContinueButton() {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthSuccess) {
        SuccessSnackBar.show(context: context, message: state.message);
        UserEmailSignUpPage.routeToSignUpPage(
            context, _emailController.text.trim());
      } else if (state is AuthFailure) {
        ErrorSnackBar.show(context: context, message: state.message);
      }
    }, builder: (context, state) {
      if (state is AuthLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return SizedBox(
          width: 315.w,
          child: RoundedButton(
              name: 'Continue',
              onPressed: () {
                // _submitForm;
                if (_formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                        AuthCheckAccountEvent(
                          email: _emailController.text.trim(),
                        ),
                      );
                }
              }),
        );
      }
    });
  }

  Widget _buildSignInLink(BuildContext context) {
    return GestureDetector(
      onTap: () => UserEmailSignUpPage.routeToSignInPage(context),
      child: RichText(
        text: TextSpan(
          text: "Already have an account?",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: AppPalette.primaryBlack,
          ),
          children: [
            const TextSpan(text: ' '),
            TextSpan(
              text: 'Sign In here',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: AppPalette.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
