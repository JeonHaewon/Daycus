import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';
import 'package:daycus/widget/missionbutton.dart';
import 'package:daycus/widget/nowingmission.dart';
import 'package:daycus/screen/specificMissionPage/SpecificMissionPage.dart';




class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('DAYCUS',
            style: TextStyle(color: Colors.black, fontSize: 25.sp)),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: null),
          IconButton(icon: Icon(Icons.notifications), onPressed: null),
          IconButton(icon: Icon(Icons.account_circle), onPressed: null)
        ],
        automaticallyImplyLeading: false,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(30.w, 0, 40.w, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 25.h,),
                              Text("안녕하세요",style: TextStyle(fontSize: 30.sp, fontFamily: 'korean') ),
                              Text("TODAY 님",style: TextStyle(fontSize: 30.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                              SizedBox(height: 60.h,),
                              Text("현재 등급",style: TextStyle(color: Colors. grey, fontSize: 20.sp, fontFamily: 'korean') ),
                              SizedBox(height: 10.h,),
                              Container(
                                child: Row(
                                  children: [
                                    Image.asset('assets/image/Medal.png' , fit: BoxFit.fill),
                                    Text("Lv18",style: TextStyle(color: AppColor.happyblue, fontSize: 20.sp, fontFamily: 'korean') ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ),
                    ],
                  ), //왼쪽에 글자랑 등급들
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 40.h,),
                        Image.asset('assets/image/character.png' , fit: BoxFit.fill,height: 240.h)
                      ],
                    ),
                  ),//오른쪽 asset
                ],
              ),
            ),//위쪽 제일 큰 박스

            Container(
              width: 360.w,
              height: 55.h,
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                children: [
                  SizedBox(width: 15.w,),
                  Text("주간 랭킹",style: TextStyle(color: AppColor.happyblue, fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  SizedBox(width: 130.w,),
                  Text("6위",style: TextStyle(color: AppColor.happyblue, fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  SizedBox(width: 20.w,),

                  Container(
                    width: 80.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [

                        SizedBox(height: 7.h,),
                        Text("주간랭킹",style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'korean') ),

                      ],
                    ),
                  ),
                ],
              ),

            ), //주간랭킹

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: EdgeInsets.fromLTRB(35.w, 40.h, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h,),
                        Text("진행 중인 미션",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h,),

                  NowMissionButton(image: 'nowmission', title: '매일 물 3잔 마시기', totalUser: 1250, rank: 120, reward: 1200,onTap: (){},)



                ],
              ),

            ), //진행중인 미션
            
            
            
            
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left:35.w, top: 45.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50.h,),
                        Text("금주의 추천 미션",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                      ],
                    ),
                  ),

                  Container(
                    width: 360.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MissionButton(
                          title: "매일 물 3잔 마시기",
                          totalUser: 1200,
                          image: 'missionbackground',

                          onTap: SpecificMissionPage(topimage:'topimage1' ,progress:'ingbutton' , title:'매일 아침 조깅하기'
                              , duration: '4월 11일(월) ~ 4월 24일(일)',totaluser: 1250, certifiuser: 1131,),
                        ),

                        MissionButton(
                          title: "매일 물 3잔 마시기",
                          totalUser: 1200,
                          image: 'missionbackground2',

                          onTap: (){},
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 15.h,),


                  Container(
                    width: 360.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        MissionButton(
                          title: "매일 물 3잔 마시기",
                          totalUser: 1200,
                          image: 'missionbackground2',
                          onTap: (){},
                        ),

                        MissionButton(
                          title: "매일 물 3잔 마시기",
                          totalUser: 1200,
                          image: 'missionbackground',

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


    );


  }
}