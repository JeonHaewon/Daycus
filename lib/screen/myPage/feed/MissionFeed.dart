import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/widget/missionfeedbutton.dart';



class MissionFeed extends StatelessWidget {
  const MissionFeed({Key? key}) : super(key: key);

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
        title: Text('미션피드',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [


            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 30.h, 40.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Container(
                    width: 365.w,
                    height:280.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h,),
                        Container(
                          child: Row(
                            children: [
                              SizedBox(width: 20.w,),
                              Text("2022. 10",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),
                        //MissionFeed(title :"Dd", totalUser:20,image: "dd" ),
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