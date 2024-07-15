// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/helpers/helper_functions.dart';

class SkiiveHeaderContainer extends StatelessWidget {
  const SkiiveHeaderContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SkiiveColors.primary,
      padding: EdgeInsets.all(0),
      child: SizedBox(
        height: 225,
        child: Stack(
          children: [
            Positioned(
              top: 50,
              right: -10,
              child: Image(
                image: const AssetImage('assets/logos/props-light-bulb.png'),
                width: SkiiveHelperFunctions.screenWidth() * 0.2,
              ),
            ),
            child,
            // Positioned(
            //   top: 10,
            //   right: -180,
            //   child: SkiiveThemeCircles(
            //     backgroundColor:
            //         SkiiveColors.textWhite.withOpacity(0.1),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
