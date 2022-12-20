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

class TemHomePage extends StatefulWidget {
  TemHomePage({Key? key}) : super(key: key);

  @override
  State<TemHomePage> createState() => _TemHomePageState();
}

class _TemHomePageState extends State<TemHomePage> {

  // init state 넣으면 왠지 더 빨라짐.
  // 하지만 UI는 뜨지 않음.

  final List<Widget> screens = const [
    LabelPage(),
    MissionCheckPage(),
    HomePage(),
    MissionPage(),
    MyPage()
  ];

  // 항상 첫 화면 홈페이지가 되도록 바꾸어야할 듯
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


