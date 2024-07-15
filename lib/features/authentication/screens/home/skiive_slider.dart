// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skiive/features/authentication/controller/carousel_controller.dart';
import 'package:skiive/utils/theme/constantThemes/roundedImage.dart';

class SkiiveSlider extends StatelessWidget {
  const SkiiveSlider({
    super.key,
    required this.banners,
  });

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeCarouselController());
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 2,
              onPageChanged: (index, _) =>
                  controller.updatePageIndicator(index)),
          items: banners.map((url) => RoundedImage(imageUrl: url)).toList(),
        ),
        SizedBox(
          height: 15,
        ),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [for (int i = 0; i < banners.length; i++) Container()],
            ),
          ),
        )
      ],
    );
  }
}
