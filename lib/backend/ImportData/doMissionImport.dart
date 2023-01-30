import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/Api.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/UpdateRequest.dart';


doMissionImport() async {
  // 성공적으로 불러와도 하고 있는 미션이 없는 경우 false가 나올 수 있음
  do_mission = await select_request(
      "SELECT * FROM do_mission WHERE user_email = '${user_data['user_email']}' order by do_id desc;",
      null, false);

  if (do_mission==false){
    do_mission = null;
  }
}

// all_mission_data에 이 미션이 참여중인 미션이란 걸 표기. - 수정 필요
// do_mission에서 어디에 있는지 기록
doMissionSave( ) {
  int cnt = do_mission==null ? 0 : do_mission.length;
  for (int i=0 ; i<cnt ; i++){

    int _index = all_missions.indexWhere((all_data) => all_data['mission_id'] == do_mission[i]['mission_id']);
    all_missions[_index]['now_user_do'] = i;
    do_mission[i]['mission_index'] = _index;

  }
  //print("하는 미션들 업데이트 완료 : ${all_missions}");
}

