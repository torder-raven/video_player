import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'icon.dart';

class NewVideo extends StatelessWidget {
  final VoidCallback onPressed;

  const NewVideo({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: renderIconButton(
          onPressed: onPressed, iconData: Icons.photo_camera_back),
    );
  }
}
