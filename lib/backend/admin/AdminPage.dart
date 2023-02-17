
import 'package:admob_flutter/admob_flutter.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/admin/MissionModify.dart';
import 'package:daycus/backend/admin/PhpMail.dart';
import 'package:daycus/backend/admin/LoginPopup.dart';
import 'package:daycus/screen/labelPage/LabelingEnd.dart';
import 'package:daycus/backend/admin/AlertDialogPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'dart:convert';
import 'package:in_app_review/in_app_review.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'dart:async';
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:sound_stream/sound_stream.dart';
import '../../screen/LoginPageCustom.dart';
import 'package:flutter/cupertino.dart';
import 'package:daycus/core/app_text.dart';


var imageFromDb;
var admobBannerId = 'ca-app-pub-3339242274230109/7848999030';

void rreett(){
  print("광고구현성공");
}

void showRewardFullBanner(Function callback) async {
  await RewardedAd.load(
    // adUnitId 는 "광고 단위 ID" 를 입력하도록 한다.
    adUnitId: "ca-app-pub-3940256099942544/5354046379",
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          // 기본 이벤트에 대한 정의부분
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              ad.dispose();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              ad.dispose();
            },
          );
          // 광고를 바로 보여주도록 하고
          // 광고조건 만족시 리워드에 대한 부분(callback 함수)을 실행한다.
          ad.show(onUserEarnedReward: (ad, reward) {
            callback();
          });
        },
        // 광고를 로드 실패하는 오류가 발생 서비스에 영향이 없도록 실행하도록 처리 했다.
        onAdFailedToLoad: (_) {
          callback();
        }
    ),
  );
}

