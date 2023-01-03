import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class NowMissionButton extends StatelessWidget {
  NowMissionButton({
    Key? key,
    required this.image,
    required this.title,
    required this.totalUser,
    required this.rank,
    required this.percent,
    required this.duration,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final int totalUser;
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
        height: 100.h,
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

                Container(
                  child:Row(
                    children: [
                      SizedBox(width: 20.w,),

                      Container(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Stack(
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
                      ),


                      SizedBox(width: 15.w,),

                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Text(title,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                            Container(
                              child: Row(
                                children: [
                                  Text(f.format(totalUser),style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontFamily: 'korean') ),
                                  Text(" 참여중 ",style: TextStyle(color: Colors.grey, fontSize: 14.sp, fontFamily: 'korean') ),
                                  //Text(f.format(rank),style: TextStyle(color: AppColor.happyblue, fontSize: 14.sp, fontFamily: 'korean') ),
                                  //Text("위",style: TextStyle(color: AppColor.happyblue, fontSize: 14.sp, fontFamily: 'korean') ),

                                ],
                              ),
                            ),


                            SizedBox(height: 3.h),


                            Row(
                             children: [

                               Container(
                                 width: ((percent).w)*1.5,
                                 height: 8.h,
                                 decoration: BoxDecoration(
                                   color: AppColor.happyblue,
                                 ),

                               ),

                               Container(
                                 width: (100.w - (percent).w)*1.5,
                                 height: 8.h,
                                 decoration: BoxDecoration(
                                   color: Colors.grey[300],
                                 ),

                               ),

                               SizedBox(width: 8.w),

                               Container(
                                 child:  Container(
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.end,
                                     children: [
                                       //Text(duration,style: TextStyle(color: AppColor.happyblue, fontSize: 12.sp, fontFamily: 'korean'), textAlign: TextAlign.end,),
                                       Text("진행률 ",style: TextStyle(color: AppColor.happyblue, fontSize: 12.sp, fontFamily: 'korean') ),
                                       Text(f.format(percent),style: TextStyle(color: AppColor.happyblue, fontSize: 12.sp, fontFamily: 'korean') ),
                                       Text(" %    ",style: TextStyle(color: AppColor.happyblue, fontSize: 12.sp, fontFamily: 'korean') ),
                                     ],
                                   ),
                                 ),
                               ),

                             ],
                           ),




                          ],
                        ),
                      ),
                    ],
                  ),
                ),




              ],
            ),



          ],
        ),
      ),
    );
  }
}


