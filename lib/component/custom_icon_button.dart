import 'package:flutter/material.dart';
import 'package:video_player_kite/constant/colors.dart';

class CustomIconButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final IconData iconData;

  const CustomIconButton({
    required this.onPressed,
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: AppColors.color_ffffff,
      icon: Icon(
        iconData,
      ),
    );
  }
}
