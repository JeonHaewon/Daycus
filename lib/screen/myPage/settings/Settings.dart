import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/myPage/settings/NoticeSetting.dart';
import 'package:daycus/screen/myPage/settings/PictureSetting.dart';
import 'package:daycus/screen/myPage/settings/PublicSetting.dart';


class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('설정',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [


            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

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
                        MaterialPageRoute(builder: (_) => NoticeSetting()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" 알림 설정",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        Image.asset('assets/image/arrow-right1.png' )
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h,),
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
                        MaterialPageRoute(builder: (_) => PictureSetting()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" 사진 설정",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        Image.asset('assets/image/arrow-right1.png' )
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h,),
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
                        MaterialPageRoute(builder: (_) => PublicSetting()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" 공개범위",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        Image.asset('assets/image/arrow-right1.png' )
                      ],
                    ),
                  ),


                  SizedBox(height: 20.h,),
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

                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" 이용약관 및 운영정책",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        Image.asset('assets/image/arrow-right1.png' )
                      ],
                    ),
                  ),


                  SizedBox(height: 20.h,),
                  Container(
                    width: 365.w,
                    height:50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 13.h,),

                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text("     버전",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                              Text("V1.0     ",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean') ),
                            ],
                          ),
                        ),


                      ],
                    ),
                  ),

                ],
              ),
            ),







          ],
        ),
      ),
    );
  }
}