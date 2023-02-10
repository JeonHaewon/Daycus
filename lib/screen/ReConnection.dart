import 'package:daycus/backend/login/login.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ReConnection extends StatefulWidget {
  const ReConnection({Key? key}) : super(key: key);

  @override
  State<ReConnection> createState() => _ReConnectionState();
}

class _ReConnectionState extends State<ReConnection> {

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  static final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  //static final storage = FlutterSecureStorage();

  // @override
  // void initState() {
  //   super.initState();
  //   // 비동기로 flutter secure storage 정보를 불러오는 작업
  //   // 페이지 빌드 후에 비동기로 콜백함수를 호출 : 처음에 위젯을 하나 생성후에 애니메이션을 재생
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     LoginAsyncMethod(storage, context, false);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset("assets/image/logo_happyCircuit.png", width: 260.w,),
          ),

          Center(
            child: Column(
              children: [
                SizedBox(height: 700.h,),
                Text("인터넷 연결을 확인해주세요"),
                SizedBox(height: 20.h,),
                //Center(child: Text('Connection Status: $_connectionStatus')),
                SizedBox(
                  width: 30.w, height: 30.h,
                  child: CircularProgressIndicator(color: AppColor.happyblue,), ),
              ],
            ),

          ),

        ],
      ),
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Fail');
        break;
    }
    if (_connectionStatus!="ConnectivityResult.none"&&_connectionStatus!="Unknown"){
      print("인터넷 연결 : ${_connectionStatus}");
      Fluttertoast.showToast(msg: "재연결 되었습니다");
      //LoginAsyncMethod(storage, context, true);
      Navigator.pop(context);
    }

  }
}
