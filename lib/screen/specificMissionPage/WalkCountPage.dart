import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../backend/UserDatabase.dart';

var prefs;
var curr;
int suc = 0;
int increased = 0;
var really;
bool isupgrade = false;
List<int> dap = [];


class WalkCountPage extends StatefulWidget {
  const WalkCountPage({
    Key? key,
    required this.walkNumber,
  }) : super(key: key);

  final int walkNumber;

  @override
  State<WalkCountPage> createState() => _WalkCountPageState();
}

String steps = '0';

class _WalkCountPageState extends State<WalkCountPage> {

  late Stream<StepCount> _stepCountStream;


  @override
  void initState() {
    super.initState();
    // selecting_from_stroage();
    initPlatformState();
  }

  updating_info(StepCount event) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('${user_data['user_email']}') == null){
      await prefs.setStringList('${user_data['user_email']}', [event.steps.toString()]);
    }
    curr = prefs.getStringList('${user_data['user_email']}');
    return curr[0];
  }

  get_data (StepCount event) async {
    really = await updating_info(event);
  }


  Future<void> onStepCount(StepCount event) async {
    print(event);
    if (isupgrade==false){
      get_data(event);
      Fluttertoast.showToast(msg: "만보기 시작");
      isupgrade = true;
    }
    setState(() {
      steps = (event.steps - int.parse(really)).toString();
      // _steps = pedometer_count.toString();
      // pedometer_count += 1;
    });
  }


  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      steps = '만보기를 사용할 수 없습니다 :(';
    });
  }

  void initPlatformState () async {
    if (await Permission.activityRecognition.request().isGranted) {

      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
    }
    if (!mounted) return;
  }

  void dispose(){
    super.dispose();
  }

  var f = NumberFormat('###,###,###,###');
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('나의 걸음 수',
            style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(35.w, 30.h, 35.w, 0),
              child: Container(
                width: 400.w,
                height: 200.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: [Color(0xFFDCE4F0),Color(0xFF8291D8)],
                      begin: FractionalOffset.centerLeft,
                      end: FractionalOffset.centerRight,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                      padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text("오늘은 얼마나 걸었을까요?",
                                      style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', )
                                  ),
                                  SizedBox(height: 2.h,),

                                  Text("${steps.replaceAll(RegExp(r'[^0-9]'),'')}걸음",
                                      style: TextStyle(fontSize: 24.sp, fontFamily: 'korean',fontWeight: FontWeight.bold, color: AppColor.happyblue )
                                  ),
                                  SizedBox(height: 60.h,),

                                  (widget.walkNumber-int.parse(steps.replaceAll(RegExp(r'[^0-9]'),'')) > 0)
                                      ? Row(
                                          children: [
                                            Text("미션 성공까지 ",
                                                style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', )
                                            ),
                                            Text("${(widget.walkNumber-int.parse(steps.replaceAll(RegExp(r'[^0-9]'),''))).toString()}",
                                                style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', fontWeight: FontWeight.bold )
                                            ),
                                            Text("걸음",
                                                style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', )
                                            ),
                                          ],
                                        )
                                    : Row(
                                    children: [
                                      Text("${widget.walkNumber}걸음 걷기 ",
                                          style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', )
                                      ),
                                      Text("미션 완료 !!",
                                          style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', fontWeight: FontWeight.bold ),
                                      ),
                                      // Text(" !!",
                                      //     style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', )
                                      // ),
                                    ],
                                  ),

                                  SizedBox(height: 15.h,),

                                ],
                              ),

                              SizedBox(width: 10.w,),
                              Image.asset('assets/image/character.png' , fit: BoxFit.fill,height: 150.h),

                            ],
                          ),


                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),







          ],
        ),
      ),
    );
  }

}
