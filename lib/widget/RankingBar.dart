import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RankingBar extends StatelessWidget {
  final int rankNum;
  final String userName;
  final int rewards;

  RankingBar(
      this.rankNum,
      this.userName,
      this.rewards,
      );

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat('###,###,###,###');
    return Container(
      width: 300.w,
      height: 45.h,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 6.h, top: 0),
      child: Row(

        children: [

          Container(
            width: 50.w,
            child: Text("$rankNum", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColor.happyblue ),textAlign: TextAlign.center,),
          ),

          SizedBox(width: 4.w,),

          Container(
            width: 135.w,
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child:Text(userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, ),),
            ),
          ),

          SizedBox(width: 8.w,),

          Container(
            width: 100.w,
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child:Row(
                children: [
                  Icon(Icons.star, size: 15.w, color: AppColor.happyblue),
                  SizedBox(width: 3.w,),
                  Text(f.format(rewards), textAlign: TextAlign.left,style: TextStyle(fontSize: 14.sp, color: AppColor.happyblue),),
                ],
              )
            ),
          ),


        ],
      ),
    );
  }
}