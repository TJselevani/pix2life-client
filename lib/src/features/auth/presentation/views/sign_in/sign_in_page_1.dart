import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/features/auth/presentation/views/sign_in/sign_in_page_2.0.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_round_button.dart';
import 'package:provider/provider.dart';

class UserSignInPage extends StatefulWidget {
  const UserSignInPage({super.key});

  static void routeToSignUpPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/SignUp');
  }

  static void routeToSuccessPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInSuccessPage()),
    );
  }

  static void routeToForgotPasswordPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/Reset');
  }

  @override
  State<UserSignInPage> createState() => _UserSignInPageState();
}

class _UserSignInPageState extends State<UserSignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final logger = createLogger(UserSignInPage);
  bool _obscureText = true;
  bool _rememberMe = false;
  late bool isDarkMode;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

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
        child: Column(
          children: [
            SizedBox(height: 30.h),
            _buildTopBarIndicator(),
            SizedBox(height: 20.h),
            _buildTitleText(),
            SizedBox(height: 10.h),
            _buildSubtitleText(),
            SizedBox(height: 20.h),
            _buildLogoImage(context),
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
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      color:
          isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
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
      color: isDarkMode ? AppPalette.primaryWhite : AppPalette.primaryBlack,
    );
  }

  Widget _buildTitleText() {
    return SizedBox(
      width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'Welcome back',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? null : AppPalette.primaryBlack,
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

  Widget _buildLogoImage(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.of(context).pushReplacementNamed('/');
      },
      child: Hero(
        tag: AppLogo.pix2lifeLogo,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 60.w,
          child: Image.asset(AppLogo.pix2lifeLogo),
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmailField(),
          SizedBox(height: 20.h),
          _buildPasswordField(),
          SizedBox(height: 10.h),
          _buildRememberMeAndForgotPassword(),
        ],
      ),
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
            isEmail: true,
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

  Widget _buildRememberMeAndForgotPassword() {
    return SizedBox(
      width: 315.w,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.w, 0.h, 10.w, 0.h),
        child: Row(
          children: [
            Checkbox(
              activeColor: AppPalette.red,
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
                fontSize: 11.sp,
                color: _rememberMe
                    ? AppPalette.primaryBlack
                    : AppPalette.primaryGrey,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => UserSignInPage.routeToForgotPasswordPage(context),
              child: Text(
                'Forgot password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: AppPalette.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedUser) {
          logger.i(state.message);
          SuccessSnackBar.show(context: context, message: state.message);
          UserSignInPage.routeToSuccessPage(context);
        } else if (state is AuthFailure) {
          logger.i(state.message);
          ErrorSnackBar.show(message: state.message, context: context);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return RoundedButton(
            name: 'Sign In',
            onPressed: () => {
              if (_formKey.currentState!.validate())
                {
                  _onSignInPressed(context),
                }
            },
          );
        }
      },
    );
  }

  void _onSignInPressed(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(
      AuthSignInEvent(
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
        color: isDarkMode ? null : AppPalette.primaryGrey,
      ),
    );
  }

  Widget _buildSignUpText() {
    return GestureDetector(
      onTap: () => UserSignInPage.routeToSignUpPage(context),
      child: RichText(
        text: TextSpan(
          text: "Don't have an account?",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: isDarkMode ? null : AppPalette.primaryBlack,
          ),
          children: [
            const TextSpan(text: ' '),
            TextSpan(
              text: 'Sign up here',
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
