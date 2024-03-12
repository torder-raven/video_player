import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Controls extends StatelessWidget {
  final VideoPlayerValue videoPlayerValue;
  final VoidCallback onPlayPressed; // 여러 개의 콜백을 하나로 묶을 수는 없을까? -> VideoControlCallback
  final VoidCallback onReveredPressed;
  final VoidCallback onForwardPressed;

  const Controls({
    super.key,
    required this.videoPlayerValue,
    required this.onPlayPressed,
    required this.onReveredPressed,
    required this.onForwardPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
            onPressed: onReveredPressed,
            iconData: Icons.rotate_left_rounded,
          ),
          renderIconButton(
            onPressed: onPlayPressed,
            iconData: videoPlayerValue.isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
          ),
          renderIconButton(
            onPressed: onForwardPressed,
            iconData: Icons.rotate_right_rounded,
          ),
        ],
      ),
    );
  }

  Widget renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,
      icon: Icon(
        iconData,
      ),
    );
  }
}
