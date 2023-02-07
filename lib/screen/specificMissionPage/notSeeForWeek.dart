import 'package:daycus/backend/UpdateRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> NotSeeWeek(BuildContext context, do_mission_data, mission_data, now){
  //WidgetsBinding.instance.addPostFrameCallback((_) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        // 하임 : 내가 인증한 사진 > n일째 인증 사진으로 변경
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("미션 인증 방법",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
          ],
        ),
        content: Container(
          width: 304.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 20.h),
                  //height: 200.h,
                  child: Column(
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("1. 인증빈도",
                              style: TextStyle(fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                          SizedBox(height: 3.h,),
                          Text("미션 기간 ${mission_data['term']}주 동안 주 ${mission_data['frequency']}일, 하루 1번 인증 사진을 올리셔야 합니다.",
                              style: TextStyle(fontSize: 13.sp, fontFamily: 'korean',  color: Colors.grey) ),

                          SizedBox(height: 15.h,),

                          Text("2. 인증방법",
                              style: TextStyle(fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                          SizedBox(height: 3.h,),
                          Text("${mission_data['content']}",
                              style: TextStyle(fontSize: 13.sp, fontFamily: 'korean',  color: Colors.grey) ),

                        ],
                      ),

                      SizedBox(height: 20.h,),

                    ],
                  )

              ),

              Container(
                width: 412.w,
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  InkWell(
                    onTap:(){
                      update_request("update do_mission set not_see = '${DateTime.now()}' where do_id = '${do_mission_data['do_id']}'", null);
                      do_mission_data['not_see'] = now;

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 150.w,
                      height: 50.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(4))
                        //borderRadius: BorderRadius.circular(4),
                      ),
                      child:  Text("일주일간 보지 않기",
                          style: TextStyle(fontSize: 11.sp, fontFamily: 'korean',  color: Colors.grey[800]) ),
                    ),
                  ),


                  Container(
                    width: 1.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                  ),

                  InkWell(
                    onTap:(){Navigator.of(context).pop();},
                    child: Container(
                      width: 150.w,
                      height: 50.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(4))

                        //borderRadius: BorderRadius.circular(4),
                      ),
                      child:  Text("확인",
                          style: TextStyle(fontSize: 11.sp, fontFamily: 'korean',  color: Colors.grey[800]) ),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(10),
        // ),
      ),
    );
  }
