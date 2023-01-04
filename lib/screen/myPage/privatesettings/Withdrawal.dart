import 'package:flutter/material.dart';
import 'package:daycus/screen/LoginPageCustom.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/myPage/privatesettings/PrivateSettings.dart';
import '../../../backend/Api.dart';
import '../../../backend/NowTime.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/screen/myPage/privatesettings/AccountSetting.dart';
import 'package:daycus/screen/myPage/privatesettings/PasswordSetting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Withdrawal extends StatefulWidget {
  const Withdrawal({Key? key}) : super(key: key);

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}


class _WithdrawalState extends State<Withdrawal> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';
  @override
  Widget build(BuildContext context) {

    logout() async {
      // 유저 정보 삭제 - 어플 내
      user_data = null;
      all_missions = null;
      do_mission = null;

      await storage.delete(key: 'login');
    }

    checkUserState() async {
      userInfo = await storage.read(key: 'login');
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

    // 회원 탈퇴를 적어주기만함. 실제 탈퇴는 데이터베이스에서 !
    remove_user() async {
      try{
        String cur = await NowTime('yyyy-MM-dd - HH:mm:ss');
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "UPDATE DayCus.user_table SET user_state = 'withdrawing', state_changed_time = '${cur}' WHERE (user_email = '${user_data['user_email']}')",
        });

        if (update_res.statusCode == 200) {
          print("출력 : ${update_res.body}");
          var resLogin = jsonDecode(update_res.body);
          if (resLogin['success'] == true) {
            logout();
            checkUserState();
          } else {
            // 이름을 바꿀 수 없는 상황?
          }
        }
      } catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: e.toString());
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
        // title: Text('회원 탈퇴',
        //     style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 0),
              child: Column(
                children: [

                  Container(
                    width: 500.w,
                    height: 220.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          padding: EdgeInsets.fromLTRB(30.w, 25.h, 30.w, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("▣ 회원탈퇴 정책",style: TextStyle(fontSize: 14.w, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
                              SizedBox(height: 12.h,),
                              Text("탈퇴하고 한 달 이후 사용하고 계신 아이디는 재사용 및 복구가 불가능합니다. 탈퇴한 아이디는 본인과 타인 모두 재사용 및 복구가 불가하오니 신중하게 선택하시기를 바랍니다.",style: TextStyle(fontSize: 11.sp, fontFamily: 'korean') ),

                              Container(
                                padding: EdgeInsets.fromLTRB(8.w, 10.h, 7.w, 8.h),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text("• 탈퇴한 아이디는 한 달 내로 복구할 수 있습니다.",style: TextStyle(fontSize: 10.sp, fontFamily: 'korean') ),
                                    SizedBox(height: 2.h,),
                                    Text("• 단, 탈퇴한 동안 미션 참여를 하지 않은 것으로 간주되며, 재로그인 했을 시 미션 참여현황이 반영되니 신중하게 선택하시기를 바랍니다.",style: TextStyle(fontSize: 10.sp, fontFamily: 'korean') ),
                                  ],

                                ),
                              ),


                            ],
                          ),
                        ),

                        Container(
                          height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        ),

                        Container(
                          padding: EdgeInsets.fromLTRB(50.w, 7.h, 50.w, 0),
                          child: Column(
                            children: [
                              Text("회원탈퇴를 누르면 안내사항을 모두 확인하였으며, 이에 동의한 것으로 간주됩니다.",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean'), textAlign: TextAlign.center, ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),


                  SizedBox(height: 10.h,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      TextButton(
                        onPressed: () {
                          remove_user();
                        },

                        child: Container(
                          width: 110.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("회원탈퇴",
                                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'korean', )
                              ),
                            ],
                          ),
                        ),
                      ),


                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),

                        child: Container(
                          width: 110.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColor.happyblue,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("뒤로가기",
                                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'korean', )
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
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