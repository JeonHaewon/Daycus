import 'package:daycus/backend/UserDatabase.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';


missionImport() async{
  try {
    var res = await http.post(
      Uri.parse(API.missionImport),
    );

    if (res.statusCode == 200) {
      //print("출력 : ${res.body}");
      var resMission = jsonDecode(res.body);
      //print("미션 해독 : ${resMission}");
      //resMission = null;
      // 이거 null 관리 어떻게 하는지 잘 알아보고 수정할 필요가 있음.

      if (resMission['success'] == true) {
        //print("미션 불러오기를 성공하였습니다.");
        all_missions = resMission['missions'];

      } else {
        // 미션 불러오기 자체에 실패했으면, 해당 페이지 자체를 띄우거나 팝업 이미지를 띄워야할듯.
        //Fluttertoast.showToast(msg: "미션 불러오기에 실패하였습니다.");
        print("미션 불러오기에 실패하였습니다.");
        Fluttertoast.showToast(msg: "데이터 로드에 문제가 발생하였습니다.");


      }
    }
  }
  catch (e) {
    print(e.toString());
    //Fluttertoast.showToast(msg: e.toString());

  }
}

