import 'package:daycus/backend/login/login.dart';
import 'package:daycus/screen/labelPage/LabelingEnd.dart';
import 'package:flutter/material.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';
import 'labelPage/LabelingMission.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


String LabelState = " ";

class LabelPage extends StatefulWidget {
  const LabelPage({
    Key? key,
    // required this.state,
  }) : super(key: key);

  // final String state;
  static final storage = FlutterSecureStorage();

  @override
  State<LabelPage> createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {

  var i;

  void initState() {
    i = Random().nextInt(all_missions.length);
  }

  @override
  Widget build(BuildContext context) {

    // Future<void> refresh() async {
    //   await afterLogin();
    //   setState(() { });
    // };

    //int extraindex = -2;
    return Scaffold(
      appBar: AppBar(
      // leading: IconButton(
      //   icon: Icon(Icons.arrow_back, color: Colors.black),
      //   onPressed: () => Navigator.of(context).pop(),
      // ),
      backgroundColor: Colors.white,
      title: Text('라벨링 미션',
          style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      actions: [

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                    width: 110.w,
                    //height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.indigo[100],

                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 2.h,),
                        Text("이번주 라벨링 횟수",style: TextStyle(color: Colors.black, fontSize: 10.sp), textAlign: TextAlign.center,),
                        Text("${ccnt.toString()} 회",style: TextStyle(color: Colors.black, fontSize: 11.sp), textAlign: TextAlign.center,),
                        SizedBox(height: 2.h,),

                      ],
                    )
                ),

                SizedBox(width: 10.w,)
              ],
            )

          ],
        )

      ],
    ),
      body: LabelState=="end"
          ? LabelingEnd()
          : LabelingMission(
        content: all_missions[i]['content'],
        label_category: all_missions[i]['label_category'],
        folder: all_missions[i]['image_locate'],
        title: all_missions[i]['title'],
        rule: all_missions[i]['rules'],
      ),
    );

  }
}

