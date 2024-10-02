// constraints.dart

import 'package:flutter/material.dart';

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
