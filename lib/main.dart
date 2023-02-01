
import 'dart:convert';

import 'package:daycus/core/notification.dart';
import 'package:daycus/screen/LoadingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

FlutterLocalNotificationsPlugin fltNotification = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  runApp(const MyApp());
  initNotification();
  time_showNotification();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // 진행중인 작업창에 띄워놓으면 해당 title로 뜰 수 있다

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScreenUtilInit(
      designSize: Size(412, 892),
      builder: (context, child) {
        return MaterialApp(
          title: 'DayCus',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          // 그냥 로고 화면으로 갔다가 로그인이 필요한 경우에만 로그인 페이지로 가게끔 구현이 필요하다.
          home: LoadingPage(),
          // LoginPageCustom(),
        );
      },
    );
  }
}

