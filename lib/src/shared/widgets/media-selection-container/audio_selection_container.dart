import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AudioSelectionContainer extends StatelessWidget {
  final String audioName;
  final VoidCallback? onRemove;
  final BuildContext context;

  const AudioSelectionContainer({
    super.key,
    required this.audioName,
    this.onRemove,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: ListTile(
            title: Text(
              audioName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 18.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
