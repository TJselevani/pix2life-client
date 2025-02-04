import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/shared/widgets/quotes/quotes.dart';
import 'package:provider/provider.dart';

class QuoteDisplay extends StatefulWidget {
  const QuoteDisplay({super.key});

  @override
  State<QuoteDisplay> createState() => _QuoteDisplayState();
}

class _QuoteDisplayState extends State<QuoteDisplay> {
  late Timer _timer;
  int _currentIndex = 0;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = Random().nextInt(quotes.length);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      setState(() {
        _currentIndex = Random().nextInt(quotes.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<MyThemeProvider>(context);
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final currentQuote = quotes[_currentIndex];

    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: SizedBox(
        key: ValueKey<int>(_currentIndex),
        width: double.infinity, // Ensures the container takes up full width
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // Make sure the text occupies full available width
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '“${currentQuote['quote']}”\n',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: isDarkMode ? Colors.grey : AppPalette.fontBlack,
                      ),
                    ),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: '~ ${currentQuote['author']}, ',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Poppins',
                        color: isDarkMode
                            ? AppPalette.fontWhite
                            : AppPalette.fontBlack,
                      ),
                    ),
                    TextSpan(
                      text: '${currentQuote['year']}',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        color: isDarkMode
                            ? AppPalette.fontWhite
                            : AppPalette.fontBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
