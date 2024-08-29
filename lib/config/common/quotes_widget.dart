import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class QuoteDisplay extends StatefulWidget {
  @override
  _QuoteDisplayState createState() => _QuoteDisplayState();
}

class _QuoteDisplayState extends State<QuoteDisplay> {
  final List<Map<String, dynamic>> quotes = [
    {
      'quote': 'The unexamined life is not worth living.',
      'author': 'Socrates',
      'year': 1899
    },
    {
      'quote': 'I think, therefore I am.',
      'author': 'René Descartes',
      'year': 1637
    },
    {
      'quote': 'To be is to be perceived.',
      'author': 'George Berkeley',
      'year': 1710
    },
    {
      'quote': 'Man is condemned to be free.',
      'author': 'Jean-Paul Sartre',
      'year': 1946
    },
    {
      'quote': 'He who thinks great thoughts, often makes great errors.',
      'author': 'Martin Heidegger',
      'year': 1927
    },
    {
      'quote': 'The only thing I know is that I know nothing.',
      'author': 'Socrates',
      'year': -399
    },
    {
      'quote': 'The limits of my language mean the limits of my world.',
      'author': 'Ludwig Wittgenstein',
      'year': 1922
    },
    {
      'quote': 'One cannot step twice in the same river.',
      'author': 'Heraclitus',
      'year': 3500
    },
    {
      'quote': 'God is dead! He remains dead! And we have killed him.',
      'author': 'Friedrich Nietzsche',
      'year': 1882
    },
    {
      'quote': 'Happiness is not an ideal of reason but of imagination.',
      'author': 'Immanuel Kant',
      'year': 1781
    }
  ];

  late Timer _timer;
  int _currentIndex = 0;

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
    _timer = Timer.periodic(Duration(seconds: 20), (timer) {
      setState(() {
        _currentIndex = Random().nextInt(quotes.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuote = quotes[_currentIndex];

    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Container(
        key: ValueKey<int>(_currentIndex),
        child: RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            children: [
              TextSpan(
                text: '“${currentQuote['quote']}”\n',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              TextSpan(
                text: 'By - ${currentQuote['author']}, ',
                style: TextStyle(
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Poppins',
                ),
              ),
              TextSpan(
                text: '${currentQuote['year']}',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
