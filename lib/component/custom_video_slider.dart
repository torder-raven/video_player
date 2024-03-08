import 'package:flutter/material.dart';
import 'package:vid_player/common/duration_exension.dart';

class CustomSlider extends StatelessWidget {
  final Duration currentPosition;

  //Double은 nullabe, double은 non-null
  final ValueChanged<double> onSliderChange;
  final Duration maxPosition;
  static TextStyle textStyle = TextStyle(color: Colors.white);

  const CustomSlider(
      {super.key,
        required this.currentPosition,
        required this.onSliderChange,
        required this.maxPosition});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      left: 0,
      bottom: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            CurrentTimeText(),
            ExpandedSlider(),
            EndTimeText(),
          ],
        ),
      ),
    );
  }

  Widget ExpandedSlider() {
    return Expanded(
      child: Slider(
        min: 0,
        max: maxPosition.inSeconds.toDouble(),
        value: currentPosition.inSeconds.toDouble(),
        onChanged: onSliderChange,
      ),
    );
  }

  Widget CurrentTimeText() {
    return Text(
      currentPosition.parseToTimeString(),
      style: textStyle,
    );
  }

  Widget EndTimeText() {
    return Text(
      maxPosition.parseToTimeString(),
      style: textStyle,
    );
  }
}