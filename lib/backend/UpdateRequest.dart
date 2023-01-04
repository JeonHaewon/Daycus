import 'dart:convert';
import 'package:daycus/core/app_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'Api.dart';
import 'UserDatabase.dart';

// 성공 시 true를 리턴, 각종 이유로 실패 시 false를 반환.
// 에러 메세지를 저장함.

update_request(String sql, String? successMessage) async {
  try {
    var update_res = await http.post(Uri.parse(API.update), body: {
      'update_sql': sql,
    });

    if (update_res.statusCode == 200 ) {
      var resMessage = jsonDecode(update_res.body);

      if (resMessage['success']==true) {
        // 성공 메세지가 있으면 메세지를 띄움
        if (successMessage!=null){
          Fluttertoast.showToast(msg: successMessage);
        }
        print("${sql.split(" ")[0]} 작업이 완료됨 : ${resMessage}");
        return true;
      }

      else {
        //print("에러발생");
        print("작업이 완료되지 않음 : ${resMessage}");
        last_error = "sql : ${sql} / resMessage : ${resMessage}";
        Fluttertoast.showToast(msg: "다시 시도해주세요");
        return false;
      }

    }
  } on Exception catch (e) {
    print("에러발생 : ${e}");
    last_error = "sql : ${sql} / error : ${e}";
    //Fluttertoast.showToast(msg: errorMessage);
    return false;
  }
}