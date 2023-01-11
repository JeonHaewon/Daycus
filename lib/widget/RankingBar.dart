import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RankingBar extends StatelessWidget {
  RankingBar({
    Key? key,
    required this.rankNum,
    required this.userName,
    required this.rewards,
    required this.mine,
  }) : super(key: key);

  final int rankNum;
  final String userName;
  final double rewards;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 45.h,

      decoration: BoxDecoration(
        color: mine==false ? Colors.white : Colors.blueGrey[50],
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
                    Text("${rewards.toStringAsFixed(1)}",
                      // f.format(rewards),
                      textAlign: TextAlign.left,style: TextStyle(fontSize: 14.sp, color: AppColor.happyblue),),
                  ],
                )
            ),
          ),


        ],
      ),
    );
  }
}


// class RankingBar extends StatelessWidget {
//   final int rankNum;
//   final String userName;
//   final double rewards;
//   final bool? mine;
//
//   RankingBar(
//       this.rankNum,
//       this.userName,
//       this.rewards,
//       this.mine : null,
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     //var f = NumberFormat('###,###,###,###');
//     return
//   }
// }