import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class MissionButton extends StatelessWidget {
  MissionButton({
    Key? key,
    required this.title,
    required this.totalUser,
    required this.image,
    this.onTap,
}) : super(key: key);

  final String title;
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
      child:Container(
        width: 170.w,
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('assets/image/$image.png') ,
            fit: BoxFit.cover
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Padding(
              padding: EdgeInsets.only(left:15.w, top: 52.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: TextStyle(color: Colors.white,fontSize: 15.sp, fontFamily: 'korean') ),
                  Container(
                    child: Row(
                      children: [
                        Text(f.format(totalUser),style: TextStyle(color: Colors.white,fontSize: 12.sp, fontFamily: 'korean') ),
                        Text("명 참여중",style: TextStyle(color: Colors.white,fontSize: 12.sp, fontFamily: 'korean') ),

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