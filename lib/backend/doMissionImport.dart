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
      print(resMission);
      do_mission = resMission['data'];

    } else {
      print("에러발생");
      Fluttertoast.showToast(msg: "미션을 불러오는 도중 문제가 발생했습니다.");
    }

  } on Exception catch (e) {
    print(e);
    Fluttertoast.showToast(msg: "다시 시도해주세요");
  }
}