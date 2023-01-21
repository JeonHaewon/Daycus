import 'dart:convert';

import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:daycus/screen/startPage/TermsOfService_1.dart';
import 'package:daycus/screen/startPage/Marketing_3.dart';



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

  Future<bool> createUser(String email, String pw) async{
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: email,
          password: pw);
    } on FirebaseException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: '이미 존재하는 이메일입니다!');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
    return true;
  }

  saveInfo() async{
    Userr userModel = Userr(
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
          Future<bool> is_update_in_firebase = createUser(emailCtrl.text.trim(),passwordCtrl.text.trim());

          // 랭킹 업그레이드
          update_request("call update_ranking();", null);

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

  final TextEditingController customMissionCtrl = TextEditingController();

  var agree_all = Icons.check_box_outline_blank;
  var agree_1 = Icons.check_box_outline_blank;
  var agree_2 = Icons.check_box_outline_blank;
  var agree_3 = Icons.check_box_outline_blank;



  @override
  void dispose() {
    super.dispose();
    passwordCtrl.clear();
    passwordCheckCtrl.clear();
    emailCtrl.clear();
    customMissionCtrl.clear();
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
                padding: EdgeInsets.fromLTRB(45.w, 50.h, 45.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("회원가입",style: TextStyle(fontSize: 22.sp, fontFamily: 'korean', ) ),
                    SizedBox(height: 35.h,),



                    Text("이메일", style: TextStyle(fontSize: 15.sp, fontFamily: 'korean',),),

                    SizedBox(
                      height: 80.h,
                      child : TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          hintText: '이메일 입력',
                          hintStyle: TextStyle(fontSize: 12.sp),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.happyblue),//<-- SEE HERE
                          ),
                        ),
                        cursorColor: AppColor.happyblue,
                        // 이메일 검증
                        validator: (String? value){
                          if (value!.isEmpty) {// == null or isEmpty
                            return '이메일을 입력해주세요.';}
                          else if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)!=true){
                            return '올바른 이메일 형식을 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                    ),


                    Text("비밀번호", style: TextStyle(fontSize: 15.sp, fontFamily: 'korean',),),

                    SizedBox(
                      height: 80.h,
                      child : TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: passwordCtrl,
                        decoration: InputDecoration(
                          hintText: '영문/숫자/특수문자 중 2가지 이상, 8~16자 입력',
                          hintStyle: TextStyle(fontSize: 12.sp),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.happyblue),//<-- SEE HERE
                          ),
                        ),
                        cursorColor: AppColor.happyblue,
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
                      ),
                    ),


                    Text("비밀번호 확인", style: TextStyle(fontSize: 15.sp, fontFamily: 'korean', ),),

                    SizedBox(
                      height: 80.h,
                      child : TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: passwordCheckCtrl,
                        decoration: InputDecoration(
                          hintText: '비밀번호 재입력',
                          hintStyle: TextStyle(fontSize: 12.sp),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.happyblue),//<-- SEE HERE
                          ),
                        ),
                        cursorColor: AppColor.happyblue,
                        obscureText: true,
                        validator: (String? value){
                          // 비밀번호 검증
                          if (value != passwordCtrl.text) {// == null or isEmpty
                            return '비밀번호가 일치하지 않습니다.';
                          }
                          return null;
                        },
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0,0, 0),
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
                              }, icon: Icon(agree_all, color: Colors.black), label: Text("모두 동의합니다",style: TextStyle(fontSize: 15.sp,  color: Colors.black),),
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),

                            ],
                          ),

                          // 세부 이용약관
                          Padding(padding: EdgeInsets.fromLTRB(15.w, 6.h, 10.w, 0),
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
                                      }, icon: Icon(agree_1, color: Colors.black), label: Text("이용약관 동의 [필수]",style: TextStyle(fontSize: 12.sp,  color: Colors.black),),
                                      style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        padding: EdgeInsets.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),),


                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => TermsOfService()),
                                        );
                                      },
                                      child: Container(
                                        width: 54.w,
                                        height: 22.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("보기 >",style: TextStyle(fontSize: 11.sp,  color: Colors.grey[800], fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),


                                    ),


                                  ],
                                ),



                                SizedBox(height: 3.h,),


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
                                    }, icon: Icon(agree_2, color: Colors.black,), label: Text("개인정보 취급방침 동의 [필수]",style: TextStyle(fontSize: 12.sp,  color: Colors.black)),
                                      style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        padding: EdgeInsets.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),),


                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => PrivacyStatement()),
                                        );
                                      },
                                      child: Container(
                                        width: 54.w,
                                        height: 22.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("보기 >",style: TextStyle(fontSize: 11.sp,  color: Colors.grey[800], fontWeight: FontWeight.bold)),
                                            ],
                                          ),

                                        ),
                                      ),

                                    ),


                                  ],
                                ),

                                SizedBox(height: 3.h,),

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
                                    }, icon: Icon(agree_3, color: Colors.black), label: Text("마케팅 정보 수신 동의 [선택]",style: TextStyle(fontSize: 12.sp,  color: Colors.black)),
                                      style: TextButton.styleFrom(
                                        minimumSize: Size.zero,
                                        padding: EdgeInsets.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),),

                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => Marketing()),
                                        );
                                      },
                                      child: Container(
                                        width: 54.w,
                                        height: 22.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("보기 >",style: TextStyle(fontSize: 11.sp,  color: Colors.grey[800], fontWeight: FontWeight.bold)),
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


                    SizedBox(height: 25.h,),

                    Text("추가하고 싶은 \"나만의 미션\"이 있나요?", style: TextStyle(fontSize: 15.sp, fontFamily: 'korean',),),

                    SizedBox(height: 8.h,),


                    Container(
                      width: 400.w,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("DayCus에서는 갓생을 위한 미션을 수행할 수 있습니다. 현재 '하루 물 한컵 마시기', '아침 9시 기상', '만보 걷기' 등의 미션이 있습니다. 하고 싶은 미션이 있다면 아래에 적어주세요! 빠른 시간 내에 여러분의 의견을 반영하여 미션을 추가하겠습니다 :)\n",
                                    style: TextStyle(fontSize: 10.sp, fontFamily: 'korean',) ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h,),


                    TextField(
                      controller: customMissionCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "추가하고 싶은 새로운 미션이 있나요?",
                        hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.happyblue),//<-- SEE HERE
                        ),
                      ),
                      cursorColor: AppColor.happyblue,
                    ),


                    SizedBox(height: 25.h,),












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
                if(_formKey.currentState!.validate() && agree['이용약관'] && agree['개인정보 취급방침']){
                  await checkUserEmail();

                  // 새로운 미션 추천받기 !
                  if (customMissionCtrl.text.trim()!=''){
                    DateTime today = await NowTime(null);
                    update_request(
                        "INSERT INTO to_developer (content, error_message, user_email, datetime, error_image) VALUES ('${customMissionCtrl.text.trim().replaceAll("'", "`")}', '테스터의 추천 미션', '${user_data['user_email']}', '${today.toString().substring(0,23)}', null);",
                        null);
                  }
                }
                else if (_formKey.currentState!.validate()==false){
                  // 이메일 입력을 안했을 때
                }
                else if (agree['이용약관']==false || agree['개인정보 취급방침']==false){
                  Fluttertoast.showToast(msg: "필수 약관을 동의해주세요 !");
                }
              }, child: Text('회원가입',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),

    );
  }
}