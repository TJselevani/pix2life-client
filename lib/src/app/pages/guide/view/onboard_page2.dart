import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardPage2 extends StatelessWidget {
  const OnboardPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svg/items.svg', height: 100),
          const SizedBox(height: 20),
          Text('Savor Every Bite',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text(
            "Document your culinary adventures and favorite dining spots. Whether it’s street food or fine dining, share the flavors that make your experiences unforgettable.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
