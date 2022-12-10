
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/core/app_color.dart';

import 'package:daycus/screen/temHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/startPage/FindPasswordPage.dart';
import 'package:daycus/screen/startPage/SignupPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../backend/login.dart';
import 'dart:convert';




class LoginPageCustom extends StatefulWidget {
  const LoginPageCustom({ Key? key }) : super(key: key);

  @override
  State<LoginPageCustom> createState() => KeepLoginPage();
}

class KeepLoginPage extends State<LoginPageCustom> {

  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

  @override
  void initState() {
    super.initState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    // 페이지 빌드 후에 비동기로 콜백함수를 호출 : 처음에 위젯을 하나 생성후에 애니메이션을 재생
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });


  }

  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    userInfo = await storage.read(key:'login');
    print(userInfo);

    // 자동로그인이 필요한 경우
    if (userInfo!=null && user_data==null) {
      var userDecode = jsonDecode(userInfo);
      //print("userInfo : ${userDecode.runtimeType}");
      //print("userInfo : ${userDecode}");
      //print("${userDecode['user_email']}, ${userDecode['password']}");

      print(userDecode);
    await userLogin(userDecode['user_email'], userDecode['password']);
    //userLogin(userInfo['userName'], userInfo['password'], userInfo['user_email']);

      // 느린걸 좀 고쳐야겠다. 이걸 그 콜백함수 써서 구현하면? : 안되더라
      await afterLogin();
      // 다 닫고 ㄱㄱ
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => TemHomePage()), (route) => false);
    } // 자동로그인이 필요하지 않은 경우
    else if (userInfo!=null && user_data!=null) {
      // 다 닫고 ㄱㄱ
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => TemHomePage()), (route) => false);
    }
    else {
      print('로그인이 필요합니다');
    }
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
                onPressed: () async {
                  // 로그인 버튼 눌렀을 때
                  if (_formKey.currentState!.validate()){
                    bool? is_login = await userLogin(
                        emailCtrl.text.trim(),
                        passwordCtrl.text.trim(),
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
