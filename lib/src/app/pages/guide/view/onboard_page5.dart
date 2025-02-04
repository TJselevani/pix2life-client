import 'package:flutter/material.dart';

class OnboardPage5 extends StatelessWidget {
  const OnboardPage5({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text('Discover and Share',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "Join a community of explorers and foodies. Share your experiences, discover new places, and connect with others who share your passion for travel and food.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
