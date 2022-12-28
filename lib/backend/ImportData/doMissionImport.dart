import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/Api.dart';
import 'package:daycus/backend/UserDatabase.dart';

doMissionImport() async {
  try {
    var select_res = await http.post(Uri.parse(API.select), body: {
      'update_sql': "SELECT * FROM do_mission WHERE user_email = '${user_data['user_email']}'",
    });

    var resMission = jsonDecode(select_res.body);

    if (resMission['success'] == true) {
      //print(resMission);
      do_mission = resMission['data'];

    } else {
      print("불러온 미션이 없습니다");
      // 불러올 미션이 없는 것 같음.
      //Fluttertoast.showToast(msg: ".");
    }

  } on Exception catch (e) {
    print("do mission : $e");
    Fluttertoast.showToast(msg: "다시 시도해주세요");
  }
}

// all_mission_data에 이 미션이 참여중인 미션이란 걸 표기. - 수정 필요
// do_mission에서 어디에 있는지 기록
doMissionSave( ) {
  int cnt = do_mission?.length;
  for (int i=0 ; i<cnt ; i++){

    int _index = all_missions.indexWhere((all_data) => all_data['mission_id'] == do_mission[i]['mission_id']);
    all_missions[_index]['now_user_do'] = i;
    do_mission[i]['mission_index'] = _index;

  }
  //print("하는 미션들 업데이트 완료 : ${all_missions}");
}