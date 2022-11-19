import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';




class LabelingMission extends StatelessWidget {
  LabelingMission({
    Key? key,
    required this.title,
    required this.rule1,
    required this.rule2,
    this.onTap,

  }) : super(key: key);


  final String title;
  final String rule1;
  final String rule2;
  final onTap;

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
        title: Text('라벨링 미션',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Padding(
              padding: EdgeInsets.fromLTRB(0, 30.h, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title ,style: TextStyle(fontSize: 24.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                ],
              ),
            ),



            Padding(
              padding: EdgeInsets.fromLTRB(60.w, 20.h, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: 65.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 5.h,),
                        Text("미션 정책",style: TextStyle(color: Colors.indigoAccent, fontSize: 12.sp, fontFamily: 'korean') ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.h,),

                  Text("ㆍ$rule1",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean',) ),
                  Text("ㆍ$rule2",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean',) ),

                ],
              ),
            ),




            Padding(
              padding: EdgeInsets.fromLTRB(0, 10.h, 0, 25.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 290.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height:5.h,),

                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 18.w,
                                height: 18.h,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 3.h,),

                                    Text("!",style: TextStyle(color: Colors.white, fontSize: 8.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 6.w,),

                              Text("미션 정책을 확인하고 이에 맞는 사진을 선택해주세요",style: TextStyle( fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),




          ],
        ),
      ),

    );
  }
}