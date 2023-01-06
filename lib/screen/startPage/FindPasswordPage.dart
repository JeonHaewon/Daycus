import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:daycus/screen/startPage/PasswordResetPage.dart';


final TextEditingController emailCtrl = TextEditingController();

Future<void> sendPasswordResetEmail(String email) async{
  await FirebaseAuth.instance.setLanguageCode("kr");
  await FirebaseAuth.instance.sendPasswordResetEmail(email:email);
}

class FindPasswordPage extends StatelessWidget {
  const FindPasswordPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    is_enrolled(texting) async {
      try {
        var select_res = await http.post(Uri.parse(API.update), body: {
          // 이거 'update_sql'로 바꾸어야함.
          'update_sql': "SELECT * FROM user_table WHERE user_email = '${texting}'",
        });

        if (select_res.statusCode == 200 ) {
          var resMission = jsonDecode(select_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "이메일을 확인해주세요 !");
            return true;
          } else {
            Fluttertoast.showToast(msg: "존재하지 않는 이메일입니다.");
            return false;
          }

        }
      } on Exception catch (e) {
        print("에러발생 : ${e}");
        Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [


            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("비밀번호 찾기",style: TextStyle(fontSize: 22.sp, fontFamily: 'korean', ) ),
                  SizedBox(height: 15.h,),

                  // TextField(
                  //   controller: emailCtrl,
                  //   decoration: InputDecoration(
                  //
                  //     labelText: '이메일 주소',
                  //   ),
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      SizedBox(
                        height: 80.h,
                        width: 260.w,
                        child : TextFormField(
                          controller: emailCtrl,
                          decoration: InputDecoration(
                            labelText: '이메일 주소',
                            hintText: '가입한 이메일을 입력해주세요',
                            hintStyle: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 80.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("인증코드 받기",style: TextStyle(fontSize: 11.sp,  color: Colors.grey[800], fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      SizedBox(
                        height: 80.h,
                        width: 260.w,
                        child : TextFormField(
                          //controller: ,
                          decoration: InputDecoration(
                            labelText: '인증코드',
                            hintText: '이메일로 받은 인증코드를 입력해주세요',
                            hintStyle: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => PasswordResetPage()));
                        },
                        child: Container(
                          width: 80.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("확인",style: TextStyle(fontSize: 11.sp,  color: Colors.grey[800], fontWeight: FontWeight.bold)),
                              ],
                            ),
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

      // bottomNavigationBar: BottomAppBar(
      //   color: AppColor.happyblue,
      //   child: Row(
      //     children: [
      //       SizedBox(
      //         height: 70.h,
      //         width: 412.w,
      //         child:TextButton(onPressed: () async {
      //           bool? is_real = await is_enrolled(emailCtrl.text.trim());
      //           if (is_real == true){
      //             sendPasswordResetEmail(emailCtrl.text.trim());
      //           }
      //         }, child: Text('비밀번호 찾기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
      //       ),
      //     ],
      //   ),
      // ),
      
    );
  }
}