import 'package:daycus/screen/ReConnection.dart';
import 'package:flutter/material.dart';
// 인터넷 관련 라이브러리
import 'package:connectivity/connectivity.dart';


// 인터넷 연결 확인
checkConnectionStatus(BuildContext context) async {
  var result = await (Connectivity().checkConnectivity());
  // print( "result :$result");
  if (result.toString() == "ConnectivityResult.none") {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ReConnection()));
  }

  return result.toString();  // wifi, mobile
}