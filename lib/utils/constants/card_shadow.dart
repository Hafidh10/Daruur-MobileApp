import 'package:flutter/material.dart';
import 'package:skiive/utils/constants/colors.dart';

class SkiiveCardShadow {
  static final verticalCardShadow = BoxShadow(
      color: SkiiveColors.darkGrey.withOpacity(0.1),
      blurRadius: 50,
      spreadRadius: 7,
      offset: const Offset(0, 2));
}
