

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';


class Confetti extends StatefulWidget {
  final ConfettiController controller;
  const Confetti({super.key, required this.controller});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {
  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: widget.controller,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: true,
      colors: const [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        AppPalette.red,
      ],
    );
  }
}


