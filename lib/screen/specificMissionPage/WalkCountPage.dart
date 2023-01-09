import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';



class WalkCount extends StatelessWidget {
  WalkCount({Key? key}) : super(key: key);

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

                                  Text("${f.format(50000)}걸음",
                                      style: TextStyle(fontSize: 24.sp, fontFamily: 'korean',fontWeight: FontWeight.bold, color: AppColor.happyblue )
                                  ),
                                  SizedBox(height: 60.h,),
                                  Row(
                                    children: [
                                      Text("미션 성공까지 ",
                                          style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', )
                                      ),
                                      Text("${f.format(5000)}",
                                          style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', fontWeight: FontWeight.bold )
                                      ),
                                      Text("걸음",
                                          style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', )
                                      ),
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
