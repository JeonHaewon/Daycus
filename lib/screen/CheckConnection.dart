import 'package:daycus/screen/ReConnection.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';



checkConnectionStatus(BuildContext context) async {
  var result = await (Connectivity().checkConnectivity());
  print( "result :$result");
  if (result.toString() == "ConnectivityResult.none") {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ReConnection()));
  }

  return result.toString();  // wifi, mobile
}