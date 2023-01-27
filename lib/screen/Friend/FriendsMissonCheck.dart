import 'dart:ui';

import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/widget/PopPage.dart';
import 'package:like_button/like_button.dart';


Future<bool> onLikeButtonTapped(bool isLiked) async{
  //0127 소셜 기능

  return !isLiked;
}

class FriendMissionCheckPage extends StatefulWidget {
  FriendMissionCheckPage({
    Key? key,
    required this.userData,
    //required this.doMission,
  }) : super(key: key);

  final userData;
  //final doMission;

  @override
  State<FriendMissionCheckPage> createState() => _FriendMissionCheckPageState();
}

class _FriendMissionCheckPageState extends State<FriendMissionCheckPage> {

  var MissionOfFriend = null;
  int MissionOfFriendCnt = 0;

  @override
  void initState() {

    //print("친구의 미션 import");
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      print("불러올 친구 : ${widget.userData}");
      importFriendMissions(widget.userData['user_email']);
    });
  }

  importFriendMissions(String userEmail) async {
    MissionOfFriend = await select_request(
        "SELECT * FROM do_mission WHERE user_email = '${userEmail}'",
        null,
        false);

    MissionOfFriendCnt = (MissionOfFriend==null || MissionOfFriendCnt==false) ? 0 : MissionOfFriend.length;

    setState(() {});

  }

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
          child: MissionOfFriendCnt==0
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black), //default
                            children: [
                              TextSpan(text: '현재 '),
                              TextSpan(text: '${widget.userData['user_name']}', style: TextStyle(fontWeight: FontWeight.bold, )),
                              TextSpan(text: '님이 진행 중인 미션이 없습니다'),
                            ])
                    ),
                    //Text("현재 ${widget.userData['user_name']}님이 진행 중인 미션이 없습니다"),
                  ],
                )
                : Column(
            children: [

              Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50.w, 15.h, 50.w, 15.h),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [

                              SizedBox(
                                width: 40.w,
                                height: 20.h,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.contain,

                                  child: Text('${widget.userData['Ranking']}위', style: TextStyle(color: AppColor.happyblue, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                                ),
                              ),

                              SizedBox(
                                width: 160.w,
                                height: 24.h,
                                child: FittedBox(
                                  alignment: Alignment.centerLeft,
                                  fit: BoxFit.contain,

                                  child: Text(widget.userData['user_name'], style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
                                ),
                              ),



                            ],
                          ),


                          SizedBox(height: 8.h,),

                          SizedBox(
                            width: 200.w,
                            height: 16.h,
                            child: FittedBox(
                              alignment: Alignment.topLeft,
                              fit: BoxFit.contain,

                              child: Text(widget.userData['user_email'], style: TextStyle(color: Colors.black, )),
                            ),
                          ),



                        ],
                      ),

                      //0127 소셜기능 - 친구 삭제
                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10)
                      //     ),
                      //     primary: Colors.grey[700],
                      //     onPrimary: Colors.white,
                      //     minimumSize: Size(18.w, 28.h),
                      //     textStyle: TextStyle(fontSize: 18.sp),
                      //   ),
                      //
                      //   onPressed: () async {
                      //     PopPage(
                      //       "친구 삭제", context,
                      //       Text("삭제하시겠습니까?"),
                      //       "예",
                      //       "아니요",
                      //           () async {
                      //
                      //       }, null,
                      //     );
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text("친구 삭제",
                      //           style: TextStyle(fontFamily: 'korean', fontSize: 10.sp)),
                      //     ],
                      //   ),
                      // ),

                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h,),



              ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount:MissionOfFriendCnt,
              itemBuilder: (_, index) {

                int _index = all_missions.indexWhere((all_data) => all_data['mission_id'] == MissionOfFriend[index]['mission_id']);

                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: FriendMissionButton(userData: widget.userData, doMission: MissionOfFriend[index], allMissionIndex:_index),
                );
              }
              ),


            ],

          ),
        ),

      ),

    );
  }
}




class FriendMissionButton extends StatelessWidget {

  FriendMissionButton({
    Key? key,
    required this.userData,
    required this.doMission,
    required this.allMissionIndex,
  }) : super(key: key);

  final userData;
  final doMission;
  final int allMissionIndex;

  @override
  Widget build(BuildContext context) {

    String thumbnailImage = all_missions[allMissionIndex]['thumbnail'] ?? 'topimage1.png';

    return InkWell(
      onTap: () {
        // 친구의 진행상황을 볼 수 있는 페이지 (추후 추가 예정)
        
        // showDialog(context: context, builder: (BuildContext context) {
        //
        //   return BackdropFilter(
        //     filter: ImageFilter.blur(sigmaY: 6, sigmaX: 6),
        //     child: AlertDialog(
        //       title: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Text("${userData['user_name']}님의 미션",style: TextStyle(fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
        //           InkWell(
        //             onTap:(){Navigator.of(context).pop();},
        //             child: Icon(Icons.clear),
        //           )
        //         ],
        //       ),
        //       content: Container(
        //         height: 30.h,
        //         width: 10.w,
        //         decoration: BoxDecoration(
        //             color: Colors.grey
        //         ),
        //
        //       ),
        //
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //   );
        // });


      },
      child: Container(
        width: 400.w,
        //height: 75.h,
        decoration: BoxDecoration(
          color: Colors.white60,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 12.h, 0, 10.h),
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
                      backgroundImage: AssetImage('assets/image/thumbnail/${thumbnailImage}'),

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
                                            text: "${all_missions[allMissionIndex]['title']}",
                                            style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                                      )
                                  ),
                                ],
                              )
                          ),


                          SizedBox(height: 3.h),



                          //0127 소셜기능 - 좋아요
                          // LikeButton(
                          //   onTap: onLikeButtonTapped,
                          //   size: 20.w,
                          //   likeBuilder: (bool isLiked) {
                          //     return Icon(
                          //       Icons.favorite,
                          //       size: 20.w,
                          //       color: isLiked ? Colors.red : Colors.grey,
                          //     );
                          //   },
                          //   likeCount: 10,
                          //   countBuilder: (int? count, bool isLiked, String text) {
                          //     var color = isLiked? Colors.red : Colors.grey;
                          //     Widget result;
                          //     if(count == 0) {
                          //       result = Text("like", style: TextStyle(color: color),);
                          //     }
                          //     else {
                          //       result = Text(text, style: TextStyle(color: color),);
                          //       return result;
                          //     }
                          //   },
                          //
                          // ),

                          SizedBox(height: 4.h,),


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
                                  width: (double.parse(doMission['percent']).w)*1.45,
                                  //width: (100.w)*1.45,
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
                                      Text("${doMission['percent']}",style: TextStyle(color: AppColor.happyblue, fontSize: 11.sp, fontFamily: 'korean') ),
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


      ),
    );
  }
}
