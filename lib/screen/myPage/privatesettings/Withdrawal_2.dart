import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/widget/PopPage.dart';
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

import '../../../backend/login/login.dart';



class Withdrawal2 extends StatefulWidget {
  const Withdrawal2({Key? key}) : super(key: key);

  @override
  State<Withdrawal2> createState() => _WithdrawalState();
}


class _WithdrawalState extends State<Withdrawal2> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

  final TextEditingController passwordCtrl = TextEditingController();

  bool? _isChecked = false;

  @override
  Widget build(BuildContext context) {

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
            await logout(false);
            checkUserState();
            Fluttertoast.showToast(msg: "탈퇴가 완료되었습니다.\nDayCus는 당신의 갓생을 응원합니다.");
          } else {
            // 이름을 바꿀 수 없는 상황?
          }
        }
      } catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: "다시 시도해주세요");
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
                    //height: 265.h,
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
                              Text("▣ 다시 한 번 확인해주세요!",style: TextStyle(fontSize: 14.w, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
                              SizedBox(height: 12.h,),

                              Container(
                                padding: EdgeInsets.fromLTRB(8.w, 10.h, 7.w, 15.h),

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

                        // Container(
                        //   height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                        // ),

                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text("정말 탈퇴하시겠습니까?",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', fontWeight: FontWeight.bold), textAlign: TextAlign.center, ),
                              SizedBox(height: 5.h,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                    width: 28.w,
                                    child: Checkbox(
                                        value: _isChecked,
                                        onChanged: (value) {
                                          setState(() {
                                            _isChecked = value;
                                          });
                                        }
                                    ),
                                  ),
                                  Text("위 내용을 확인했으며, 탈퇴를 진행합니다.",style: TextStyle(fontSize: 11.sp, fontFamily: 'korean',),  ),

                                ],
                              ),

                              SizedBox(height: 20.h,),

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

                          if (_isChecked==false){
                            Fluttertoast.showToast(msg: "내용을 확인해주세요");
                          }

                          else {
                            PopPage("회원 탈퇴", context,
                              Text("정말 탈퇴하시겠습니까?"),
                              "취소", "탈퇴",
                                  (){
                                Navigator.pop(context);
                              },
                                  (){
                                remove_user();
                              },);
                          }
                          // 탈퇴와 취소 반대로

                        },

                        child: Container(
                          width: 110.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
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
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("취소",
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