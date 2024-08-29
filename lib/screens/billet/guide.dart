import 'package:flutter/material.dart';
import 'package:pix2life/config/common/button_widgets.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AuthFlatButton(name: 'Auth Flat Button'),
            AuthGradientButton(name: 'Auth Gradient Button'),
            ChooseButton(name: 'Choose Button'),
            IconTextButton(name: 'Icon Text Button'),
            NormalFlatButton(name: 'Normal Flat Button'),
            RoundedButton(name: 'Rounded Button'),
            SquareButton(name: 'Square Button'),
            HoverButton(name: 'Hover Button'),
          ],
        ),
      )),
    );
  }
}
