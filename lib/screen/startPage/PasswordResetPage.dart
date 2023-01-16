import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:daycus/screen/LoginPageCustom.dart';
import 'package:daycus/screen/startPage/FindPasswordPage.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../backend/Api.dart';

final TextEditingController want_password = TextEditingController();
final TextEditingController want_real_password = TextEditingController();
var want;
var want_real;

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

update_information_password(String want) async {
  try{
    var update_res = await http.post(Uri.parse(API.update), body: {
      'update_sql': "UPDATE DayCus.user_table SET user_password = '${generateMd5(want)}' WHERE (user_email = '$stored_email')",
    });

    if (update_res.statusCode == 200) {
      print("출력 : ${update_res.body}");
      var resLogin = jsonDecode(update_res.body);
      if (resLogin['success'] == true) {
        print("성공적으로 반영되었습니다");

      } else {
        // 이름을 바꿀 수 없는 상황?
      }
    }
  } catch (e) {
    print(e.toString());
    Fluttertoast.showToast(msg: e.toString());
  }
}


class PasswordResetPage extends StatelessWidget {
  const PasswordResetPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


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
                  Text("비밀번호 재설정",style: TextStyle(fontSize: 22.sp, fontFamily: 'korean', ) ),
                  SizedBox(height: 15.h,),
                  
                  SizedBox(
                    height: 80.h,
                    child : TextFormField(
                      controller: want_password,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        hintText: '새로운 비밀번호를 입력해주세요',
                        hintStyle: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 80.h,
                    child : TextFormField(
                      controller: want_real_password,
                      decoration: InputDecoration(
                        labelText: '비밀번호 재입력',
                        hintText: '새로운 비밀번호를 확인해주세요',
                        hintStyle: TextStyle(fontSize: 14.sp),
                      ),
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
              child:TextButton(onPressed: () async {
                // bool? is_real = await is_enrolled(emailCtrl.text.trim());
                // if (is_real == true){
                //   sendPasswordResetEmail(emailCtrl.text.trim());
                // }
                if (want_real_password.text.trim() == want_password.text.trim()){
                  if (want_password.text.trim().length < 10 || want_password.text.trim().length > 16){
                    Fluttertoast.showToast(msg: "비밀번호는 10~16자리로 설정해주세요!");
                  }
                  else if (((RegExp(r'(\d+)').hasMatch(want_password.text.trim()) ? 1:0)+(RegExp(r'[a-zA-Z]').hasMatch(want_password.text.trim()) ? 1:0)+(RegExp(r'[@$!%*#?&]').hasMatch(want_password.text.trim()) ? 1:0))<2){
                    Fluttertoast.showToast(msg: "영문/숫자/특수문자 중 2가지를 조합하여 만들어주세요!");
                  }
                  else{
                    update_information_password(want_password.text.trim());
                    Fluttertoast.showToast(msg: "비밀번호 변경이 완료되었습니다 !");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPageCustom()),
                    );
                  }
                }
                else{
                  Fluttertoast.showToast(msg: "비밀번호가 일치하지 않습니다 !");
                }
              }, child: Text('비밀번호 재설정',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),

    );
  }
}