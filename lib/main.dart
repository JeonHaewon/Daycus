import 'package:daycus/core/notification.dart';
import 'package:flutter/material.dart';
import 'package:daycus/screen/LoginPageCustom.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  Widget build(BuildContext context) {
    initNotification();
    return ScreenUtilInit(
      designSize: Size(412, 892),
      builder: (context, child) {
        return MaterialApp(
          title: 'First Method',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // 그냥 로고 화면으로 갔다가 로그인이 필요한 경우에만 로그인 페이지로 가게끔 구현이 필요하다.
          home: LoginPageCustom(),
        );
      },
    );
  }
}

