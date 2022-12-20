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
      print("미션 해독 : ${resMission}");
      //resMission = null;
      // 이거 null 관리 어떻게 하는지 잘 알아보고 수정할 필요가 있음.

      if (resMission['success'] == true) {
        print("미션 불러오기를 성공하였습니다.");
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


// 카테고리별로 불러오기
// 그냥 index만 불러와도 될 것 같기도 하고 ㅎㅎ,,
// 네트워크 없이 동작할 수 있고, 그게 에러가 안난다면 제일 베스트
importMissionByCategory() async {

  List<String> categories = ["건강", "공부", "운동", "생활", "취미"];

  try{
    final int n = categories.length;
    for (int i=0 ; i<n ; i++) {
      var select_res = await http.post(Uri.parse(API.select), body: {
          'update_sql': "SELECT * FROM missions WHERE category = '${categories[i]}'",
      });
      if (select_res.statusCode == 200) {
        var resMission = jsonDecode(select_res.body);
        // print(resMission);
        if (resMission['success'] == true) {
          // 이 코드 수정 요함.
          if (i==0){
            missions_health = resMission['data'];
          } else if (i==1) {
            missions_study = resMission['data'];
          } else if (i==2) {
            missions_exer = resMission['data'];
          } else if (i==3) {
            missions_life = resMission['data'];
          } else if (i==4) {
            missions_hobby = resMission['data'];
          }
          // 성공하면 넘김

        } else {
          print("에러발생");
          // 왜 미션을 불러오는 도중 문제가 발생했다는 거야 !
          //Fluttertoast.showToast(msg: "미션을 불러오는 도중 문제가 발생했습니다.");
        }

      }
    }


  } catch (e) {
    print(e.toString());
    Fluttertoast.showToast(msg: e.toString());
  }
}