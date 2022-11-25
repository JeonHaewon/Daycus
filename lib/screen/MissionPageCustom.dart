import 'package:daycus/screen/eachMission/HealthMission.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:daycus/widget/bigmissionbutton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/eachMission/HealthMission.dart';
import 'package:daycus/screen/eachMission/StudyMission.dart';
import 'package:daycus/screen/eachMission/ExerciseMission.dart';
import 'package:daycus/screen/eachMission/LifeMission.dart';
import 'package:daycus/screen/eachMission/HobbyMission.dart';
import 'package:daycus/screen/NoticePage.dart';


class MissionPage extends StatelessWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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
            HealthMission(),
            StudyMission(),
            ExerciseMission(),
            LifeMission(),
            HobbyMission(),

          ],
        ),
      ),
    );
  }
}