// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/device/device_utils.dart';
import 'package:skiive/utils/helpers/helper_functions.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = SkiiveHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 33),
        child: Container(
          width: SkiiveDeviceUtils.getScreenWidth(context),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: showBackground
                ? dark
                    ? SkiiveColors.dark
                    : SkiiveColors.light
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            border: showBorder ? Border.all(color: SkiiveColors.grey) : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: SkiiveColors.darkerGrey,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}
