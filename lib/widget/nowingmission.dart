import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class NowMissionButton extends StatelessWidget {
  NowMissionButton({
    Key? key,
    required this.image,
    required this.title,
    required this.totalUser,
    required this.rank,
    required this.reward,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final int totalUser;
  final int rank;
  final int reward;
  final onTap;

  var f = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => onTap),
        );
      },
      child: Container(
        width: 360.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 30.w),
        child: Row(
          children: [

            SizedBox(width: 20.w,),
            Image.asset('assets/image/$image.png' , fit: BoxFit.fill,height: 65.h),
            SizedBox(width: 15.w,),

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(title,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Container(
                    child: Row(
                      children: [
                        Text(f.format(totalUser),style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontFamily: 'korean') ),
                        Text(" 참여중 ",style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontFamily: 'korean') ),
                        Text(f.format(rank),style: TextStyle(color: AppColor.happyblue, fontSize: 14.sp, fontFamily: 'korean') ),
                        Text("위",style: TextStyle(color: AppColor.happyblue, fontSize: 14.sp, fontFamily: 'korean') ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 20.w,),

            Container(
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  Container(
                    child: Row(
                      children: [
                        Text("+",style: TextStyle(color: AppColor.happyblue, fontSize: 18.sp, fontFamily: 'korean') ),
                        Text(f.format(reward),style: TextStyle(color: AppColor.happyblue, fontSize: 18.sp, fontFamily: 'korean') ),
                        Text("원",style: TextStyle(color: AppColor.happyblue, fontSize: 18.sp, fontFamily: 'korean') ),
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


