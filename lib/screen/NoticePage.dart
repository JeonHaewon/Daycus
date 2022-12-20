import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class NoticePage extends StatelessWidget {
  const NoticePage({Key? key}) : super(key: key);

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
        title: Text('알림',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20.h),
              alignment: Alignment.center,
              child: Text("도착한 알람이 없습니다."),
            ),
            
            // 알람 예시 - 나중에 알림 기능을 추가하면 될듯.
            /*
            InkWell(
              onTap: () {},
              child: Container(
                height: 85.h,
                width: 412.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 20.h, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text("오늘의 미션 수행" ,style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', ) ),
                          SizedBox(height: 7.h,),
                          Text("2021.08.19" ,style: TextStyle(fontSize: 15.sp, fontFamily: 'korean',color: Colors.grey ) ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 1,color: Colors.grey[300]),
            
            
            InkWell(
              onTap: () {},
              child: Container(
                height: 85.h,
                width: 412.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 20.h, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text("오늘의 미션 수행" ,style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', ) ),
                          SizedBox(height: 7.h,),
                          Text("2021.08.19" ,style: TextStyle(fontSize: 15.sp, fontFamily: 'korean',color: Colors.grey ) ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 1,color: Colors.grey[300]),
            */



          ],
        ),
      ),


    );
  }
}