import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PasswordSetting extends StatelessWidget {
  const PasswordSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('비밀번호 설정',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [


            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 50.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: '현재 비밀번호 입력',
                    ),
                  ),

                  SizedBox(height: 20.h,),

                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: '새로운 비밀번호 입력',
                    ),
                  ),

                  SizedBox(height: 20.h,),
                  
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: '새로운 비밀번호 재입력',
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
              child:TextButton(onPressed: (){}, child: Text('완료',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),
      
    );
  }
}