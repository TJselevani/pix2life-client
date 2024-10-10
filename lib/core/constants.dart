// constraints.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kSpacingUnit = 10;

const kDarkPrimaryColor = Color(0xFF212121);
const kDarkSecondaryColor = Color(0xFF373737);
const kLightPrimaryColor = Color(0xFFFFFFFF);
const kLightSecondaryColor = Color(0xFFF3F7FB);
const kAccentColor = Color(0xFFFFC107);

final kTitleTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.7),
  fontWeight: FontWeight.w600,
);

final kCaptionTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.3),
  fontWeight: FontWeight.w100,
);

final kButtonTextStyle = TextStyle(
  fontSize: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
  fontWeight: FontWeight.w400,
  color: kDarkPrimaryColor,
);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: kDarkPrimaryColor,
  canvasColor: kDarkPrimaryColor,
  scaffoldBackgroundColor: kDarkSecondaryColor,
  hintColor: kAccentColor,
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: kLightSecondaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kLightSecondaryColor,
        displayColor: kLightSecondaryColor,
      ),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: kLightPrimaryColor,
  canvasColor: kLightPrimaryColor,
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: kDarkSecondaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: kDarkSecondaryColor,
        displayColor: kDarkSecondaryColor,
      ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kAccentColor),
  // colorScheme: const ColorScheme(surface: kLightSecondaryColor),
);

class AppConstraints {
  // Define common constraints used throughout the app
  static const BoxConstraints tightConstraints = BoxConstraints.tightFor(
    width: 100.0,
    height: 100.0,
  );

  static BoxConstraints looseConstraints = BoxConstraints.loose(
    const Size(200.0, 200.0),
  );

  static const BoxConstraints expandedConstraints = BoxConstraints.expand(
    width: 300.0,
    height: 300.0,
  );

  static const BoxConstraints minConstraints = BoxConstraints(
    minWidth: 50.0,
    minHeight: 50.0,
  );

  static const BoxConstraints maxConstraints = BoxConstraints(
    maxWidth: 400.0,
    maxHeight: 400.0,
  );
}

class AppImage {
  static const gallery1 = 'assets/images/A.jpg';
  static const gallery2 = 'assets/images/R.jpeg';
  static const camera = 'assets/images/camera.png';
  static const welcomeImage = 'assets/images/pic1.png';
  static const welcomeImage2 = 'assets/images/pic2.png';
  static const welcomeImage3 = 'assets/images/pic3.png';
  static const whiteIconImage = 'assets/images/whiteIcon.png';
  static const randomImage = 'https://random.imagecdn.app/150/150';
  static const avatarUrl =
      'https://i.fbcd.co/products/resized/resized-750-500/d4c961732ba6ec52c0bbde63c9cb9e5dd6593826ee788080599f68920224e27d.jpg';
}

class AppLogo {
  static const pix2lifeLogo = "assets/images/pix2lifelogo.png";
}
