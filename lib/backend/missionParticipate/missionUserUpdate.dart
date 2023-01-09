// import 'package:http/http.dart' as http;
// import 'package:daycus/backend/Api.dart';
// import 'package:daycus/backend/UserDatabase.dart';
// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
//

// sql 상에서 구현완료.


// missionUserUpdate(mission_id) async {
//   try {
//     var update_res = await http.post(Uri.parse(API.update), body: {
//       // 동시 접속 시 에러가 발생할 수 있으므로 sql 상에서 구현하기 바람.
//       'update_sql': "UPDATE missions SET now_user = '${int.parse(all_missions[int.parse(mission_id)-1]['now_user'])+1}', total_user = '${int.parse(all_missions[int.parse(mission_id)-1]['total_user'])+1}' WHERE (mission_id = '${mission_id}')",
//     });
//
//
//     var updateMission = jsonDecode(update_res.body);
//
//     if (updateMission['success'] == true) {
//       print("${updateMission}");
//     } else {
//       print("에러발생");
//       Fluttertoast.showToast(msg: "미션을 업데이트 하는 도중 문제가 발생했습니다.");
//     }
//
//   } on Exception catch (e) {
//     print("에러발생");
//     Fluttertoast.showToast(msg: "다시 시도해주세요");
//   }
// }

