// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_theme.dart';
import 'package:pix2life/src/app/menu/drawer.dart';
import 'package:pix2life/src/app/navigation/main_navigation_page.dart';
import 'package:pix2life/src/app/pages/profile%20screen/profile_screen.dart';
import 'package:pix2life/src/app/pages/upload-screen/select_media_upload.dart';
import 'package:pix2life/src/app/pages/main/landing_page.dart.dart';
import 'package:pix2life/src/app/pages/main/audios/audio_player_page.dart';
import 'package:pix2life/src/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/app/pages/intro/welcome_page.dart';
import 'package:pix2life/src/features/auth/presentation/views/sign_in/sign_in_page_1.dart';
import 'package:pix2life/src/features/auth/presentation/views/sign_up/create_account/create_account_page_1.dart';
import 'package:pix2life/src/features/auth/presentation/views/sign_up/create_password/create_password_page_1.dart';
import 'package:pix2life/injection_container.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';
import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';
import 'package:pix2life/test/test_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 804),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<AuthBloc>()),
            BlocProvider(create: (context) => sl<AudioBloc>()),
            BlocProvider(create: (context) => sl<ImageBloc>()),
            BlocProvider(create: (context) => sl<VideoBloc>()),
            BlocProvider(create: (context) => sl<GalleryBloc>()),
          ],
          child: const MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeMode _themeMode = ThemeMode.system; // Start with system theme

  // void _switchTheme(ThemeMode themeMode) {
  //   setState(() {
  //     _themeMode = themeMode;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final log = createLogger(MyApp);
    log.i('Client :: Running');
    return MaterialApp(
      title: 'pix2life',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: _themeMode,

      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/SignIn': (context) => const UserSignInPage(),
        '/SignUp': (context) => const UserEmailSignUpPage(),
        '/Home': (context) => const MainPageNavigation(),
        '/Password': (context) => const UserCreatePasswordPage(),
        '/Avatar': (context) => const MyWidget(),
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

// lib/
// ├── core/
// │   ├── errors/
// │   ├── utils/
// │   └── usecases/
// ├── features/
// │   ├── authentication/
// │   ├── images/
// │   ├── video/
// │   ├── audio/
// ├── shared/
// │   ├── widgets/
// │   ├── styles/
// ├── app/
// │   ├── pages/
// │   ├── menu/
// │   ├── multimedia/
// │   ├── home/
// │   └── app_bloc.dart
