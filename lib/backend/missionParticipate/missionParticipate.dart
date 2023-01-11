import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/NowTime.dart';

missionParticipate(mission_id, user_email, bet_reward) async {

  String now = await NowTime('yy/MM/dd - HH:mm:ss');

  update_request(
      "INSERT INTO do_mission SET mission_id = '${mission_id}', user_email = '${user_email}', mission_start = '${now}', bet_reward = '${bet_reward}'",
      "미션 신청이 완료되었습니다 !");
  //
  // try {
  //   print("<missionParticipatePage> : $user_data");
  //   var select_res = await http.post(Uri.parse(API.update), body: {
  //     'update_sql': "INSERT INTO do_mission SET mission_id = '${mission_id}', user_email = '${user_email}', mission_start = '${now}', bet_reward = '${bet_reward}'",
  //   });
  //
  //   if (select_res.statusCode == 200 ) {
  //     var resMission = jsonDecode(select_res.body);
  //     // print(resMission);
  //     if (resMission['success'] == true) {
  //       print(resMission);
  //       Fluttertoast.showToast(msg: "미션 신청이 완료되었습니다 !");
  //
  //     } else {
  //       print("에러발생");
  //       print(resMission);
  //       Fluttertoast.showToast(msg: "다시 시도해주세요");
  //     }
  //
  //   }
  // } on Exception catch (e) {
  //   print("에러발생");
  //   Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
  // }
}

minus_reward(String bet_reward) async {
  // try {

    update_request(
        "UPDATE user_table SET reward = '${(double.parse(user_data['reward'])-double.parse(bet_reward)).toString()}' WHERE user_email = '${user_data['user_email']}'",
        null);

    // 삭제해야할수도 있음
    // 랭킹 업그레이드
    update_request("call update_ranking();", null);
    // 레벨 업데이트
    update_request("call update_level5();", null);

  //   var update_res = await http.post(Uri.parse(API.update), body: {
  //     'update_sql': "UPDATE user_table SET reward = '${(double.parse(user_data['reward'])-double.parse(bet_reward)).toString()}' WHERE user_email = '${user_data['user_email']}'",
  //   });
  //
  //   if (update_res.statusCode == 200 ) {
  //     var resMission = jsonDecode(update_res.body);
  //     // print(resMission);
  //     if (resMission['success'] == true) {
  //       user_data['reward'] = (double.parse(user_data['reward'])-double.parse(bet_reward)).toString();
  //     } else {
  //       print("에러발생");
  //       print(resMission);
  //       Fluttertoast.showToast(msg: "다시 시도해주세요");
  //     }
  //
  //   }
  // } on Exception catch (e) {
  //   print("에러발생");
  //   Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
  // }
}