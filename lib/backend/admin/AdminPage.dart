import 'package:daycus/backend/admin/PedometerPage.dart';
import 'package:daycus/backend/admin/imageDownload.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:daycus/core/notification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pedometer/pedometer.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}


class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {

  static final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {

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
          'update_sql': "with rank_table as (select user_email as user_email, dense_rank() over(order by reward desc) as Ranking from user_table) update rank_table A inner join user_table B on A.user_email = B.user_email SET B.Ranking = A.Ranking;",
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

          Text("개발자"),
          Text("202111152 이하임 CTO : 2022.03.01 ~"),
          Text("202011140 이기범 CUOP : 2022.12.20 ~"),

            SizedBox(height: 15.h,),


            AdminButton(
              title: "던미션 테스트용",
              onPressed: (){
                Fluttertoast.showToast(msg: "데이터 손실을 막기 위해 사용을 중지했습니다.");
                // move_to_done_mission();
                // bool finished = true;
                // if (finished) {
                //   delete_from_do_mission();
                // }
              },),

            AdminButton(
              title: "푸시 알림 보내기",
              onPressed: (){
                time_showNotification();
              },
            ),

            AdminButton(
              title: "랭킹 업데이트",
              onPressed: (){
                update_ranking();
              },
            ),

            AdminButton(
              title: "평균 리워드 업데이트",
              onPressed: (){
                update_avg_reward();
              },
            ),

            AdminButton(
              title: "리워드 더하기 버튼",
              onPressed: (){
                update_plus_reward();
              },
            ),

            AdminButton(
              title: "만보기를 한번 해봅시다 !",
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PedometerPage()));
              },
            ),

            AdminButton(
              title: "데이터 re-load (재로그인)",
              onPressed: (){
                print("로그인 ㄱㄱ");
                LoginAsyncMethod(storage, null, true);
                Fluttertoast.showToast(msg: "데이터 리로드가 완료되었습니다 !");
              },
            ),

            AdminButton(
              title: "이미지 다운",
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ImageDownload()));
              },
            )

          ],
        ),
      ),
    );
  }
}

class AdminButton extends StatelessWidget {
  const AdminButton({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  final onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
              Image.asset('assets/image/arrow-right1.png' )
            ],
          ),
        ),

        SizedBox(height: 15.h,),
      ],
    );
  }
}




