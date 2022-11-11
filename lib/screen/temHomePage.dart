import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:daycus/core/app_data.dart';
import 'package:daycus/core/app_color.dart';

import 'package:daycus/screen/LabelPageCustom.dart';
import 'package:daycus/screen/MissionCheckPageCustom.dart';
import 'package:daycus/screen/HomePageCustom.dart';
import 'package:daycus/screen/MissionPageCustom.dart';
import 'package:daycus/screen/MyPageCustom.dart';

import 'package:daycus/core/app_controller.dart';



final OfficeFurnitureController controller =
    Get.put(OfficeFurnitureController());

class TemHomePage extends StatelessWidget {
  const TemHomePage({Key? key}) : super(key: key);

  final List<Widget> screens = const [
    LabelPage(),
    MissionCheckPage(),
    HomePage(),
    MissionPage(),
    MyPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
            () {
          return BottomNavigationBar(
            unselectedItemColor: Colors.grey,
            currentIndex: controller.currentBottomNavItemIndex.value,
            showUnselectedLabels: true,
            onTap: controller.switchBetweenBottomNavigationItems,
            fixedColor: AppColor.lightBlack,
            items: AppData.bottomNavigationItems
                .map(
                  (element) => BottomNavigationBarItem(
                  icon: element.icon, label: element.label),
            )
                .toList(),
          );
        },
      ),
      body: Obx(() => screens[controller.currentBottomNavItemIndex.value]),
    );
  }
}


