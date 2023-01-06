
import 'package:daycus/backend/admin/PedometerPage.dart';
import 'package:daycus/core/notification.dart';
import 'package:daycus/backend/admin/RecordingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'dart:async';
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:typed_data';
// import 'package:sound_stream/sound_stream.dart';
import '../../screen/LoginPageCustom.dart';
import 'package:flutter/cupertino.dart';
import 'package:daycus/core/app_text.dart';

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
  // RecorderStream _recorder = RecorderStream();
  // PlayerStream _player = PlayerStream();

  List<Uint8List> _micChunks = [];
  bool _isRecording = false;
  bool _isPlaying = false;
  late StreamSubscription _recorderStatus;
  late StreamSubscription _playerStatus;
  late StreamSubscription _audioStream;
  dynamic userInfo = '';
  static final storage = FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  // Future<void> initPlugin() async {
  //   _recorderStatus = _recorder.status.listen((status) {
  //     if (mounted)
  //       setState(() {
  //         _isRecording = status == SoundStreamStatus.Playing;
  //       });
  //   });
  //
  //   _audioStream = _recorder.audioStream.listen((data) {
  //     if (_isPlaying) {
  //       _player.writeChunk(data);
  //     } else {
  //       _micChunks.add(data);
  //     }
  //   });
  //
  //   _playerStatus = _player.status.listen((status) {
  //     if (mounted)
  //       setState(() {
  //         _isPlaying = status == SoundStreamStatus.Playing;
  //       });
  //   });
  //
  //   await Future.wait([
  //     _recorder.initialize(),
  //     _player.initialize(),
  //   ]);
  // }
  //
  // void _play() async {
  //   await _player.start();
  //
  //   if (_micChunks.isNotEmpty) {
  //     for (var chunk in _micChunks) {
  //       await _player.writeChunk(chunk);
  //     }
  //     _micChunks.clear();
  //   }
  // }

  // void initState() {
  //   super.initState();
  //   initPlugin();
  // }

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
            children: [

            Text("개발자"),
            Text("Front & BackEnd / 202111152 이하임 CTO : 2022.03.01 ~"),
            Text("Design & FrontEnd / 202111152 전해원 COO : 2022.03.01 ~"),
            Text("BackEnd / 202011140 이기범 CUOP : 2022.12.20 ~"),

              SizedBox(height: 15.h,),

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
                title: "카메라 권한 주기 버튼",
                onPressed: (){
                  _scan();
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
                title: "유저 레벨 업데이트 !",
                onPressed: (){
                  update_level();
                  Fluttertoast.showToast(msg: "유저 레벨 업데이트가 완료되었습니다 !");
                },
              ),
              AdminButton(
                title: "지문 인식 슛 ~",
                onPressed: (){
                  _authenticateWithBiometrics();
                  Fluttertoast.showToast(msg: "지문 인식 성공했습니다 !");
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
                title: "녹음을 한 번 해봅시다 !",
                onPressed: (){
                  Fluttertoast.showToast(msg: "지금은 사용할 수 없습니다");
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (_) => RecordingPage()));
                },
              ),
            ],
          ),
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




