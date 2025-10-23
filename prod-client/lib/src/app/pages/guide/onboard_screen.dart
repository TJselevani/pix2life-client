import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/app/pages/guide/view/onboard_page1.dart';
import 'package:pix2life/src/app/pages/guide/view/onboard_page2.dart';
import 'package:pix2life/src/app/pages/guide/view/onboard_page3.dart';
import 'package:provider/provider.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  PageController? _controller;
  int _index = 0;
  late bool isDarkMode;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
        elevation: 0,
      ),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                _index = value;
              });
            },
            children: const [
              OnboardPage1(),
              OnboardPage2(),
              OnboardPage3(),
            ],
          ),
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _index == 0
                    ? fillDot()
                    : _index == 2
                        ? tinyDot()
                        : normalDot(),
                const SizedBox(width: 5),
                _index == 1 ? fillDot() : normalDot(),
                const SizedBox(width: 5),
                _index == 2
                    ? fillDot()
                    : _index == 0
                        ? tinyDot()
                        : normalDot()
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_index < 2) {
                    _controller?.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    // Navigate to the next page or home screen
                    Navigator.pushReplacementNamed(context, '/SetAvatar');
                  }
                },
                child: Text(_index < 2 ? 'Next' : 'Get Started'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  fillDot() => Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
            color: Colors.deepOrange, shape: BoxShape.circle),
      );

  normalDot() => Container(
        width: 7,
        height: 7,
        decoration:
            const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
      );

  tinyDot() => Container(
        width: 5,
        height: 5,
        decoration:
            const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
      );
}
