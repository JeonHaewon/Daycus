import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AccountSetting extends StatelessWidget {
  const AccountSetting({Key? key}) : super(key: key);

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
        title: Text('계정 설정',
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
                  Image.asset('assets/image/settings/Profile.png',),
                  SizedBox(height: 10.h,),


                  SizedBox(height: 30.h,),
                  

                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: '닉네임',
                    ),
                  ),

                  SizedBox(height: 20.h,),

                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: '이메일',
                    ),
                  ),


                ],
              ),
            ),







          ],
        ),
      ),
    );
  }
}