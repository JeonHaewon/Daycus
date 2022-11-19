import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/widget/labelbutton.dart';
import 'package:daycus/screen/labelPage/LabelingMission.dart';



class LabelPage extends StatelessWidget {
  const LabelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('라벨링',
            style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: null),
          IconButton(icon: Icon(Icons.notifications), onPressed: null),
          IconButton(icon: Icon(Icons.account_circle), onPressed: null)
        ],
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        child:Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 30.h,), //맨 위 간격


                    Container(
                      width: 370.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          LabelButton(
                              image: 'mission1',
                              title: "매일 물 3잔 마시기",
                              duration: 2,
                              totalUser: 2000,
                              myparticipation: 500,
                              onTap: LabelingMission(title: "매일 아침 9시 기상하기",
                                rule1: "아날로그 시계 또는 전자 시계여야 합니다.",
                                rule2: "시계 숫자를 포함한 테두리 전체가 나와야 합니다.",),
                          ),

                          LabelButton(
                            image: 'mission1',
                            title: "매일 물 3잔 마시기",
                            duration: 2,
                            totalUser: 2000,
                            myparticipation: 500,
                            onTap: (){},
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 30.h,),


                  ],
                ),

              ), //금주의 추천 미션
            ],
          ),
        ),
      ),
    );
  }
}