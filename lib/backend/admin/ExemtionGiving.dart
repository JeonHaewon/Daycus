import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExemptionGiving extends StatefulWidget {
  const ExemptionGiving({Key? key}) : super(key: key);

  @override
  State<ExemptionGiving> createState() => _ExemptionGivingState();
}

class _ExemptionGivingState extends State<ExemptionGiving> {
  @override

  // 04.11 - 창을 나갈 때 데이터베이스에 업데이트 된다.
  void dispose() {
    super.dispose();

    if (user_data['exemption']!=null){
      update_request(
          "UPDATE user_table SET exemption = ${user_data['exemption']} where user_email = '${user_data['user_email']}'",
          "면제권 정보가 반영되었습니다");
    }

  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("면제권 부여 및 사용"),
      ),
      body: Column(
        children: [
          Text("\"${user_data['user_name']}\"님의 현재 면제권 개수 : ${user_data['exemption']}"),

          ElevatedButton(
              onPressed: (){

                setState(() {
                  user_data['exemption'] = (int.parse(user_data['exemption']) + 1).toString();
                  // sql 코드 : "UPDATE user_table SET exemption = exemption +1 where user_email = '${user_data['user_email']}'",
                  // sql 코드 :
                });
              },
              child: Text("면제권 부여하기"),),

          ElevatedButton(
            onPressed: (){

              if ( int.parse(user_data['exemption'])>0 ){
                setState(() {
                  user_data['exemption'] = (int.parse(user_data['exemption']) - 1).toString();
                   // sql 코드 : "UPDATE user_table SET exemption = exemption -1 where user_email = '${user_data['user_email']}'",
                });
              }
              else {
                Fluttertoast.showToast(msg: "면제권을 다 사용하셨습니다.");
              }


            },
            child:  Text("면제권 사용하기 "),),

        ],
      ),
    );
  }
}

