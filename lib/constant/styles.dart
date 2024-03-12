import 'dart:ui';
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  AppTextStyles._();

  /** 이것도 어떤 규칙으로 설정하면 좋을지 ㅎㅎ */
  static const TextStyle esamanru_30_w300 = TextStyle(
    color: AppColors.color_ffffff,
    fontSize: 30.0,
    fontWeight: FontWeight.w300,
    fontFamily: 'esamanru',
  );

  static const TextStyle esamanru_30_w700 = TextStyle(
    color: AppColors.color_ffffff,
    fontSize: 30.0,
    fontWeight: FontWeight.w700,
    fontFamily: 'esamanru',
  );
}
