import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';



class RecordingPage extends StatefulWidget {
  const RecordingPage({Key? key}) : super(key: key);

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {

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
        title: Text('녹음',
            style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 60.h,),

            Container(
              padding: EdgeInsets.all(60),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xff2F34DB),
                    Color(0xff7074E9),
                    Color(0xff63648B),
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xff474AA1),
                child: Icon(Icons.record_voice_over_outlined, color: Colors.grey[100], size: 30.w,),
                //backgroundImage: AssetImage("assets/image/character2.png"),
              ),
            ),

            SizedBox(height: 20.h,),
            Text("00:00:28",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, fontSize: 14.sp) ),
            SizedBox(height: 5.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                InkWell(
                  onTap: () {},
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, size: 50.w,),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 10.w,),

                InkWell(
                  onTap: () {},
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.stop, size: 50.w,),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 35.h,),

            InkWell(
              onTap: () {},
              child: Container(
                width: 150.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("다시 듣기",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 12.sp) ),

                  ],
                ),
              ),
            ),

            SizedBox(height: 10.h,),

            InkWell(
              onTap: () {},
              child: Container(
                width: 150.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColor.happyblue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("오늘의 미션 인증하기",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12.sp) ),
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



