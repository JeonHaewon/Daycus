import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
                      //controller: ,
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
                      //controller: ,
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
              }, child: Text('비밀번호 재설정',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),

    );
  }
}