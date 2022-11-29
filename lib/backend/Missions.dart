import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Missions extends StatefulWidget {
  Missions({Key? key}) : super(key: key);

  @override
  State<Missions> createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  @override
  Widget build(BuildContext context) {

    missionImport() async{
      try {
        var res = await http.post(
            Uri.parse(API.missionImport),
            );

        if (res.statusCode == 200) {
          print("출력 : ${res.body}");
          var resMission = jsonDecode(res.body);
          print("미션 해독 : ${resMission}");
          //resMission = null;
          // 이거 null 관리 어떻게 하는지 잘 알아보고 수정할 필요가 있음.
          print("출력 : ${resMission.runtimeType != null ? resMission['missions'].length : 0}");
          print("테스트 : ${resMission['missions'][1]["title"]}"); // 출력 결과 : title


          if (resMission['success'] == true) {
            // 나중에 멘트 "~님 환영합니다" 이런걸로 바꾸기 (또는 논의해서 바꾸기)
            print("미션 불러오기를 성공하였습니다.");
            // Fluttertoast.showToast(msg: "안녕하세요, ${userInfo.user_name}님 :)");

          } else {
            // 미션 불러오기 자체에 실패했으면, 해당 페이지 자체를 띄우거나 팝업 이미지를 띄워야할듯.
            Fluttertoast.showToast(msg: "미션 불러오기에 실패하였습니다.");
            print("미션 불러오기에 실패하였습니다.");

          }
        }
      }
      catch (e) {
        print(e.toString());
        Fluttertoast.showToast(msg: e.toString());

      }
    }

    List<int> list = [1, 2, 3, 4, 5, 6, 7, 8];
    int extraindex = -2;

    return Scaffold(
      appBar: AppBar(

      ),

      body: Column(
        children: [
          Container(
            color: Colors.blue,
            height: 200.h, width: 300.w,
            child: ListView.builder(
              itemCount:
              (list.length % 2 == 0 ? list.length / 2 : list.length ~/ 2 + 1).toInt(),
              itemBuilder: (_, index) {
                extraindex += 2;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(list[extraindex].toString()),
                    if (extraindex + 1 < list.length)
                      Text(list[extraindex + 1].toString()),
                  ],
                );
              },
            ),
          ),

          TextButton(onPressed: (){
            missionImport();
          }, child: Text("불러오기")),
        ],
      ),
    );
  }
}