_launchURL() async {
  const url = 'https://blog.naver.com/happy-circuit';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

get_no_data() async {
  try {
    var select_res = await http.post(Uri.parse(API.select), body: {
      'update_sql': "select image from image_data where labeled = '인증불가'"
    });
    if (select_res.statusCode == 200 ) {
      var resUser = jsonDecode(select_res.body);
      var imagedb = [];
      if (imagedb == null){
        imageFromDb = [];
      }
      for (var item in resUser['data']){
        imagedb.add(item.values);
      }
      imageFromDb = imagedb;
    }
  } on Exception catch (e) {
    print("에러발생~~ : ${e}");
    return [];
    //Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
  }
}

// create an instance

Future<bool> _getStatuses() async {
  Map<Permission, PermissionStatus> statuses =
  await [Permission.storage, Permission.camera].request();

  if (await Permission.camera.isGranted &&
      await Permission.storage.isGranted) {
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}
Future _scan() async {
  await _getStatuses();
}


String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  var changing_idx;

  dynamic userInfo = '';
  static final storage = FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  Widget build(BuildContext context) {

    logout() async {
      // 유저 정보 삭제 - 어플 내
      user_data = null;
      all_missions = null;
      do_mission = null;

      await storage.delete(key: 'login');
    }


    checkUserState() async {
      userInfo = await storage.read(key: 'login');
      if (userInfo == null) {
        print('로그인 페이지로 이동');
        // 화면 이동
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>
            LoginPageCustom()),
                (route) => false);// 로그인 페이지로 이동
      } else {
        print('로그인 중');
      }
    }

    Future<void> _authenticateWithBiometrics() async {
      bool authenticated = false;
      try {
        setState(() {
          _isAuthenticating = true;
          _authorized = 'Authenticating';
        });
        authenticated = await auth.authenticate(
          localizedReason:
          'Scan your fingerprint (or face or whatever) to authenticate',
        );
        setState(() {
          _isAuthenticating = false;
          _authorized = 'Authenticating';
        });
      } on PlatformException catch (e) {
        print(e);
        setState(() {
          _isAuthenticating = false;
          _authorized = 'Error - ${e.message}';
        });
        return;
      }
      if (!mounted) {
        return;
      }

      final String message = authenticated ? 'Authorized' : 'Not Authorized';
      setState(() {
        _authorized = message;
        if (message != 'Authorized'){
          logout();
          checkUserState();
        }
      });
    }

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

    without_json() async {
      try {
        var update_res = await http.post(Uri.parse(API.select), body: {
          'update_sql': "call without_json8('${user_data['user_email']}')",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "불러왔습니다!");
          } else {
            print("에러발생");
            Fluttertoast.showToast(msg: "다시 시도해주세요");
          }
        }
      } on Exception catch (e) {
        print("에러발생");
        Fluttertoast.showToast(msg: "정산을 신청하는 도중 문제가 발생했습니다.");
      }
    }

    String ok = 'done';
    change_to_done() async {
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "update missions set mission_state = '$ok' where datediff(current_date, end_date)>0;",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "done으로 옮겨짐 !");

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

    move_to_past_missions () async {
      await update_request("insert into past_missions ( select * from missions where datediff(current_date, end_date) >= 28 );", null);
      await update_request("delete from missions where datediff(current_date, end_date) >= 28;", null);
    }

    update_level() async {
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "call update_level3();",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "유저 레벨 업데이트가 완료되었습니다 !");

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
    update_level_individual() async {
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "call update_level5('${user_data['user_email']}');",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "유저 레벨 업데이트가 완료되었습니다 !");

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

    from_sql_d(String image) async {
      try {
        var select_res = await http.post(Uri.parse(API.select), body: {
          'update_sql': "call looping('$image')"
        });
        print("잘 됨");
        var resMission = jsonDecode(select_res.body);
        print(resMission);
        if (select_res.statusCode == 200 ) {
          if (resMission['success'] == true) {
            changing_idx = resMission['data'][0]['nm'];
            Fluttertoast.showToast(msg: "성공!");
          } else {
            print("에러발생");
            Fluttertoast.showToast(msg: "다시 시도해");
          }
        }
      } on Exception catch (e) {
        print("에러발생");
        print("error : $e");
      }
    }

    remove_sql_image(String idx, String image) async {
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "update do_mission set ${idx} = 0 where do_id = (SELECT SUBSTRING_INDEX(SUBSTRING_INDEX('$image', '.', 1), '_', -1))",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "됐다 !!!!!!");
          } else {
            print("에러발생!!!!!!");
            Fluttertoast.showToast(msg: "다시 시도해주");
          }

        }
      } on Exception catch (e) {
        print("에러발생");
        Fluttertoast.showToast(msg: "삭제를 진행하는 도중 문제가 발생했습니다.");
      }
    }


    update_user_count() async{
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "call update_user_cnt();",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "유저 수 업데이트가 완료되었습니다 !");

          } else {
            print("에러발생");
            print(resMission);
            Fluttertoast.showToast(msg: "다시 시도해주세요");
          }
        }
      } on Exception catch (e) {
        print("에러발생");
        Fluttertoast.showToast(msg: "업데이트 중 문제가 발생했습니다.");
      }
    }

    update_total_user_count() async{
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "call update_total_user();",
        });

        if (update_res.statusCode == 200 ) {
          var resMission = jsonDecode(update_res.body);
          // print(resMission);
          if (resMission['success'] == true) {
            Fluttertoast.showToast(msg: "유저 수 업데이트가 완료되었습니다 !");

          } else {
            print("에러발생");
            print(resMission);
            Fluttertoast.showToast(msg: "다시 시도해주세요");
          }
        }
      } on Exception catch (e) {
        print("에러발생");
        Fluttertoast.showToast(msg: "업데이트를 진행하는 도중 문제가 발생했습니다.");
      }
    }

    update_ranking() async{
      try {
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "call update_ranking();",
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

    move_to_image_labeled_data() async {
      await update_request("insert into image_labeled_data ( select * from image_data where label_done = 'done' );", null);
      await update_request("delete from image_data where label_done = 'done';", null);
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
            Fluttertoast.showToast(msg: "평균 ${rewardName} 업데이트가 완료되었습니다 !");
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Shoutout to HappyCircuit Developers\n",),
                Text("Front & BackEnd\n202111152 이하임 CTO : 2022.03.01 ~\n"),
                Text("Design & FrontEnd\n202111152 전해원 COO : 2022.03.01 ~\n"),
                Text("BackEnd\n202011140 이기범 CUOP : 2022.12.20 ~ 2023.02.15 \n"),
              ],
            ),

              SizedBox(height: 15.h,),

              AdminButton(
                title: "미션 수정하기",
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MissionModify()));
                },
              ),
              // AdminButton(
              //   title: "푸시 알림 보내기",
              //   onPressed: (){
              //     // time_showNotification();
              //   },
              // ),
              AdminButton(
                title: "past_missions으로 이동하기",
                onPressed: (){
                  move_to_past_missions();
                },
              ),
              AdminButton(
                title: "image_labeled_data로 옮기기",
                onPressed: (){
                  move_to_image_labeled_data();
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
                title: "maxed_lv 업데이트",
                onPressed: () async {
                  await update_request("update user_table set maxed_lv = '${int.parse(user_data['maxed_lv']) >= int.parse(user_data['user_lv']) ? user_data['maxed_lv'] : user_data['user_lv']}' where user_email = '${user_data['user_email']}'", null);
                },
              ),
              AdminButton(
                title: "유저 레벨 업데이트 !",
                onPressed: (){
                  update_level();
                  Fluttertoast.showToast(msg: "유저 레벨 업데이트가 완료되었습니다 !");
                },
              ),
              AdminButton(
                title: "앱 버전 업데이트 확인",
                onPressed: () async {
                  final newVersion = NewVersionPlus(
                    androidId: 'com.happycircuit.daycus',
                  );
                  basicStatusCheck(NewVersionPlus newVersion) {
                    newVersion.showAlertIfNecessary(context: context);
                  }
                  basicStatusCheck(newVersion);
                },
              ),
              AdminButton(
                  title: "사진 데이터 0으로 데이터베이스 업데이트",
                  onPressed: () async {
                    await get_no_data();
                    for (var item in imageFromDb!) {
                      item = item.toString();
                      item = item.substring(1,item.length-1);
                      print(item);
                      await from_sql_d(item);
                      await remove_sql_image(changing_idx, item);
                    }
                  }
              ),
              AdminButton(
                title: "image_labeling_cnt 다 0으로 업데이트",
                onPressed: () async {
                  await update_request("update user_table set this_week_label_cnt = 0;", null);
                },
              ),
              AdminButton(
                title: "중복 로그인 팝업",
                onPressed: (){

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPopup()));
                },
              ),
              AdminButton(
                title: "알림 팝업",
                onPressed: (){

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AlertDialogPage()));
                },
              ),
              AdminButton(
                title: "네이버 링크 이동 슛 ~",
                onPressed: (){
                  _launchURL();
                },
              ),
              AdminButton(
                title: "total user 수 변경 버튼",
                onPressed: (){
                  update_total_user_count();
                  Fluttertoast.showToast(msg: "유저 수 업데이트 성공했습니다 !");
                },
              ),
              AdminButton(
                title: "now user 수 변경 버튼",
                onPressed: (){
                  update_user_count();
                  Fluttertoast.showToast(msg: "유저 수 업데이트 성공했습니다 !");
                },
              ),
              AdminButton(
                title: "리뷰 슛 ~",
                onPressed: () async {
                  final InAppReview inAppReview = InAppReview.instance;

                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }},
              ),

              AdminButton(
                title: "굿 라벨링",
                onPressed: (){

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LabelingEnd()));
                },
              ),
              // AdminButton(
              //   title: "가져와봐 버튼",
              //   onPressed: (){
              //     from_sql_d();
              //     remove_sql_image(changing_idx);
              //   },
              // ),
              // AdminButton(
              //   title: "녹음을 한 번 해봅시다 !",
              //   onPressed: (){
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (_) => RecordingPage()));
              //   },
              // ),
              AdminButton(
                title: "php로 이메일 보내기 버튼",
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_)=> PhpMail()));
                },
              ),
              AdminButton(
                title: "기한 된거 done으로 표시하기",
                onPressed: (){
                  change_to_done();
                },
              ),
              // AdminButton(
              //   title: "jsondata 빼고 부르기",
              //   onPressed: (){
              //     without_json();
              //   },
              // ),
              // AdminButton(
              //   title: "녹음 미션",
              //   onPressed: (){
              //     Fluttertoast.showToast(msg: "녹음 미션은 일시적으로 막아두었습니다 - 이하임");
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(builder: (_) => RecordingPage()),
              //     // );
              //   },
              // ),
              // AdminButton(
              //   title: "랭킹 가져오기",
              //   onPressed: () async {
              //     int userRanking = int.parse(user_data['Ranking']);
              //     rankingList = await select_request(
              //         "select user_name, reward, Ranking, user_id From user_table WHERE (${userRanking-2}<=Ranking) AND (Ranking<=${userRanking+2}) ORDER BY Ranking;",
              //         "위 아래 2위를 불러왔습니다",
              //         true);
              //     print(rankingList);
              //   },
              // ),
              //
              // AdminButton(
              //     title: "이미지 다운로드",
              //     onPressed: (){
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(builder: (_) => ImageDownload()));
              //     },
              // ),
              AdminButton(
                title: "리워드 광고 나타내주기",
                onPressed: () async {
                  var dbcode = await get_logincode_db(user_data['user_email']);
                  var pfcode = await get_logincode_pf();
                  print(dbcode);
                  print(pfcode);
                },
              ),
              AdminButton(
                title: "리워드 광고 슛",
                onPressed: (){
                  showRewardFullBanner(rreett);
                },
              ),

              AdminButton(title: "테스트", onPressed: (){

              },),


              // AdminButton(
              //     title: "녹음 미션 2",
              //     onPressed: (){
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (_) => RecordTest())
              //       );
              //     },
              // ),
              //
              // AdminButton(
              //   title: "녹음 미션 3",
              //   onPressed: (){
              //     // Navigator.push(context,
              //     //     MaterialPageRoute(builder: (_) => StreamingExample())
              //     // );
              //   },
              // ),

              // Center(
              //   child: Container(
              //     child: AdmobBanner(
              //       adUnitId: admobBannerId,
              //       adSize: AdmobBannerSize.BANNER,
              //       onBannerCreated:
              //       (AdmobBannerController controller){},
              //     )
              //   )
              // )

            ],
          ),
        ),

      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: AdmobBanner(
                adUnitId: admobBannerId,
                adSize: AdmobBannerSize.BANNER,
                onBannerCreated:
                    (AdmobBannerController controller){},
              )
            )
          ],
        )
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

  final  onPressed;
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
          onPressed: user_data['user_state']!='exadmin' ?
              onPressed
              : (){
            Fluttertoast.showToast(msg: "DayCus 개발에 힘써주셔서 감사합니다.\n현재에는 실행 권한이 없습니다");
          },
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




