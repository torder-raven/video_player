import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_app/common/extensions.dart';

class Seeker extends StatelessWidget {
  final VideoPlayerValue videoPlayerValue;
  final ValueChanged<double> onSeekerChanged;

  const Seeker({
    super.key,
    required this.videoPlayerValue,
    required this.onSeekerChanged,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
    );

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            Text(
              videoPlayerValue.position.formattingTimeInMinutes(),
              style: textStyle,
            ),
            Expanded(
              child: Slider(
                max: videoPlayerValue.duration.inSeconds.toDouble(),
                min: 0,
                value: videoPlayerValue.position.inSeconds.toDouble(),
                onChanged: onSeekerChanged,
              ),
            ),
            Text(
              videoPlayerValue.duration.formattingTimeInMinutes(),
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
