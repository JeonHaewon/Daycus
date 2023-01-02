import 'dart:convert';

import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/User.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:daycus/screen/startPage/PrivacyStatement_2.dart';



Map agree = {
  "이용약관" : false,
  "개인정보 취급방침" : false,
  "마케팅 정보" : false,
};

class SignupPage extends StatefulWidget {
  //const SignUpCustom({ Key? key }) : super(key: key);

  @override
  State<SignupPage> createState() => _signupPage();
}

class _signupPage extends State<SignupPage> {

  static final storage = FlutterSecureStorage();

  checkUserEmail() async {
    try{
      var response = await http.post(Uri.parse(API.validateEmail),
          body: {
            'user_email' : emailCtrl.text.trim()
          });


      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);

        if (responseBody["existEmail"] == true) {
          Fluttertoast.showToast(msg: "이미 사용하고 있는 이메일입니다.");
          // 데이터들 삭제
          passwordCtrl.clear();
          emailCtrl.clear();
          passwordCheckCtrl.clear();

          // 이용약관 초기화
        } else{
          await saveInfo();
        }
      }
    }catch(e){
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  saveInfo() async{
    User userModel = User(
      1,
      emailCtrl.text.trim(),
      passwordCtrl.text.trim(),
      
      agree['이용약관'],
      agree['개인정보 취급방침'],
      agree['마케팅 정보'],
    );

    try {
      var res = await http.post(
          Uri.parse(API.signup),
          body: userModel.toJson()
      );

      if (res.statusCode == 200) {
        print("출력 : ${res.body}");
        var resSignUp = jsonDecode(res.body);
        if (resSignUp['success'] == true) {
          print("$agree");
          Fluttertoast.showToast(msg: "성공적으로 가입 되었습니다.");

          bool? is_login = await userLogin(
            emailCtrl.text.trim(),
            passwordCtrl.text.trim(),
            false,
          );

          // - 로그인 성공
          if (is_login == true) {

            keepLogin(
                user_data['user_name'],
                emailCtrl.text.trim(),
                passwordCtrl.text.trim(),
                storage);


            await afterLogin();

            // 다 닫고 감.
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) => TemHomePage()), (route) => false);
          }
          //  - 로그인 실패
          else if (is_login == false) {
            // 비밀번호 틀리면 초기화 되는 익숙한 UX를 적용
            passwordCtrl.clear();
          }

          // 사용자 정보 지우기
          setState(() {
            emailCtrl.clear();
            passwordCtrl.clear();
            passwordCheckCtrl.clear();

          });



        }
      }

    }
    catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

    }
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController passwordCheckCtrl = TextEditingController();

  var agree_all = Icons.check_box_outline_blank;
  var agree_1 = Icons.check_box_outline_blank;
  var agree_2 = Icons.check_box_outline_blank;
  var agree_3 = Icons.check_box_outline_blank;



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordCtrl.clear();
    passwordCheckCtrl.clear();
    emailCtrl.clear();
  }

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

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [


              Padding(
                padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("회원가입",style: TextStyle(fontSize: 22.sp, fontFamily: 'korean', ) ),
                    SizedBox(height: 20.h,),
                    
                    // 이메일 검증
                    TextFormField(
                      controller: emailCtrl,
                      validator: (String? value){
                        if (value!.isEmpty) {// == null or isEmpty
                          return '이메일을 입력해주세요.';}
                        else if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)!=true){
                          return '올바른 이메일 형식을 입력해주세요.';
                        }
                        return null;
                      },
                      
                      decoration: InputDecoration(
                        labelText: '이메일',
                        hintText: '이메일을 입력해주세요',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1.w, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1.w, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20.h,),

                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      validator: (String? value){
                        // 비밀번호 검증
                        if (value!.isEmpty) {// == null or isEmpty
                          return '비밀번호를 입력해주세요.';
                        }
                        else if (value.length<10 || value.length>16){
                          return '비밀번호는 10~16자로 설정해주세요.';}
                        // 숫자 : RegExp(r'(\d+)')
                        // 알파벳 : RegExp(r'[a-zA-Z]')
                        // 특수문자 : RegExp(r'[@$!%*#?&]')
                        else if(((RegExp(r'(\d+)').hasMatch(value) ? 1:0)+(RegExp(r'[a-zA-Z]').hasMatch(value) ? 1:0)+(RegExp(r'[@$!%*#?&]').hasMatch(value) ? 1:0))<2){
                          return '영문/숫자/특수문자 중 2가지 이상 조합하여 주세요.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        hintText: '영문/숫자/특수문자 중 2가지 이상, 8~16자 입력',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1.w, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1.w, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h,),

                    TextFormField(
                      controller: passwordCheckCtrl,
                      obscureText: true,
                      validator: (String? value){
                        // 비밀번호 검증
                        if (value != passwordCtrl.text) {// == null or isEmpty
                        return '비밀번호가 일치하지 않습니다.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: '비밀번호 확인',
                        hintText: '비밀번호 재입력',
                        labelStyle: TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1.w, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1.w, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h,),

                    Padding(
                      padding: EdgeInsets.fromLTRB(3.w, 0,0, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TextButton.icon(onPressed: (){
                                setState(() {
                                  if(agree_all==Icons.check_box_outline_blank){
                                    agree_all = Icons.check_box_outlined; agree_1 = Icons.check_box_outlined; agree_2 = Icons.check_box_outlined; agree_3 = Icons.check_box_outlined;
                                    agree["이용약관"]=true; agree["개인정보 취급방침"]=true; agree["마케팅 정보"]=true;
                                  }else{
                                    agree_all = Icons.check_box_outline_blank; agree_1 = Icons.check_box_outline_blank; agree_2 = Icons.check_box_outline_blank; agree_3 = Icons.check_box_outline_blank;
                                    agree["이용약관"]=false; agree["개인정보 취급방침"]=false; agree["마케팅 정보"]=false;
                                  }
                                });
                              }, icon: Icon(agree_all, color: Colors.black), label: Text("모두 동의합니다",style: TextStyle(fontSize: 17.sp,  color: Colors.black),),),

                            ],
                          ),

                          // 세부 이용약관
                          Padding(padding: EdgeInsets.fromLTRB(10.w, 0, 10.w, 0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(
                                      onPressed: (){
                                        setState(() {
                                          if(agree_1==Icons.check_box_outline_blank){
                                            agree_1 = Icons.check_box_outlined;
                                            agree["이용약관"]=true;
                                          }else{
                                            agree_1 = Icons.check_box_outline_blank;
                                            agree["이용약관"]=false;
                                          }
                                        });
                                      }, icon: Icon(agree_1, color: Colors.black), label: Text("이용약관 동의 [필수]",style: TextStyle(fontSize: 14.sp,  color: Colors.black)),),

                                    TextButton(onPressed: (){

                                    }, child: Text("보기 >",style: TextStyle(fontSize: 14.sp,  color: Colors.black)),)
                                  ],
                                ),


                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(onPressed: (){
                                      setState(() {
                                        if(agree_2==Icons.check_box_outline_blank){
                                          agree_2 = Icons.check_box_outlined;
                                          agree["개인정보 취급방침"]=true;
                                        }else{
                                          agree_2 = Icons.check_box_outline_blank;
                                          agree["개인정보 취급방침"]=false;
                                        }
                                      });
                                    }, icon: Icon(agree_2, color: Colors.black,), label: Text("개인정보 취급방침 동의 [필수]",style: TextStyle(fontSize: 14.sp,  color: Colors.black)),),

                                    TextButton(onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => PrivacyStatement()),
                                      );
                                    }, child: Text("보기 >",style: TextStyle(fontSize: 14.sp,  color: Colors.black)),)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton.icon(onPressed: (){
                                      setState(() {
                                        if(agree_3==Icons.check_box_outline_blank){
                                          agree_3 = Icons.check_box_outlined;
                                          agree["마케팅 정보"]=true;
                                        }else{
                                          agree_3 = Icons.check_box_outline_blank;
                                          agree["마케팅 정보"]=false;}
                                      });
                                    }, icon: Icon(agree_3, color: Colors.black), label: Text("마케팅 정보 수신 동의 [선택]",style: TextStyle(fontSize: 14.sp,  color: Colors.black)),),

                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pushNamed('/TnCPage');
                                      },
                                      child: Text("보기 >",style: TextStyle(fontSize: 14.sp,  color: Colors.black)), )
                                  ],
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
            ],
          ),
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
                // 동의 안했으면 회원가입 불가
                if(_formKey.currentState!.validate()){
                  await checkUserEmail();
                }

              }, child: Text('회원가입',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),

    );
  }
}