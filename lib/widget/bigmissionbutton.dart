import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class BigMissionButton extends StatelessWidget {
  BigMissionButton({
    Key? key,
    required this.title,
    required this.duration,
    required this.totalUser,
    required this.certifiUser,
    required this.image,
    this.onTap,
  }) : super(key: key);

  final String title;
  final int duration;
  final int totalUser;
  final int certifiUser;
  final String image;
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
                    image: AssetImage('assets/image/thumbnail/$image') ,
                    fit: BoxFit.cover
                ),
              ),

            ),

            SizedBox(height: 10.h,),

            Text(title,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
            Text('$duration주 동안',style: TextStyle(fontSize: 16.sp, fontFamily: 'korean') ),

            SizedBox(height: 5.h,),

            Container(
              width: 100.w,
              height: 10.h,
              color: AppColor.happyblue,

            ),

            SizedBox(height: 5.h,),

            Container(
              width: 170.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${f.format(totalUser)}명 참여중",style: TextStyle(color: Colors.grey,fontSize: 12.sp, fontFamily: 'korean') ),
                  Text("${f.format(certifiUser)}명 인증",style: TextStyle(color: Colors.grey,fontSize: 12.sp, fontFamily: 'korean') ),


                ],
              ),
            ),






          ],
        ),
      ),
    );
  }
}




