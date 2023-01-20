import 'dart:math';

import 'package:daycus/backend/ImportData/imageDownload.dart';
import 'package:daycus/screen/LoginPageCustom.dart';
import 'package:daycus/widget/PopPage.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/myPage/privatesettings/AccountSetting.dart';
import 'package:daycus/screen/myPage/privatesettings/PasswordSetting.dart';
import 'package:daycus/screen/myPage/privatesettings/Withdrawal.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../backend/Api.dart';
import '../../../backend/NowTime.dart';

import 'dart:convert';



class PrivateSettings extends StatefulWidget {
  PrivateSettings({Key? key}) : super(key: key);

  static final storage = FlutterSecureStorage();

  @override
  State<PrivateSettings> createState() => _PrivateSettingsState();
}

class _PrivateSettingsState extends State<PrivateSettings> {
  dynamic userInfo = '';

  // 0109 하임 : 기존 프로필 사진이 있으면 그걸로 초기화 해주어야함.
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      InitAsyncMethod();
    });
  }

  InitAsyncMethod() async {
    profileImageReNamed = null;
    // 이거검토 필요
    //profileImageRename은 그대로 null임. 그래서 change 했는지를 판단할 수 있음.
    // if (user_data['profile']!=null && downloadProfileImage==null) {
    //   var result = await image_download_root(
    //       "image_application/user_profile", user_data['profile']);
    //   downloadProfileImage = result[0] ; profileDegree = result[1];
    // }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    logout() async {
      // 유저 정보 삭제 - 어플 내
      user_data = null;
      all_missions = null;
      do_mission = null;

      await PrivateSettings.storage.delete(key: 'login');
    }

    checkUserState() async {
      userInfo = await PrivateSettings.storage.read(key: 'login');
      if (userInfo == null) {
        print('로그인 페이지로 이동');
        // 화면 이동
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>
            LoginPageCustom()),
                (route) => false);// 로그인 페이지로 이동
      } else {
        print('로그인 중');
      }
    }


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
                  //Icon(Icons.account_circle_rounded, size: 100.w,),

                  Container(
                      padding: EdgeInsets.all(13.sp),

                      child: (profileImage==null)
                      // 고른 프로필 사진이 없을 때
                          ? (user_data['profile']==null || downloadProfileImage==null)
                          ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png"), radius: 60.sp,)
                          : Transform.rotate(angle: profileDegree* pi/180, child: CircleAvatar( backgroundImage: downloadProfileImage!.image, radius: 60.sp), )
                          : CircleAvatar( backgroundImage : FileImage(profileImage!), radius: 60.sp,)
                  ),

                  SizedBox(height: 10.h,),
                  Text("${user_data['user_name']}",style: TextStyle(fontSize: 24.sp, fontFamily: 'korean') ),

                  SizedBox(height: 5.h,),
                  Text("사용자 코드 : ",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean') ),

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

                    onPressed: () async {
                      PopPage(
                          "로그아웃", context,
                          Text("로그아웃 하시겠습니까?"),
                          "로그아웃",
                          "취소",
                          () async {
                            // 기획에서 어떻게 인사할건지 정하기
                            Fluttertoast.showToast(msg: "정상적으로 로그아웃 되었습니다.");
                            // 로그인 유지 삭제 및 정보 삭제
                            // 백그라운드에서 진행.
                            await logout();
                            checkUserState();
                            profileImage = null; downloadProfileImage = null; profileDegree = 0;
                          }, null,
                      );


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

                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Withdrawal()),
                      );
                    },
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
