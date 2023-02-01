import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:confetti/confetti.dart';




class LabelingEnd extends StatefulWidget {
  LabelingEnd({Key? key}) : super(key: key);

  @override
  State<LabelingEnd> createState() => _LabelingEndState();
}

class _LabelingEndState extends State<LabelingEnd> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color(0xff9fa8da),
                Color(0xff7986cb),
                Color(0xff5c6bc0),
              ],
            ),
          ),

          child: Column(
            children: [
              SizedBox(height: 200.h,),

              CircleAvatar(
                radius: 90.h,
                backgroundColor: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/image/daycus_logo.gif', scale: 5.w,),
                    SizedBox(height: 5.h,),
                    Text("라벨링이\n완료되었습니다",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black), textAlign: TextAlign.center,),

                  ],
                ),
              ),

              SizedBox(height: 120.h,),

              Padding(
                padding: EdgeInsets.only(left: 100.w, right: 100.w),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    primary: Colors.white,
                    onPrimary: AppColor.happyblue,
                    minimumSize: Size(80.w, 60.h),
                    textStyle: TextStyle(fontSize: 18.sp),
                  ),

                  onPressed: () => Navigator.of(context).pop(),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("라벨링 계속하기",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColor.happyblue,) ),
                      Image.asset('assets/image/arrow-right1.png', color: AppColor.happyblue,)
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




