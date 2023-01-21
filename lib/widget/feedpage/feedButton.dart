import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class FeedButton extends StatelessWidget {
  FeedButton({
    Key? key,
    required this.title,
    required this.duration,
    required this.image,
    required this.percent,
    required this.startTime,
    required this.endTime,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String duration;
  final String image;
  final double percent;
  final String startTime;
  final String endTime;
  final onTap;

  var f = NumberFormat('###,###,###,###');

  double width = 150.w;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w, left: 15.w),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) => onTap),
          // );
        },
        child: Container(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Container(
                height: 155.h,
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


              // Container(
              //   alignment: Alignment.centerLeft,
              //   width: 170.w,
              //   height: 24.h,
              //   child: FittedBox(
              //     fit: BoxFit.scaleDown,
              //     child:Text(title,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,), ),
              //   ),
              // ),

              Container(
                  height: 24.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(
                              text:
                              title,
                              style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,color: Colors.black),),
                          )),
                    ],
                  )
              ),



              //Text('미션 시작 : $startTime',style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
              Text('$startTime ~ $endTime',style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),

              SizedBox(height: 5.h,),

              // Container(
              //   width: 155.w,
              //   height: 1.h,
              //   color: AppColor.happyblue,
              //
              // ),

              // SizedBox(height: 5.h,),

              Row(
                children: [

                  Stack(
                    children: [

                      Container(
                        width: width,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),

                      ),

                      Container(
                        width: (percent/100)*width,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: AppColor.happyblue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                    ],

                  ),




                ],
              ),

              SizedBox(height: 3.h,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //SizedBox(width: 9.w),

                  Container(
                    child:  Row(
              mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //Text(duration,style: TextStyle(color: AppColor.happyblue, fontSize: 12.sp, fontFamily: 'korean'), textAlign: TextAlign.end,),
                  Text("진행률 ",style: TextStyle(color: AppColor.happyblue, fontSize: 11.sp, fontFamily: 'korean') ),
                  Text(percent.toStringAsFixed(1),style: TextStyle(color: AppColor.happyblue, fontSize: 11.sp, fontFamily: 'korean') ),
                  Text(" %    ",style: TextStyle(color: AppColor.happyblue, fontSize: 11.sp, fontFamily: 'korean') ),
                ],
                    ),
                  ),
                ],
              )

              // Container(
              //   width: 155.w,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text("${percent}",style: TextStyle(color: Colors.grey,fontSize: 12.sp, fontFamily: 'korean') ),
              //       // Text("누적 ${f.format(totalUser)}명 참여",style: TextStyle(color: Colors.grey,fontSize: 12.sp, fontFamily: 'korean') ),
              //
              //
              //     ],
              //   ),
              // ),






            ],
          ),
        ),
      ),
    );
  }
}




