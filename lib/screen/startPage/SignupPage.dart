import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  var agree_all = Icons.check_box_outline_blank;
  var agree_1 = Icons.check_box_outline_blank;
  var agree_2 = Icons.check_box_outline_blank;
  var agree_3 = Icons.check_box_outline_blank;

  final _formKey = GlobalKey<FormState>();

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
                  Text("회원가입",style: TextStyle(fontSize: 22.sp, fontFamily: 'korean', ) ),
                  SizedBox(height: 20.h,),
                  
                  TextField(
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

                  TextField(
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      hintText: '영문, 숫자 조합 8~16자 입력',
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

                  TextField(
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

                                  TextButton(onPressed: (){}, child: Text("보기 >",style: TextStyle(fontSize: 14.sp,  color: Colors.black)),)
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

      bottomNavigationBar: BottomAppBar(
        color: AppColor.happyblue,
        child: Row(
          children: [
            SizedBox(
              height: 70.h,
              width: 412.w,
              child:TextButton(onPressed: (){}, child: Text('회원가입',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),

    );
  }
}