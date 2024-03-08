import 'package:flutter/material.dart';
import 'package:video_player_kite/constant/colors.dart';

class CustomIconButton extends StatelessWidget {
  final GestureTapCallback onPressed; // 아이콘을 눌렀을 때 실행할 함수
  final IconData iconData; // 아이콘

  const CustomIconButton({
    required this.onPressed,
    required this.iconData,
    Key? key,
  }) : super(key: key);

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
