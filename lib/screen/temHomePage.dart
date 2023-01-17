import 'package:daycus/backend/ImportData/imageDownload.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:daycus/core/app_data.dart';
import 'package:daycus/core/app_color.dart';

import 'package:daycus/screen/LabelPageCustom.dart';
import 'package:daycus/screen/MissionCheckPageCustom.dart';
import 'package:daycus/screen/HomePageCustom.dart';
import 'package:daycus/screen/MissionPageCustom.dart';
import 'package:daycus/screen/MyPageCustom.dart';

import 'package:daycus/core/app_controller.dart';

import 'package:daycus/widget/advertisement.dart';


final OfficeFurnitureController controller =
    Get.put(OfficeFurnitureController());

class TemHomePage extends StatefulWidget {
  TemHomePage({Key? key}) : super(key: key);

  @override
  State<TemHomePage> createState() => _TemHomePageState();
}

// 뒤로버튼을 한번 더 누르면 종료됨.
onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > const Duration(milliseconds: 1500)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(
        msg: "뒤로 버튼을 한 번 더 누르시면 종료됩니다.",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xff6E6E6E),
        fontSize: 14.sp,
        toastLength: Toast.LENGTH_SHORT);
    return false;
  }
  return true;
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

    Size m = MediaQuery.of(context).size;
    double additionalBottomPadding = MediaQuery.of(context).padding.bottom;

    return WillPopScope(
      onWillPop: () async {
        bool result = onWillPop();
        return await Future.value(result);
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          constraints: BoxConstraints(
            maxHeight: 112.5.h
          ),
          child: Obx(
                  () {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Advertisement(),

                    BottomNavigationBar(
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
                    ),
                  ],

                );
              },
            ),
        ),

        body: Obx(() => screens[controller.currentBottomNavItemIndex.value]),
      ),
    );
  }
}


