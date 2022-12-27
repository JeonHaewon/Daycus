import 'package:daycus/core/notification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/NowTime.dart';

Future<bool> appInitialize({required BuildContext context}) async {
  LocalNotification.initialize();

  await Future.delayed(const Duration(milliseconds: 1000), () {});
  return true;
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late Future appInit;

  @override
  void initState() {
    appInit = appInitialize(context: context);
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    LocalNotification.requestPermission();
    move_to_done_mission() async {
      String now = await NowTime('yy/MM/dd - HH:mm:ss');
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "INSERT INTO Done_mission  select * from (select * from do_mission where (select(datediff('${now}',mission_start) >= 14))) dating",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "정산이 완료되었습니다 !");

          } else {
            print("에러발생");
            print(resMission);
            Fluttertoast.showToast(msg: "다시 시도해주세요");
          }

        }
      } on Exception catch (e) {
        print("에러발생");
        Fluttertoast.showToast(msg: "정산을 신청하는 도중 문제가 발생했습니다.");
      }
    }

    delete_from_do_mission() async{

      String now = await NowTime('yy/MM/dd - HH:mm:ss');
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "DELETE FROM do_mission where (datediff('${now}',mission_start) >= 14);",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "삭제가 완료되었습니다 !");

          } else {
            print("에러발생");
            print(resMission);
            Fluttertoast.showToast(msg: "다시 시도해주세요");
          }

        }
      } on Exception catch (e) {
        print("에러발생");
        Fluttertoast.showToast(msg: "삭제를 진행하는 도중 문제가 발생했습니다.");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("개발자 페이지"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                primary: Colors.white,
                onPrimary: Colors.black,
                minimumSize: Size(365.w, 50.h),
                textStyle: TextStyle(fontSize: 18.sp),
              ),

              onPressed: () {
                move_to_done_mission();
                bool finished = true;
                if (finished) {
                  delete_from_do_mission();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("던미션 테스트용",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Image.asset('assets/image/arrow-right1.png' )
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                primary: Colors.white,
                onPrimary: Colors.black,
                minimumSize: Size(365.w, 50.h),
                textStyle: TextStyle(fontSize: 18.sp),
              ),

              onPressed: () {
                LocalNotification.sampleNotification();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("푸시 알림 보내기",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Image.asset('assets/image/arrow-right1.png' )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}





