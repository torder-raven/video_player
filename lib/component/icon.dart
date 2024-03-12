import 'package:flutter/material.dart';

Widget renderIconButton(
    {required VoidCallback onPressed, required IconData iconData}) {
  return IconButton(
    onPressed: onPressed,
    icon: Icon(
      iconData,
      color: Colors.white,
    ),
  );
}
