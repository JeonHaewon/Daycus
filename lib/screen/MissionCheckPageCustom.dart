import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/widget/nowingmission.dart';
import 'package:daycus/screen/NoticePage.dart';




class MissionCheckPage extends StatelessWidget {
  const MissionCheckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('미션인증',
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 30.h, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h,),
                  Text("진행 중인 미션",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                ],
              ),
            ),

            SizedBox(height: 20.h,),

            Container(
              child: Column(
                children: [
                  NowMissionButton(image: 'nowmission', title: '매일 물 3잔 마시기', totalUser: 1250, rank: 120, reward: 1200, onTap: (){},),
                  SizedBox(height: 15.h,),
                  NowMissionButton(image: 'nowmission', title: '매일 물 3잔 마시기', totalUser: 1250, rank: 120, reward: 1200, onTap: (){},),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}