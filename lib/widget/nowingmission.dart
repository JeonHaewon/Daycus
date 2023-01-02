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
    required this.reward,
    required this.duration,
    this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final int totalUser;
  final int rank;
  final double reward;
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
                        padding: EdgeInsets.only(top: 10.h),
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
                            SizedBox(height: 15.h),
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

                           Container(
                              child:  Container(
                                width: 245.w,
                                padding: EdgeInsets.only(right: 15.w, top: 13.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(duration,style: TextStyle(color: AppColor.happyblue, fontSize: 14.sp, fontFamily: 'korean'), textAlign: TextAlign.end,),
                                    //Text("+",style: TextStyle(color: AppColor.happyblue, fontSize: 18.sp, fontFamily: 'korean') ),
                                    //Text(f.format(reward),style: TextStyle(color: AppColor.happyblue, fontSize: 18.sp, fontFamily: 'korean') ),
                                    //Text("원     ",style: TextStyle(color: AppColor.happyblue, fontSize: 18.sp, fontFamily: 'korean') ),
                                  ],
                                ),
                              ),
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


