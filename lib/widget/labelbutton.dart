import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class LabelButton extends StatelessWidget {
  LabelButton({
    Key? key,
    required this.image,
    required this.title,
    required this.duration,
    required this.totalUser,
    required this.myparticipation,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final String duration;
  final int totalUser;
  final int myparticipation;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Container(
              width: 170.w,
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                    image: AssetImage('assets/image/$image.png') ,
                    fit: BoxFit.cover
                ),
              ),

            ),

            SizedBox(height: 10.h,),

            Text(title,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
            // 하임 : ~동안을 기간으로 바꿈 int > String / 16.sp > 13.sp
            Text('$duration',style: TextStyle(fontSize: 13.sp, fontFamily: 'korean') ),

            SizedBox(height: 10.h,),


            Container(
              width: 170.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("나의 참여 현황",style: TextStyle(color: AppColor.happyblue,fontSize: 12.sp, fontFamily: 'korean') ),
                  Text("${f.format(totalUser)}/${f.format(myparticipation)}",style: TextStyle(color: Colors.grey,fontSize: 12.sp, fontFamily: 'korean') ),
                ],
              ),
            ),



            SizedBox(height: 5.h,),

            Container(
              width: 100.w,
              height: 10.h,
              color: AppColor.happyblue,

            ),


          ],
        ),
      ),
    );
  }
}




