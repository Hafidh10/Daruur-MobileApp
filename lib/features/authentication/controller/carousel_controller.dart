import 'package:get/get.dart';

class HomeCarouselController extends GetxController {
  static HomeCarouselController get instance => Get.find();

  final carouselCurrentIndex = 0.obs;

  void updatePageIndicator(index) {
    carouselCurrentIndex.value = index;
  }
}
