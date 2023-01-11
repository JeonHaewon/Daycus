
import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/core/app_color.dart';

import 'package:daycus/screen/temHomePage.dart';
import 'package:daycus/widget/PopPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/startPage/FindPasswordPage.dart';
import 'package:daycus/screen/startPage/SignupPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../backend/login/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';




class LoginPageCustom extends StatefulWidget {
  const LoginPageCustom({ Key? key }) : super(key: key);

  @override
  State<LoginPageCustom> createState() => KeepLoginPage();
}

class KeepLoginPage extends State<LoginPageCustom> {

  static final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    // 페이지 빌드 후에 비동기로 콜백함수를 호출 : 처음에 위젯을 하나 생성후에 애니메이션을 재생
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoginAsyncMethod(storage, context, false);
    });
  }

  double textFieldHeight = 55.0;
  double loginFontSize = 40.0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  // 리소스 분리 필요
  // 이거 속도가 좀 딜레이돼서 그 중간 페이지나 로딩 화면 띄워야할듯 ?!


  @override
  void dispose() {
    //print("페이지가 없어졌습니다");
    super.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,

      body: SingleChildScrollView(
        child: Form(
          // key는 왜필요한거지?
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

                        decoration: InputDecoration(
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
                        },),
                    ),

                    SizedBox(height: 10.h,),

                    Text("비밀번호", style: TextStyle(fontSize: 20.sp, fontFamily: 'korean'),),
                    SizedBox(
                      height: 80.h,
                      child : TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: passwordCtrl,

                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.happyblue),//<-- SEE HERE
                          ),
                        ),
                        cursorColor: AppColor.happyblue,

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
                  onPressed: () async {
                    // 로그인 버튼 눌렀을 때
                    if (_formKey.currentState!.validate()){
                      bool? is_login = await userLogin(
                          emailCtrl.text.trim(),
                          passwordCtrl.text.trim(),
                          false,
                      );

                      // - 로그인 성공
                      if ((is_login == true)&&(user_data['user_state']!='withdrawing')) {
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
                       // 탈퇴중인 경우
                      else if (is_login==true && user_data['user_state']=='withdrawing'){

                        passwordCtrl.clear();
                        DateTime today = await NowTime(null);

                        PopPage(
                            "계정 복구하기", context,
                            Column(
                              children: [
                                Text("이 계정은 탈퇴한지 ${(today.difference(DateTime.parse(user_data['state_changed_time']))).inDays}일이 지난 계정입니다. 복구하기를 누르면 탈퇴 전의 정보들은 모두 복구되며 탈퇴한 기간 동안은 미션에 참여하지 않은 것으로 간주됩니다. 복구하시겠습니까?"),
                                //Text("탈퇴한지 ${(today.difference(DateTime.parse(user_data['state_changed_time']))).inDays+1}일째"),
                              ],
                            ), "복구하기", "취소",

                            // 확인을 눌렀을 때
                            () async {
                              bool success = await update_request("UPDATE user_table SET user_state=null, state_changed_time='${today.toString().substring(0,22)}' where user_email = '${user_data['user_email']}'", null);
                              if (success) {
                                Fluttertoast.showToast(msg: "다시 한 번 ${user_data['user_name']}님의 갓생을 응원합니다.\n다시 로그인해주세요.");
                                Navigator.pop(context);
                              }
                        // 다시 로그인 해달라고 하기 ㅋㅋㅋ
                            },

                            // 취소를 눌렀을 때
                            null
                          );
                            }

                      //  - 로그인 실패
                      else if (is_login == false) {
                        // 비밀번호 틀리면 초기화 되는 익숙한 UX를 적용
                        passwordCtrl.clear();
                      }

                      else{
                        print("로그인 에러 발생");
                      }

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

              SizedBox(height: 120.h,),


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
      ),
    );
  }



}
