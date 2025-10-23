import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/constants.dart';
import 'package:pix2life/core/utils/alerts/success.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_round_button.dart';
import 'package:provider/provider.dart';

class UserForgotPasswordPage extends StatefulWidget {
  static void routeToSignIn(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/SignIn');
  }

  const UserForgotPasswordPage({super.key});

  @override
  State<UserForgotPasswordPage> createState() => _UserForgotPasswordPageState();
}

class _UserForgotPasswordPageState extends State<UserForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final log = createLogger(UserForgotPasswordPage);
  late bool isDarkMode;

  @override
  void dispose() {
    _emailController.dispose();
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
        backgroundColor: AppPalette.primaryBlack,
        elevation: 0,
        toolbarHeight: 64.h,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
            _buildLogo(),
            SizedBox(height: 10.h),
            _buildWelcomeImage(context),
            SizedBox(height: 40.h),
            _buildEmailInputField(),
            SizedBox(height: 50.h),
            _buildActionButton(),
            SizedBox(height: 40.h),
            _buildGoBackText(),
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
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(37),
        topRight: Radius.circular(37),
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
          text: 'Retrieve your account',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color:
                isDarkMode ? AppPalette.primaryWhite : AppPalette.primaryBlack,
          ),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitleText() {
    return SizedBox(
      // width: 247.w,
      child: RichText(
        text: TextSpan(
          text: 'Use your email to recover your account',
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

  Widget _buildEmailInputField() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
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
      ),
    );
  }

  Widget _buildActionButton() {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthSuccess) {
        SuccessSnackBar.show(context: context, message: state.message);
        UserForgotPasswordPage.routeToSignIn(context);
      }

      if (state is AuthFailure) {
        SuccessSnackBar.show(context: context, message: state.message);
      }
    }, builder: (context, state) {
      if (state is AuthLoading) {
        return const CircularProgressIndicator();
      } else {
        return RoundedButton(
          name: 'Continue',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // BlocProvider.of<AuthBloc>(context).add();
            }
          },
        );
      }
    });
  }

  Widget _buildGoBackText() {
    return GestureDetector(
      onTap: () => UserForgotPasswordPage.routeToSignIn(context),
      child: RichText(
        text: TextSpan(
          text: "Go back?",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: isDarkMode ? null : AppPalette.primaryBlack,
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
