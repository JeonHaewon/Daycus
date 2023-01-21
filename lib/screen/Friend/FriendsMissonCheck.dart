import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FriendMissionCheckPage extends StatelessWidget {
  const FriendMissionCheckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('친구의 미션',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 25.h, 0, 0),
          child: Column(
            children: [

              FriendMissionButton(),

            ],

          ),
        ),

      ),

    );
  }
}




class FriendMissionButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 6, sigmaX: 6),
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("~~님의 미션",style: TextStyle(fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  InkWell(
                    onTap:(){Navigator.of(context).pop();},
                    child: Icon(Icons.clear),
                  )
                ],
              ),
              content: Container(
                height: 30.h,
                width: 10.w,
                decoration: BoxDecoration(
                    color: Colors.grey
                ),

              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        });


      },
      child: Container(
        width: 400.w,
        height: 75.h,
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(width: 10.w,),
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: [

                  CircleAvatar(
                    radius: 25.h,
                    backgroundColor: Colors.grey,
                    //backgroundImage: image!=null

                  ),

                  Opacity(
                      opacity: 0.25,
                      child: CircleAvatar(
                        radius: 25.h,
                        backgroundColor: Colors.black,
                      )
                  ),



                ],
              ),
            ),


            Container(
              child:Row(
                children: [

                  SizedBox(width: 15.w,),

                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                        //text: title,
                                          text: "수영장 가기",
                                          style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                                    )
                                ),
                              ],
                            )
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
                                  //width: ((percent).w)*1.45,
                                  width: (100.w)*1.45,
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
                                    Text("100",style: TextStyle(color: AppColor.happyblue, fontSize: 11.sp, fontFamily: 'korean') ),
                                    //Text(percent.toStringAsFixed(1),style: TextStyle(color: AppColor.happyblue, fontSize: 11.sp, fontFamily: 'korean') ),
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
                ],
              ),
            ),

          ],
        ),


      ),
    );
  }
}
