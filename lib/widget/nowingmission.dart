import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class NowMissionButton extends StatelessWidget {
  NowMissionButton({
    Key? key,
    required this.image,
    required this.title,
    required this.currentUser,
    required this.rank,
    required this.percent,
    required this.duration,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final int currentUser;
  final int rank;
  final double percent;
  final String duration;
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
        //height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [


                  Row(
                    children: [
                      SizedBox(width: 20.w,),

                      Stack(
                        alignment: Alignment.center,
                        children: [

                          CircleAvatar(
                            radius: 35.h,
                            backgroundImage: image!=null
                            // 사진이 있으면
                                ? AssetImage('assets/image/thumbnail/$image')
                                : AssetImage('assets/image/thumbnail/missionbackground.png'),
                          ),

                          Opacity(
                            opacity: 0.25,
                            child: Container(
                              width: 66.w,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle
                              ),
                            ),
                          ),

                        ],
                      ),


                      SizedBox(width: 15.w,),

                      Container(


                        child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 20.h, 0, 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  Container(
                                      width: 240.w,
                                      //height: 28.h,

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                text: TextSpan(
                                                    text: title,
                                                    style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                                              )
                                          ),
                                        ],
                                      )
                                  ),


                                  Container(
                                    child: Row(
                                      children: [
                                        Text(f.format(currentUser),style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontFamily: 'korean') ),
                                        Text("명 참여중 ",style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontFamily: 'korean') ),
                                        //Text(f.format(rank),style: TextStyle(color: AppColor.happyblue, fontSize: 14.sp, fontFamily: 'korean') ),
                                        //Text("위",style: TextStyle(color: AppColor.happyblue, fontSize: 14.sp, fontFamily: 'korean') ),

                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 3.h),


                                  Row(
                                    children: [

                                      Stack(
                                        children: [

                                          Container(
                                            width: (100.w)*1.45,
                                            height: 8.h,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(10),
                                            ),

                                          ),

                                          Container(
                                            width: ((percent).w)*1.45,
                                            height: 8.h,
                                            decoration: BoxDecoration(
                                              color: AppColor.happyblue,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),

                                        ],

                                      ),


                                      SizedBox(width: 9.w),

                                      Container(
                                        child:  Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              //Text(duration,style: TextStyle(color: AppColor.happyblue, fontSize: 12.sp, fontFamily: 'korean'), textAlign: TextAlign.end,),
                                              Text("진행률 ",style: TextStyle(color: AppColor.happyblue, fontSize: 11.sp, fontFamily: 'korean') ),
                                              Text(percent.toStringAsFixed(1),style: TextStyle(color: AppColor.happyblue, fontSize: 11.sp, fontFamily: 'korean') ),
                                              Text(" %    ",style: TextStyle(color: AppColor.happyblue, fontSize: 11.sp, fontFamily: 'korean') ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),



                                ],
                              ),
                            ),















                      ),
                    ],
                  ),





              ],
            ),



          ],
        ),
      ),
    );
  }
}


