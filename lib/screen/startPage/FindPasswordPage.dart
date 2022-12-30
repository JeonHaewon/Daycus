import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

final TextEditingController emailCtrl = TextEditingController();

class FindPasswordPage extends StatelessWidget {
  const FindPasswordPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    void is_enrolled(texting) async {
      try {
        var select_res = await http.post(Uri.parse(API.update), body: {
          // 이거 'update_sql'로 바꾸어야함.
          'select_sql': "SELECT * FROM user_table WHERE user_email = '${texting}'",
        });

        if (select_res.statusCode == 200 ) {
          var resMission = jsonDecode(select_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "이메일을 확인해주세요 !");
          } else {
            Fluttertoast.showToast(msg: "존재하지 않는 이메일입니다.");
          }

        }
      } on Exception catch (e) {
        print("에러발생 : ${e}");
        Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
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

                  TextField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: '이메일 주소',
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: AppColor.happyblue,
        child: Row(
          children: [
            SizedBox(
              height: 70.h,
              width: 412.w,
              child:TextButton(onPressed: (){
                is_enrolled(emailCtrl.text.trim());
              }, child: Text('비밀번호 찾기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),
      
    );
  }
}