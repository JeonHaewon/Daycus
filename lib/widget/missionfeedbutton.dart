import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class MissionFeedButton extends StatelessWidget {
  MissionFeedButton({
    Key? key,
    required this.title,
    required this.image,
    required this.duration,
    required this.percent,
    required this.reward,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String image;
  final String duration;
  final int percent;
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
      child:Container(
        width: 150.w,
        height: 195.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.grey,
              style: BorderStyle.solid,
              width: 1.w
          ),


        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Padding(
              padding: EdgeInsets.only( top: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(title,style: TextStyle(color: Colors.black,fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  SizedBox(height: 5.h,),
                ],
              ),
            ),

            Image.asset('assets/image/$image.png' ,width: 200.w, fit: BoxFit.fill,),

            SizedBox(height: 8.h,),

            Padding(
              padding: EdgeInsets.only( left:8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                    child: Row(
                      children: [
                        Container(
                          width: 55.w,
                          height: 15.h,
                          decoration: BoxDecoration(
                            color: Colors.indigo[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 2.h,),
                              Text("참여기간",style: TextStyle(color: Colors.white, fontSize: 8.sp, fontFamily: 'korean') ),
                            ],
                          ),
                        ),
                        SizedBox(width: 2.w),

                        Text(duration,style: TextStyle(fontSize: 10.sp, fontFamily: 'korean') ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h,),

                  Container(
                    child: Row(
                      children: [

                        Container(
                          width: 55.w,
                          height: 15.h,
                          decoration: BoxDecoration(
                            color: Colors.indigo[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 2.h,),
                              Text("성공률",style: TextStyle(color: Colors.white, fontSize: 8.sp, fontFamily: 'korean') ),
                            ],
                          ),
                        ),
                        SizedBox(width: 2.w),

                        Text("$percent%",style: TextStyle(fontSize: 10.sp, fontFamily: 'korean') ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h,),


                  Container(
                    child: Row(
                      children: [

                        Container(
                          width:55.w,
                          height: 15.h,
                          decoration: BoxDecoration(
                            color: Colors.indigo[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 2.h,),
                              Text("획득 리워드",style: TextStyle(color: Colors.white, fontSize: 8.sp, fontFamily: 'korean') ),
                            ],
                          ),
                        ),
                        SizedBox(width: 2.w),

                        Text("${f.format(reward)}원",style: TextStyle(fontSize: 10.sp, fontFamily: 'korean') ),
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