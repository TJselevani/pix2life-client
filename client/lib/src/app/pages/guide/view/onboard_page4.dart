import 'package:flutter/material.dart';

class OnboardPage4 extends StatelessWidget {
  const OnboardPage4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SvgPicture.asset('assets/svg/summer-vacation.svg', height: 150),
          const SizedBox(height: 20),
          Text('Memories in Motion',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "Store and share your videos and photos from every adventure. Create a visual diary that captures the essence of your travels and the moments that matter most.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
