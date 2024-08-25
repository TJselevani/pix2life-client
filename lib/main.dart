import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:pix2life/config/app/app.config.dart';
import 'package:pix2life/config/app/app_theme.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/screens/auth/signUp/create_account_page_1.dart';
import 'package:pix2life/screens/auth/signIn/sign_in_page.dart';
import 'package:pix2life/screens/main/menu/help/index.dart';
import 'package:pix2life/screens/main/menu/notifications/index.dart';
import 'package:pix2life/screens/main/menu/subscriptions/index.dart';
import 'package:pix2life/screens/main/menu/profile/user_profile_page.dart';
import 'package:pix2life/screens/intro/landingPage.dart';
import 'package:pix2life/screens/navigation/main_navigation_page.dart';
import 'package:pix2life/provider/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = '${AppConfig.stripePublishableKey}';
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(),
      child: ScreenUtilInit(
        designSize: Size(375, 804),
        builder: (context, child) {
          return MyApp();
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final log = logger(MyApp);
    log.i('Client :: Running');
    return MaterialApp(
      title: 'pix2life',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/SignIn': (context) => UserSignInPage(),
        '/SignUp': (context) => UserEmailSignUpPage(),
        '/Home': (context) => MainPage(),
        '/Profile': (context) => UserProfilePage(),
        '/Subscriptions': (context) => SubscriptionsPage(),
        '/Notifications': (context) => NotificationsPage(),
        '/HelpCenter': (context) => HelpCenterPage(),
      },
    );
  }
}

// flutter pub run flutter_native_splash:create
// flutter pub run flutter_launcher_icons:main

// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/TJselevani/pix2life-client.git
// git push -u origin main