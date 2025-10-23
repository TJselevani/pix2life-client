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
  static const appStoreImg = 'assets/icons/AppIcons/appstore.png';
  static const playStoreImg = 'assets/icons/AppIcons/playstore.png';
  static const img1 = 'assets/images/pix2life/img_1.jpg';
  static const img2 = 'assets/images/pix2life/img_2.jpg';
  static const img3 = 'assets/images/pix2life/img_3.jpg';
  static const img4 = 'assets/images/pix2life/img_4.jpg';
  static const img5 = 'assets/images/pix2life/img_5.jpg';
  static const img6 = 'assets/images/pix2life/img_6.jpg';
  static const img7 = 'assets/images/pix2life/img_7.jpg';
  static const img8 = 'assets/images/pix2life/img_8.jpg';
  static const img9 = 'assets/images/pix2life/img_9.jpg';
  static const img10 = 'assets/images/pix2life/img_10.jpg';
  static const img11 = 'assets/images/pix2life/img_11.jpg';
  static const img12 = 'assets/images/pix2life/img_12.jpg';
  static const img13 = 'assets/images/pix2life/img_13.jpg';
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
