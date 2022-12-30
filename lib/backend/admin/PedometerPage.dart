import 'dart:convert';

import 'package:daycus/core/notification.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

import 'package:pedometer/pedometer.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

var prefs;
var curr;
int suc = 0;
int increased = 0;
var really;
bool isupgrade = false;
bool isAppInactive = false;
List<int> dap = [];

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class PedometerPage extends StatefulWidget {
  const PedometerPage({Key? key}) : super(key: key);

  @override
  State<PedometerPage> createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage> {

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    // selecting_from_stroage();
    initPlatformState();
  }

  updating_info(StepCount event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('lit2') == null){
      await prefs.setStringList('lit2', [event.steps.toString()]);
    }
    curr = prefs.getStringList('lit2');
    return curr[0];
  }


  Future<void> onStepCount(StepCount event) async {
    print(event);
    if (isupgrade==false){
      really = await updating_info(event);
      Fluttertoast.showToast(msg: "만보기 시작");
      isupgrade = true;
    }
    setState(() {
      _steps = (event.steps - int.parse(really)).toString();
      // _steps = pedometer_count.toString();
      // pedometer_count += 1;
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedometer example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Steps taken:\n앱을 강제종료하지 마세요 ! 만보기가 돌아가고 있어용 :)',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                _steps,
                style: TextStyle(fontSize: 60),
              ),
              Divider(
                height: 100,
                thickness: 0,
                color: Colors.white,
              ),
              Text(
                'Pedestrian status:',
                style: TextStyle(fontSize: 30),
              ),
              Icon(
                _status == 'walking'
                    ? Icons.directions_walk
                    : _status == 'stopped'
                    ? Icons.accessibility_new
                    : Icons.error,
                size: 100,
              ),
              Center(
                child: Text(
                  _status,
                  style: _status == 'walking' || _status == 'stopped'
                      ? TextStyle(fontSize: 30)
                      : TextStyle(fontSize: 20, color: Colors.red),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

