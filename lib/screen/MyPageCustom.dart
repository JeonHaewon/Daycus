import 'package:daycus/backend/Missions.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/myPage/privatesettings/PrivateSettings.dart';
import 'package:daycus/screen/myPage/settings/Settings.dart';
import 'package:daycus/screen/myPage/feed/MissionFeed.dart';
import 'package:daycus/screen/NoticePage.dart';



class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('마이페이지',
            style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.search), color: Colors.grey,
              onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Missions()),
            );
              }),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 0),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text("TODAY 님",style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text("현재등급 ",style: TextStyle(fontSize: 24.sp, fontFamily: 'korean') ),
                        Text("Lv18",style: TextStyle(color: AppColor.happyblue, fontSize: 24.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        Text("입니다",style: TextStyle(fontSize: 24.sp, fontFamily: 'korean') ),

                      ],
                    ),
                  ),

                  SizedBox(height: 15.h,),


                  Container(
                    width: 365.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Row(
                      children: [

                        SizedBox(width: 20.w,),

                        Container(
                          width: 90.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: AppColor.grey1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("나의 리워드",style: TextStyle(color: Colors.blue, fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                            ],
                          ),
                        ),

                        SizedBox(width: 30.w,),
                        Text("4,324,000,530원",style: TextStyle(color: AppColor.happyblue, fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ), //주간랭킹

                  SizedBox(height: 15.h,),

                  Container(
                    width: 365.w,
                    height:280.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h,),

                        Container(
                          child: Row(
                            children: [
                              SizedBox(width: 20.w,),
                              Text("미션 달성률",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10.h,),
                        Image.asset('assets/image/graph.png' , height: 200.h)

                      ],
                    ),
                  ), //주간랭킹

                  SizedBox(height: 15.h,),


                  Container(
                    width: 365.w,
                    height:260.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h,),
                        Container(
                          child: Row(
                            children: [
                              SizedBox(width: 20.w,),
                              Text("미션 참여빈도",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                              SizedBox(width: 120.w,),
                              Text("최근 3개월",style: TextStyle(color: Colors.grey,fontSize: 15.sp, fontFamily: 'korean') ),

                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),

                        Image.asset('assets/image/graph2.png' , height: 180.h),

                      ],
                    ),
                  ), //주간랭킹

                  SizedBox(height: 15.h,),


                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(365.w, 50.h),
                      textStyle: TextStyle(fontSize: 18.sp),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MissionFeed()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" 미션피드",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        Image.asset('assets/image/arrow-right1.png' )
                      ],
                    ),
                  ),

                  SizedBox(height: 15.h,),


                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(365.w, 50.h),
                      textStyle: TextStyle(fontSize: 18.sp),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PrivateSettings()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" 개인정보 설정",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        Image.asset('assets/image/arrow-right1.png' )
                      ],
                    ),
                  ),

                  SizedBox(height: 15.h,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(365.w, 50.h),
                      textStyle: TextStyle(fontSize: 18.sp),
                    ),

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Settings()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" 설정",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        Image.asset('assets/image/arrow-right1.png' )
                      ],
                    ),
                  ),

                  SizedBox(height: 15.h,),



                ],
              ),
            ),







          ],
        ),
      ),
    );
  }
}