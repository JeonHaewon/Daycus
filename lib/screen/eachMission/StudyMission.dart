import 'package:flutter/material.dart';
import 'package:daycus/widget/bigmissionbutton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';


class StudyMission extends StatelessWidget {
  const StudyMission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body:SingleChildScrollView(
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
                          BigMissionButton(
                            title: "매일 물 3잔 마시기",
                            totalUser: 1200,
                            image: 'mission1',
                            certifiUser:2000,
                            duration:2,
                            onTap: (){},
                          ),

                          BigMissionButton(
                            title: "매일 물 3잔 마시기",
                            totalUser: 1200,
                            image: 'mission1',
                            certifiUser:2000,
                            duration:2,
                            onTap: (){},
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 30.h,),

                    Container(
                      width: 370.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BigMissionButton(
                            title: "매일 물 3잔 마시기",
                            totalUser: 1200,
                            image: 'mission1',
                            certifiUser:2000,
                            duration:2,
                            onTap: (){},
                          ),

                          BigMissionButton(
                            title: "매일 물 3잔 마시기",
                            totalUser: 1200,
                            image: 'mission1',
                            certifiUser:2000,
                            duration:2,
                            onTap: (){},
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 30.h,),


                    Container(
                      width: 370.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BigMissionButton(
                            title: "매일 물 3잔 마시기",
                            totalUser: 1200,
                            image: 'mission1',
                            certifiUser:2000,
                            duration:2,
                            onTap: (){},
                          ),

                          Container(
                            width: 170.w,
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