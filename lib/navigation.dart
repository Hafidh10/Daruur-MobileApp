// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skiive/features/authentication/screens/courses/courses.dart';
import 'package:skiive/features/authentication/screens/home/home.dart';
import 'package:skiive/features/authentication/screens/profile/profile.dart';
import 'package:skiive/features/authentication/screens/quiz/quiz_screen.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/helpers/helper_functions.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = SkiiveHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(() => NavigationBar(
              height: 80,
              elevation: 0,
              selectedIndex: controller.selectedIndex.value,
              backgroundColor: darkMode ? SkiiveColors.black : Colors.white,
              indicatorColor: darkMode
                  ? SkiiveColors.white.withOpacity(0.1)
                  : SkiiveColors.black.withOpacity(0.1),
              onDestinationSelected: (index) =>
                  controller.selectedIndex.value = index,
              destinations: [
                NavigationDestination(
                  icon: Icon(Iconsax.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Iconsax.book),
                  label: 'My Courses',
                ),
                NavigationDestination(
                  icon: Icon(Iconsax.task),
                  label: 'Quiz',
                ),
                NavigationDestination(
                  icon: Icon(Iconsax.profile_circle),
                  label: 'Profile',
                ),
              ])),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    HomeScreen(),
    CoursesScreen(),
    QuizScreen(),
    ProfileScreen()
  ];
}
