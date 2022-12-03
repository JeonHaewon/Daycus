import 'dart:convert';

import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/core/app_color.dart';
import 'package:daycus/screen/HomePageCustom.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/startPage/FindPasswordPage.dart';
import 'package:daycus/screen/startPage/SignupPage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/Api.dart';



class LoginPageCustom extends StatefulWidget {
  const LoginPageCustom({ Key? key }) : super(key: key);

  @override
  State<LoginPageCustom> createState() => KeepLoginPage();
}

class KeepLoginPage extends State<LoginPageCustom> {

  double textFieldHeight = 55.0;
  double loginFontSize = 40.0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  userLogin() async{
    try {
      var user_res = await http.post(
          Uri.parse(API.login),
          body: {
            'user_email' : emailCtrl.text.trim(),
            'user_password' : passwordCtrl.text.trim(),
          });

      if (user_res.statusCode == 200) {
        print("출력 : ${user_res.body}");
        var resLogin = jsonDecode(user_res.body);
        if (resLogin['success'] == true) {
          // 나중에 멘트 "~님 환영합니다" 이런걸로 바꾸기 (또는 논의해서 바꾸기)
          print("로그인에 성공하였습니다.");
          user_data = resLogin['userData'];
          print("{$user_data}");
          Fluttertoast.showToast(msg: "안녕하세요, ${resLogin['userData']['user_name']}님 !");

          // 사용자 정보 지우기
          setState(() {
            emailCtrl.clear();
            passwordCtrl.clear();
          } );

          // 페이지 이동 - 모든 창을 다 닫고
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>
              TemHomePage()),
                  (route) => false);

        } else {
          // 계정이 없다는 멘트도 띄워야할듯?
          Fluttertoast.showToast(msg: "이메일 또는 비밀번호가 올바르지 않습니다.");
          print("이메일 또는 비밀번호가 올바르지 않습니다.");

          // 비밀번호 틀리면 초기화 되는 익숙한 UX를 적용
          passwordCtrl.clear();
        }
      }
    }
    catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //print("페이지가 없어졌습니다");
    super.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Form(

        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(left: 40.w ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 200.h,),
                  Text("로그인".padRight(50), style: TextStyle(fontSize: 30.sp, fontFamily: 'korean'),),
                  SizedBox(height: 60.h,),
                ],
              ),
            ),

            Padding(padding: EdgeInsets.only(left: 40.w, right: 50.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("이메일", style: TextStyle(fontSize: 20.sp, fontFamily: 'korean'),),
                  SizedBox(
                    height: 80.h,
                    child : TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailCtrl,

                      // 이메일 검증
                      validator: (String? value){
                        if (value!.isEmpty) {// == null or isEmpty
                          return '이메일을 입력해주세요.';}
                        else if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)!=true){
                          return '올바른 이메일 형식을 입력해주세요.';
                        }

                        return null;
                      },),
                  ),

                  SizedBox(height: 10.h,),

                  Text("비밀번호", style: TextStyle(fontSize: 20.sp, fontFamily: 'korean'),),
                  SizedBox(
                    height: 80.h,
                    child : TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: passwordCtrl,
                      obscureText: true,
                      validator: (String? value){
                        // 비밀번호 틀렸을 때 여기서 빨간색으로 나타낼 수 있었음 좋겠는뎅..
                        
                        // 비밀번호 검증
                        if (value!.isEmpty) {// == null or isEmpty
                          return '비밀번호를 입력해주세요.';
                        }
                        return null;
                      },),
                  ),

                ],
              ),
            ),

            ElevatedButton(
                onPressed: () {
                  // 로그인 버튼 눌렀을 때
                  if (_formKey.currentState!.validate()){
                    userLogin();

                  }

                },

              child: Text('로그인'),

              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                minimumSize: Size(330.w, 40.h),
                textStyle: TextStyle(color : Colors.indigo),
              ),
            ),


            TextButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FindPasswordPage()),
              );
            }, child:
            Text('비밀번호를 잊으셨나요?',
              style: TextStyle(color: Colors.grey[400], fontSize: 15),
            )),

            SizedBox(height: 150.h,),


            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SignupPage()),
                );
              },

              child: Text('회원가입'),

              style: ElevatedButton.styleFrom(
                onPrimary: AppColor.happyblue,
                primary: Colors.white,
                minimumSize: Size(330.w, 40.h),
                textStyle: TextStyle(color : Colors.indigo, fontWeight: FontWeight.bold),
              ),
            ),






          ],
        ),
      ),
    );
  }



}
