import 'package:daycus/backend/UserDatabase.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

userDataImport() async{
  try{
      var select_res = await http.post(Uri.parse(API.select), body: {
        'update_sql': "SELECT * FROM user_table WHERE user_email = 'haim1121@dgist.ac.kr'",
      });
      if (select_res.statusCode == 200) {
        var resUser = jsonDecode(select_res.body);
        print("resUser :  $resUser");
        if (resUser['success'] == true) {
          user_data = resUser['data'][0];

        } else {
          print("에러발생");
          Fluttertoast.showToast(msg: "사용자 정보를 불러오는 도중 오류가 발생했습니다");
        }

      }


  } catch (e) {
    print(e.toString());
    Fluttertoast.showToast(msg: e.toString());
  }
}