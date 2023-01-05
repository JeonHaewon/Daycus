import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class BigMissionButton extends StatelessWidget {
  BigMissionButton({
    Key? key,
    required this.title,
    required this.duration,
    required this.currentUser,
    required this.certifiUser,
    required this.totalUser,
    required this.image,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String duration;
  final int currentUser;
  final int certifiUser;
  final int totalUser;
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


            //Text(title,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,), ),

            Container(
              alignment: Alignment.centerLeft,
              width: 170.w,
              height: 24.h,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child:Text(title,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,), ),
              ),
            ),


            Text('$duration',style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),

            SizedBox(height: 5.h,),

            Container(
              width: 170.w,
              height: 1.h,
              color: AppColor.happyblue,

            ),

            SizedBox(height: 5.h,),

            Container(
              width: 170.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${f.format(currentUser)}명 참여중",style: TextStyle(color: Colors.grey,fontSize: 12.sp, fontFamily: 'korean') ),
                  Text("누적 ${f.format(totalUser)}명 참여",style: TextStyle(color: Colors.grey,fontSize: 12.sp, fontFamily: 'korean') ),


                ],
              ),
            ),






          ],
        ),
      ),
    );
  }
}




