import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/screen/eachMission/CategoryMission.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/NoticePage.dart';
import 'package:daycus/screen/eachMission/AllMission.dart';

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
            IconButton(icon: Icon(Icons.search), onPressed: null),
            IconButton(icon: Icon(Icons.notifications), color: Colors.grey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NoticePage()),
                  );
                }),

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
            CategoryMission(page_category: missions_health),
            CategoryMission(page_category: missions_study),
            CategoryMission(page_category: missions_exer),
            CategoryMission(page_category: missions_life),
            CategoryMission(page_category: missions_hobby),

          ],
        ),
      ),
    );
  }
}