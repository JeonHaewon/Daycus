import 'package:get/get.dart';


class OfficeFurnitureController extends GetxController {
  RxInt currentBottomNavItemIndex = 2.obs;
  RxInt currentPageViewItemIndicator = 0.obs;

  switchBetweenBottomNavigationItems(int currentIndex) {
    currentBottomNavItemIndex.value = currentIndex;
  }

  switchBetweenPageViewItems(int currentIndex) {
    currentPageViewItemIndicator.value = currentIndex;
  }





}
