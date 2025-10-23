import 'package:flutter/material.dart';

class OnboardPage6 extends StatelessWidget {
  const OnboardPage6({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text('Your Story, Your Way',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "Customize your memory albums with ease. Organize your media files by cities, places, foods, and experiences to create a personalized journey through your memories.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
