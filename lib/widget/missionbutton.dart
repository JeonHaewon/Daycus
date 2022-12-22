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
      child:Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          width: 170.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: AssetImage('assets/image/thumbnail/$image') ,
                fit: BoxFit.cover
            ),
          ),

        ),

        Opacity(
          opacity: 0.25,
          child: Container(
            width: 170.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),

            ),

          ),

        ),

        Padding(
          padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: TextStyle(color: Colors.white,fontSize: 15.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
              Container(
                child: Row(
                  children: [
                    Text(f.format(totalUser),style: TextStyle(color: Colors.white,fontSize: 11.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
                    Text("명 참여중",style: TextStyle(color: Colors.white,fontSize: 11.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
                  ],
                ),
              ),
            ],
          ),
        ),


      ],
    ),
    );
  }
}