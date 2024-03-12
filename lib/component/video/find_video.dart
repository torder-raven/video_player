import 'package:flutter/material.dart';

class FindVideo extends StatelessWidget {
  final VoidCallback onPressed;

  const FindVideo({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: IconButton(
        onPressed: onPressed,
        iconSize: 30.0,
        color: Colors.white,
        icon: const Icon(
          Icons.photo_camera_back_rounded,
        ),
      ),
    );
  }
}
