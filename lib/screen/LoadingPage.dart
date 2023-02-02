import 'dart:convert';
import 'dart:math';

import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:daycus/screen/LoginPageCustom.dart';
import 'package:daycus/screen/myPage/privatesettings/PrivateSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../backend/UpdateRequest.dart';
import '../main.dart';

var logincode = '1';


making_login_code() {
  String random_num = '';
  for (int i = 0; i < 19; i++){
    random_num += (Random().nextInt(9) + 1).toString();
  }
  logincode = random_num;
}

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  bool auto = true;

  dynamic userInfo = '';

  static final storage = FlutterSecureStorage();

  // final timer = Timer(
  //   const Duration(seconds: 3),
  //       () {
  //     print("끝남");
  //   },
  // );

  bool _visible = false;

  // show force update dialog

  // show force update dialog
  void showForceUpdateDialog(bool forceUpdate) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text(forceUpdate ? '업데이트가 필요' : '새로운 버전 출시'),
              content: Text(forceUpdate ? '중요한 변경으로 인해 업데이트를 해야만 앱을 이용할 수 있어요.' : '업데이트를 하고 새로운 기능을 만나보세요.'),
              actions: [
                if (!forceUpdate)
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('나중에')),
                TextButton(
                    onPressed: () async {
                      // Navigator.pop(context);
                      // 앱 업데이트
                      StoreRedirect.redirect(androidAppId: 'com.happycircuit.daycus',);
                    },
                    child: const Text('업데이트'))
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      Timer(
        const Duration(seconds: 3),
            () {
              setState(() {
                _visible = !_visible;
              });
        },
      );
    });
    //print("init");
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    // 페이지 빌드 후에 비동기로 콜백함수를 호출 : 처음에 위젯을 하나 생성후에 애니메이션을 재생
    //Fluttertoast.showToast(msg: "init");


    // WidgetsBinding.instance.addPostFrameCallback(
    //       (_) {
    //     showForceUpdateDialog(true);
    //   },
    // );
    making_login_code();
    LoginAsyncMethod(storage, context, false);
  }

  checkUserState() async {
    userInfo = await PrivateSettings.storage.read(key: 'login');
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


  @override
  Widget build(BuildContext context) {
    //Fluttertoast.showToast(msg: "build");
    //print("build");

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset("assets/image/logo_happyCircuit.png", width: 260.w,),
          ),

          Center(
            child: Column(
              children: [
                SizedBox(height: 710.h,),
                Text("로딩이 1분 이상 지속될 경우\n앱을 완전히 종료한 후 재부팅 해주세요", textAlign: TextAlign.center,),
                SizedBox(height: 30.h,),
                SizedBox(
                  width: 30.w, height: 30.h,
                  child: CircularProgressIndicator(), ),

                AnimatedOpacity(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: TextButton(
                    onPressed: () async {
                      // 기획에서 어떻게 인사할건지 정하기
                      Fluttertoast.showToast(msg: "로그아웃 처리하였습니다");
                      // 로그인 유지 삭제 및 정보 삭제
                      // 백그라운드에서 진행.
                      await logout(false);
                      checkUserState();
                      profileImage = null; downloadProfileImage = null; profileDegree = 0;

                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>
                          LoginPageCustom()),
                              (route) => false);

                    },
                    child: Text("로그인 페이지로"),
                  ),
                ),

              ],
            ),

          ),

        ],
      ),
    );
  }
}
