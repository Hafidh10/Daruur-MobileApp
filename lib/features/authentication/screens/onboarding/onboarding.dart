import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/device/device_utils.dart';
import 'package:skiive/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controller/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: 'assets/images/kingdom-open-book.gif',
                title: 'Learn',
                subTitle: 'Read a book',
              ),
              OnBoardingPage(
                image: 'assets/images/kingdom-reading-is-learning.gif',
                title: 'Research',
                subTitle: 'Read a book',
              ),
              OnBoardingPage(
                image: 'assets/images/pablita-woman-reading-a-book-at-home.gif',
                title: 'For All',
                subTitle: 'Read a book',
              ),
            ],
          ),

          //Skip button
          Positioned(
              top: SkiiveDeviceUtils.getAppBarHeight(),
              right: 10,
              child: TextButton(
                  onPressed: () => OnBoardingController.instance.skipPage(),
                  child: const Text('Skip'))),

          // Dot navigation
          const DotNavigation(),

          // Button
          const OnBoardingButton(),
        ],
      ),
    );
  }
}

class OnBoardingButton extends StatelessWidget {
  const OnBoardingButton({
    super.key,
  });

  // _storeOnBoardInfo() async {
  //   int isViewed = 0;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('OnBoard', isViewed);
  // }

  @override
  Widget build(BuildContext context) {
    final dark = SkiiveHelperFunctions.isDarkMode(context);

    return Positioned(
      right: 10,
      bottom: SkiiveDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: dark ? SkiiveColors.primary : Colors.black),
        onPressed: () async {
          // await _storeOnBoardInfo();
          OnBoardingController.instance.nextPage();
        },
        child: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class DotNavigation extends StatelessWidget {
  const DotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = SkiiveHelperFunctions.isDarkMode(context);
    final controller = OnBoardingController.instance;

    return Positioned(
      bottom: SkiiveDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: 20,
      child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: ExpandingDotsEffect(
              activeDotColor: dark ? SkiiveColors.light : SkiiveColors.dark,
              dotHeight: 6)),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Image(
            image: AssetImage(image),
            width: SkiiveHelperFunctions.screenWidth() * 0.8,
            height: SkiiveHelperFunctions.screenHeight() * 0.6,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(subTitle, style: Theme.of(context).textTheme.bodyMedium)
        ],
      ),
    );
  }
}
