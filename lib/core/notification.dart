import 'dart:convert';

import 'package:daycus/widget/certifyTool/pedometerWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

import '../backend/Api.dart';


final notifications = FlutterLocalNotificationsPlugin();


//1. 앱로드시 실행할 기본설정
initNotification() async {

  //안드로이드용 아이콘파일 이름
  var androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');


  var initializationSettings = InitializationSettings(
      android: androidSetting,
  );
  await notifications.initialize(
    initializationSettings,
    //알림 누를때 함수실행하고 싶으면
    //onSelectNotification: 함수명추가
  );
}
get_name_from_id(String id) async{
  try {
    var update_res = await http.post(Uri.parse(API.select), body: {
      'update_sql': "select user_name from user_table where user_id = '$id'",
    });

    if (update_res.statusCode == 200 ) {
      var resMission = jsonDecode(update_res.body);
      if (resMission['success'] == true) {
        return resMission['data'][0]['user_name'];
      } else {
        print("에러발생");
        print(resMission);
        Fluttertoast.showToast(msg: "다시 시도해주세요");
      }
    }
  } on Exception catch (e) {
    print("에러발생");
    Fluttertoast.showToast(msg: "업데이트 중 문제가 발생했습니다.");
  }
}
showNotification(String name) async {

  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );


  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,
      '$name 님과 친구가 되셨습니다 !',
      '지금 친구의 활동을 확인해보세요 !',
      NotificationDetails(android: androidDetails),
      payload:'부가정보' // 부가정보
  );
}

makeDate(hour, min, sec){
  var now = tz.TZDateTime.now(tz.local);
  var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
  if (when.isBefore(now)) {
    return when.add(Duration(days: 1));
  } else {
    return when;
  }
}

// time_showNotification() async {
//
//   tz.initializeTimeZones();
//
//   var androidDetails = const AndroidNotificationDetails(
//     '유니크한 알림 ID',
//     '알림종류 설명',
//     priority: Priority.high,
//     importance: Importance.max,
//     color: Color.fromARGB(255, 255, 0, 0)
//   );
//
//   notifications.zonedSchedule(
//       2,
//       '제목2',
//       '랭킹 업데이트가 반영되었습니다! 확인해보세요!',
//       tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
//       NotificationDetails(android: androidDetails),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time
//   );
// }
// continue_showNotification() async {
//
//   var androidDetails = const AndroidNotificationDetails(
//       '유니크한 알림 ID',
//       '알림종류 설명',
//       priority: Priority.high,
//       importance: Importance.max,
//       color: Color.fromARGB(255, 255, 0, 0)
//   );
//
//   notifications.show(
//       3,
//       '현재 걸음 수',
//       '$PedometerSteps',
//       NotificationDetails(android: androidDetails),
//   );
// }

