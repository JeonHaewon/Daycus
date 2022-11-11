import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class SpecificMissionPage extends StatelessWidget {
  SpecificMissionPage({
    Key? key,
    required this.topimage,
    required this.progress,
    required this.title,
    required this.duration,
    required this.totaluser,
    required this.certifiuser,
    this.onTap,
  }) : super(key: key);

  final String topimage;
  final String progress;
  final String title;
  final String duration;
  final int totaluser;
  final int certifiuser;
  final onTap;

  var f = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: null),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              child: Column(
                children: [
                  Container(
                    width: 412.w,
                    height: 280.h,
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      image: DecorationImage(
                          image: AssetImage('assets/image/specificmissionpage/$topimage.png') ,
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Image.asset('assets/image/specificmissionpage/$progress.png' ),
                  SizedBox(height: 10.h,),

                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 8.w,),
                        Text(title,style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h,),

                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 8.w,),
                        Text("모집기간",style: TextStyle(color: Colors. grey, fontSize: 15.sp, fontFamily: 'korean') ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5.h,),

                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 8.w,),
                        Text(duration,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean') ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15.h,),

            Container(
              width: 412.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppColor.grey2,
              ),
            ),

            Container(
              width: 300.w,
              height: 22.h,
              margin: EdgeInsets.only(top: 15.h, left: 24.w),
              decoration: BoxDecoration(
                color: AppColor.happyblue,
                borderRadius: BorderRadius.circular(5),
              ),
            ),

            SizedBox(height: 4.h,),

            Container(
              child: Row(
                children: [
                  SizedBox(width: 24.w,),
                  Text(f.format(totaluser),style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Text('명',style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Text(' 참여중',style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean',) ),
                  SizedBox(width: 180.w,),

                  Text(f.format(certifiuser),style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Text('명',style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Text(' 인증',style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean',) ),
                ],
              ),
            ),

            SizedBox(height: 15.h,),

            Container(
              width: 412.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppColor.grey2,
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 8.w,),
                        Text('예상 리워드',style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ),
                ],
              ),
            ),









          ],
        ),
      ),
    );
  }
}