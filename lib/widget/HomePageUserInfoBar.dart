import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageUserInfoBar extends StatelessWidget {
  const HomePageUserInfoBar({
    Key? key,
    required this.leftContent,
    required this.rightContent,
    required this.icon,
  }) : super(key: key);

  final String leftContent;
  final String rightContent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.w,
      //height: 55.h,
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h ),
      child: Row(
        children: [
          SizedBox(width: 20.w,),

          // 나의 리워드
          Container(
            width: 80.w,
            //height: 30.h,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SizedBox(height: 8.h,),
                Text(leftContent,style: TextStyle(color: Colors.white, fontSize: 10.sp, fontFamily: 'korean') ),
                SizedBox(height: 8.h,),

              ],
            ),
          ),
          SizedBox(width: 30.w,),

          Icon(icon,color: AppColor.happyblue,),
          // 하임 : 주간 > 전체로 변경
          SizedBox(width: 10.w,),
          Text(rightContent,
            style: TextStyle(color: AppColor.happyblue, fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold),  ),
        ],
      ),
    );
  }
}
