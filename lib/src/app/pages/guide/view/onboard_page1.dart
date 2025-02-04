import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardPage1 extends StatelessWidget {
  const OnboardPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svg/places.svg', height: 100),
          const SizedBox(height: 20),
          Text('Capture the Essence of Every City',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "Explore and share the vibrant life of cities around the world. From iconic landmarks to hidden gems, your memories will inspire others to discover new places.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
