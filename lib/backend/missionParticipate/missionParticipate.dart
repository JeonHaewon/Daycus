import 'package:daycus/backend/UserDatabase.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/NowTime.dart';

missionParticipate(mission_id, user_email, bet_reward) async {

  String now = await NowTime('yy/MM/dd - HH:mm:ss');

  try {
    print("<missionParticipatePage> : $user_data");
    var select_res = await http.post(Uri.parse(API.update), body: {
      'update_sql': "INSERT INTO do_mission SET mission_id = '${mission_id}', user_email = '${user_email}', mission_start = '${now}', bet_reward = '${bet_reward}'",
    });

    if (select_res.statusCode == 200 ) {
      var resMission = jsonDecode(select_res.body);
      // print(resMission);
      if (resMission['success'] == true) {
        print(resMission);
        Fluttertoast.showToast(msg: "미션 신청이 완료되었습니다 !");

      } else {
        print("에러발생");
        print(resMission);
        Fluttertoast.showToast(msg: "다시 시도해주세요");
      }

    }
  } on Exception catch (e) {
    print("에러발생");
    Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
  }
}