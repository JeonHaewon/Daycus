import 'package:flutter/material.dart';
import 'package:daycus/screen/LoginPageCustom.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: Size(412, 892),
      builder: (context, child) {
        return MaterialApp(
          title: 'First Method',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LoginPageCustom(),
        );
      },
    );
  }
}