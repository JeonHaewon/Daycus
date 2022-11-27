import 'package:daycus/screen/LoginPageCustom.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/myPage/privatesettings/AccountSetting.dart';
import 'package:daycus/screen/myPage/privatesettings/PasswordSetting.dart';



class PrivateSettings extends StatelessWidget {
  const PrivateSettings({Key? key}) : super(key: key);

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
        title: Text('개인정보 설정',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [


            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/image/settings/Profile.png',),
                  SizedBox(height: 10.h,),
                  Text("닉네임",style: TextStyle(fontSize: 24.sp, fontFamily: 'korean') ),

                  SizedBox(height: 30.h,),
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
                        MaterialPageRoute(builder: (_) => AccountSetting()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" 계정 설정",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
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
                        MaterialPageRoute(builder: (_) => PasswordSetting()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" 비밀번호 설정",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
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
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>
                          LoginPageCustom()),
                              (route) => false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" 로그아웃",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
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
                        Text(" 회원탈퇴",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        Image.asset('assets/image/arrow-right1.png' )
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