import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/screen/eachMission/CategoryMission.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/NoticePage.dart';
import 'package:daycus/screen/eachMission/AllMission.dart';
import 'dart:math';
import 'package:daycus/screen/myPage/privatesettings/PrivateSettings.dart';

class MissionPage extends StatelessWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child:Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(' 미션',
              style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold)),
          actions: [
            //IconButton(icon: Icon(Icons.search), onPressed: null),
            IconButton(icon: Icon(Icons.notifications), color: Colors.grey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NoticePage()),
                  );
                }),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PrivateSettings()),
                );
              },

              child: Container(
                  padding: EdgeInsets.all(12.sp),
                  child: (profileImage==null)
                  // 고른 프로필 사진이 없을 때
                      ? (user_data['profile']==null || downloadProfileImage==null)
                      ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png"), radius: 13.sp,)
                      : Transform.rotate(angle: profileDegree* pi/180, child: CircleAvatar( backgroundImage: downloadProfileImage!.image, radius: 13.sp), )
                      : CircleAvatar( backgroundImage : FileImage(profileImage!), radius: 13.sp,)
              ),
            ),

          ],
          automaticallyImplyLeading: false,
          bottom: TabBar(
              indicatorColor: AppColor.happyblue,
              labelColor: AppColor.happyblue,
              unselectedLabelColor: Colors.grey,
              tabs: <Widget>[
                Tab(text: "전체"),
                Tab(text: "건강"),
                Tab(text: "공부"),
                Tab(text: "운동"),
                Tab(text: "생활"),
                Tab(text: "취미"),
              ]
          ),

        ),
        body:TabBarView(

          children: [
            AllMission(),
            CategoryMission(page_category: "건강"),
            CategoryMission(page_category: "공부"),
            CategoryMission(page_category: "운동"),
            CategoryMission(page_category: "생활"),
            CategoryMission(page_category: "취미"),

          ],
        ),
      ),
    );
  }
}