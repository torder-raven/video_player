import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_video_player.dart';
import 'icon.dart';

class CustomController extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversedPressed;
  final VoidCallback onForwardPressed;
  final bool isPlaying;

  const CustomController(
      {super.key,
        required this.onPlayPressed,
        required this.onReversedPressed,
        required this.onForwardPressed,
        required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
              onPressed: onReversedPressed, iconData: Icons.rotate_left),
          renderIconButton(
              onPressed: onPlayPressed,
              iconData: isPlaying ? Icons.pause : Icons.play_arrow),
          renderIconButton(
              onPressed: onForwardPressed, iconData: Icons.rotate_right)
        ],
      ),
    );
  }
}