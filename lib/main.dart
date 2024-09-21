import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_theme.dart';
import 'package:pix2life/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/auth/presentation/views/intro/landing_page.dart';
import 'package:pix2life/src/auth/presentation/views/sign_in/sign_in_page_1.dart';
import 'package:pix2life/src/auth/presentation/views/sign_up/create_account/create_account_page_1.dart';
import 'package:pix2life/src/auth/presentation/views/sign_up/create_password/create_password_page_1.dart';
import 'package:pix2life/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    ScreenUtilInit(
      designSize: Size(375, 804),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (context) => sl<AuthBloc>())],
          child: const MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final log = createLogger(MyApp);
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
        '/Home': (context) => MyWidget(),
        '/Password': (context) => UserCreatePasswordPage(),
        '/Avatar': (context) => MyWidget(),
      },
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Center(
              child: Text('MAinPage'),
            )
          ],
        ),
      ),
    );
  }
}


// lib/
// ├── core/
// │   ├── error/
// │   ├── usecases/
// │   ├── utils/
// │   └── constants.dart
// ├── features/
// │   ├── feature_name/
// │   │   ├── data/
// │   │   │   ├── models/
// │   │   │   ├── repositories/
// │   │   │   └── data_sources/
// │   │   ├── domain/
// │   │   │   ├── entities/
// │   │   │   ├── repositories/
// │   │   │   └── usecases/
// │   │   └── presentation/
// │   │       ├── pages/
// │   │       ├── widgets/
// │   │       └── bloc/
// ├── injection_container.dart
// └── main.dart


// flutter pub run flutter_native_splash:create
// flutter pub run flutter_launcher_icons:main

// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/TJselevani/pix2life-client.git
// git push -u origin main


// https://www.youtube.com/watch?v=_E3EF1jPumM&t=1253s
// 6:20 testing cubit

// 6:32:46 --dependency injection