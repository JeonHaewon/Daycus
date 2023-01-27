import 'dart:ui';

import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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

    print("친구의 미션 import");
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

    MissionOfFriendCnt = MissionOfFriend==null ? 0 : MissionOfFriend.length;

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
          child: Column(
            children: [

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
                                  width: (int.parse(doMission['percent']).w)*1.45,
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
    );
  }
}
