import 'package:daycus/core/notification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UserDatabase.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  @override
  void dispose(){
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    initNotification();
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

    update_plus_reward() async {
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "UPDATE user_table SET reward = reward + 14 where user_email = '${user_data['user_email']}'",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "reward 업데이트가 완료되었습니다 !");

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

    update_ranking() async{
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "SET @r=0; UPDATE user_table SET Ranking= @r:= (@r+1) ORDER BY reward DESC;",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "랭킹 업데이트가 완료되었습니다 !");

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

    update_avg_reward() async{
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "with count_table as (select mission_id as mission_id, avg(bet_reward) as average from do_mission group by mission_id) UPDATE count_table A INNER JOIN missions B ON A.mission_id = B.mission_id SET B.average = A.average;",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "평균 리워드 업데이트가 완료되었습니다 !");

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
            SizedBox(height: 15.h,),
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
                time_showNotification();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("푸시 알림 보내기",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Image.asset('assets/image/arrow-right1.png' )
                ],
              ),
            ),
            SizedBox(height: 15.h,),
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
                update_ranking();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("랭킹 업데이트",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Image.asset('assets/image/arrow-right1.png' )
                ],
              ),
            ),
            SizedBox(height: 15.h,),
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
                update_avg_reward();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("평균 리워드 업데이트",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Image.asset('assets/image/arrow-right1.png' )
                ],
              ),
            ),
            SizedBox(height: 15.h,),
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
                update_plus_reward();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("리워드 더하기 버튼",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
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





