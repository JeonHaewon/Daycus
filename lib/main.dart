import 'package:daycus/core/constant.dart';
import 'package:daycus/core/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:daycus/screen/LoginPageCustom.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:daycus/backend/admin/AdminPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin fltNotification = FlutterLocalNotificationsPlugin();

void pushFCMtoken() async {
  String? token=await messaging.getToken();
  print(token);
}

void initMessaging() {
  var androiInit = AndroidInitializationSettings(
      '@mipmap/ic_launcher'); //for logo
  var initSetting = InitializationSettings(android: androiInit,);
  fltNotification = FlutterLocalNotificationsPlugin();
  fltNotification.initialize(initSetting);
  var androidDetails =
  AndroidNotificationDetails('1', 'channelName',);
  var generalNotificationDetails =
  NotificationDetails(android: androidDetails,);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      fltNotification.show(
          notification.hashCode, notification.title, notification.
      body, generalNotificationDetails);
    }
  });
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Admob.initialize();
  initMessaging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


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
          // 그냥 로고 화면으로 갔다가 로그인이 필요한 경우에만 로그인 페이지로 가게끔 구현이 필요하다.
          home: LoginPageCustom(),
        );
      },
    );
  }
}

