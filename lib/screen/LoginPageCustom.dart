import 'package:daycus/screen/HomePageCustom.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
                      validator: (String? value){
                        if (value!.isEmpty) {// == null or isEmpty
                          return '비밀번호를 입력해주세요.';}
                        return null;
                      },),
                  ),

                  Text("비밀번호", style: TextStyle(fontSize: 20.sp, fontFamily: 'korean'),),
                  SizedBox(
                    height: 80.h,
                    child : TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: passwordCtrl,
                      obscureText: true,
                      validator: (String? value){
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TemHomePage()),
                  );
                },

              child: Text('로그인'),

              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                minimumSize: Size(330.w, 40.h),
                textStyle: TextStyle(color : Colors.indigo),
              ),
            ),


            TextButton(onPressed: (){}, child:
            Text('비밀번호를 잊으셨나요?',
              style: TextStyle(color: Colors.grey[400], fontSize: 15),
            )),

            SizedBox(height: 150.h,),

            Container(
              width: 330.w,
              height: 40.h,
              color: Colors.white70,
              margin: EdgeInsets.symmetric(horizontal: 45.w),
              child: const Center(
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }



}
