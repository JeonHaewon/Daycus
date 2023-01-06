import 'dart:convert';

import 'package:daycus/backend/Api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class PhpMail extends StatelessWidget {
  PhpMail({Key? key}) : super(key: key);

  send_email_to_user(String email) async {
    try{
      var update_res = await http.post(Uri.parse(API.sendEmail),
          body: {
            "user_email" : "$email",
            "title" : "이것은 제목",
            "content" : "이것은 내용",
          });

      if (update_res.statusCode == 200) {
        //print(1);
        var res = jsonDecode(update_res.body);
        // print(res['success']);
        // print(res);
        // print(res.runtimeType);
        if (res['success']==true){
          print("이메일 보내기에 성공했습니다.");
          //Fluttertoast.showToast(msg: "메일 보내기에 성공했습니다 ~");
        } else{
          Fluttertoast.showToast(msg: "다시 시도해주세요");
        }

        return true;

      } else {

        print("<error : > ${update_res.body}");
        return false;
      }
    }
    catch (e) {
      print(e.toString());
      //Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  final TextEditingController sendEmailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextFormField(
            controller: sendEmailCtrl,
            decoration: InputDecoration(
              hintText: "메일을 보낼 이메일을 넣어주세요",
            ),
          ),
          TextButton(onPressed: (){

            send_email_to_user(sendEmailCtrl.text.trim());
          }, child: Text("메일을 보내봅시당 !!!")),
        ],
      ),
    );
  }
}
