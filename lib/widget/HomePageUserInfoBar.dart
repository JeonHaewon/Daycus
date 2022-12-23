import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageUserInfoBar extends StatelessWidget {
  const HomePageUserInfoBar({
    Key? key,
    required this.leftContent,
    required this.rightContent,
  }) : super(key: key);

  final String leftContent;
  final String rightContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      child: Row(
        children: [
          SizedBox(width: 20.w,),

          // 나의 리워드
          Container(
            width: 80.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(leftContent,style: TextStyle(color: Colors.white, fontSize: 10.sp, fontFamily: 'korean') ),
              ],
            ),
          ),


          // 하임 : 주간 > 전체로 변경
          SizedBox(width: 30.w,),
          Text(rightContent,
            style: TextStyle(color: AppColor.happyblue, fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold),  ),
        ],
      ),
    );
  }
}
