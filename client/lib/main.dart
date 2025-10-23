import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_theme.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/app/navigation/drawer_navigation/drawer_provider.dart';
import 'package:pix2life/src/app/navigation/tab_navigation/bottom_tab_navigation.dart';
import 'package:pix2life/src/app/pages/guide/onboard_screen.dart';
import 'package:pix2life/src/features/audio/data/data%20sources/audio_provider.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_provider.dart';
import 'package:pix2life/src/features/auth/presentation/views/reset_password/forgot_password_page.dart';
import 'package:pix2life/src/features/auth/presentation/views/sign_in/sign_in_page_2.dart';
import 'package:pix2life/src/features/gallery/data/data_source/gallery_provider.dart';
import 'package:pix2life/src/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/app/pages/intro/welcome_page.dart';
import 'package:pix2life/src/features/auth/presentation/views/sign_in/sign_in_page_1.dart';
import 'package:pix2life/src/features/auth/presentation/views/sign_up/create_account/create_account_page_1.dart';
import 'package:pix2life/src/features/auth/presentation/views/sign_up/create_password/create_password_page_1.dart';
import 'package:pix2life/injection_container.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:pix2life/src/features/image/data/data%20sources/image_provider.dart';
import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';
import 'package:pix2life/src/features/image/presentation/views/match_image/match_photo.dart';
import 'package:pix2life/src/features/image/presentation/views/upload_images/update_avatar.dart';
import 'package:pix2life/src/features/image/presentation/views/upload_images/upload_avatar.dart';
import 'package:pix2life/src/features/video/data/data%20sources/video_provider.dart';
import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stripe
  // Stripe.publishableKey = AppSecrets.stripePublishableKey;
  // await Stripe.instance.applySettings();

  // Initialize bloc
  await initDependencies();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 804),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<AuthBloc>()),
            BlocProvider(create: (context) => sl<AudioBloc>()),
            BlocProvider(create: (context) => sl<ImageBloc>()),
            BlocProvider(create: (context) => sl<VideoBloc>()),
            BlocProvider(create: (context) => sl<GalleryBloc>()),
          ],
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => MyThemeProvider()),
              ChangeNotifierProvider(create: (context) => MyZoomDrawerProvider()),
              ChangeNotifierProvider(create: (context) => MyUserProvider(context)),
              ChangeNotifierProvider(create: (context) => MyImageProvider(context)),
              ChangeNotifierProvider(create: (context) => MyAudioProvider(context)),
              ChangeNotifierProvider(create: (context) => MyVideoProvider(context)),
              ChangeNotifierProvider(create: (context) => MyGalleryProvider(context)),
            ],
            child: const MyApp(),
          ),
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
  @override
  Widget build(BuildContext context) {
    final log = createLogger(MyApp);
    log.i('Client :: Running');
    return Consumer<MyThemeProvider>(
      builder: (
        BuildContext context,
        MyThemeProvider themeProvider,
        Widget? child,
      ) {
        return MaterialApp(
          title: 'pix2life',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => const WelcomePage(),
            '/Onboard': (context) => const OnboardScreen(),
            '/SignIn': (context) => const UserSignInPage(),
            '/SignUp': (context) => const UserEmailSignUpPage(),
            '/Start': (context) => const WelcomeBack(),
            '/Reset': (context) => const UserForgotPasswordPage(),
            '/Home': (context) => const BottomTabNavigation(),
            '/Matching': (context) => const Matching(),
            '/Password': (context) => const UserCreatePasswordPage(),
            '/SetAvatar': (context) => const UploadProfilePicPage(),
            '/Avatar': (context) => const UpdateProfilePicPage(),
            // '/QR': (context) => const QRCodeScreen(),
            // '/QR2': (context) => const QRCodeScannerScreen(),
          },
        );
      },
    );
  }
}
