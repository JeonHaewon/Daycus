import 'dart:convert';

import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/screen/Friend/FriendPage.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

late ScrollController _scrollController = ScrollController();
late ScrollController _scrollController2 = ScrollController();

bool notice_waiting = false;

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {

  var invite = [];
  var friend = [];
  var friends = [];
  from_invitation () async {
    invite = [];
    var invites = await select_request("select invitation from user_table where user_email = '${user_data['user_email']}'", null, true);
    var invitess = invites[0]['invitation'];
    var invitesss = jsonDecode(invitess);
    if (invitesss.keys!=null){
      for (var item in invitesss.keys){
        invite.add(item);
      }
    }
    setState(() {

    });
  }
  from_friend () async {
    friend = [];
    friends = [];
    var invites = await select_request("select friends from user_table where user_email = '${user_data['user_email']}'", null, true);
    var invitess = invites[0]['friends'];
    var invitesss = jsonDecode(invitess);
    for (var item in invitesss.keys){
      if (invitesss[item]=='-1'){
        friend.add(item);
      }
    }
    print(friend);
    for (var item in friend){
      var username = await select_request("select user_name from user_table where user_id = '$item'", null, true);
      friends.add(username[0]['user_name']);
    }
    print(friends);
    setState(() {

    });
  }

  allin_one_init() async {
    await from_friend ();
    setState(() { notice_waiting = true; });
  }

  void initState(){
    super.initState();
    notice_waiting = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      from_invitation();
      //from_friend();
      allin_one_init();
    });
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
        title: Text('알림',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
       
          children: [

            SizedBox(height: 20.h,),

            Container(
              width : double.infinity,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(35.w, 0, 0, 0),
                  child: Text("미션 초대 알림",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.w500),)),

            ),
            SizedBox(height: 10.h,),

            Container(
              width : 400.w,
              height: 320.h,
              // decoration: BoxDecoration(
              //   color: Colors.black
              // ),
              child: Scrollbar(
                controller: _scrollController,
                isAlwaysShown: true,
                thickness: 8,
                radius: Radius.circular(10),
                //scrollbarOrientation: ScrollbarOrientation.right,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowGlow();
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [

                        if(invite.isEmpty)
                          Text("새로운 미션 초대 알림이 없습니다", style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',)),
                        
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: invite.length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: [
                                !invite.isEmpty ?
                                Notice(profileimage: "d", freindName: "${invite[index]}", check: true, content: "하루 물 3잔 마시기 미션에 초대하셨습니다", onTap: NoticePage()) :
                                Text("새로운 미션 초대 알림이 없습니다"),
                              ],
                            );
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 25.h,),

            Container(
              width : double.infinity,
              child: Padding(
                padding: EdgeInsets.fromLTRB(35.w, 0, 0, 0),
                child: Text("친구 요청 알림",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.w500),)),
            ),
            SizedBox(height: 10.h,),

            Container(
              width : 400.w,
              height: 320.h,

              child: Scrollbar(
                controller: _scrollController2,
                isAlwaysShown: true,
                thickness: 8,
                radius: Radius.circular(10),
                //scrollbarOrientation: ScrollbarOrientation.right,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowGlow();
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController2,
                    child: Column(
                      children: [

                        if(friend.isEmpty)
                          Text("새로운 친구 요청이 없습니다", style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',)),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: friend.length,
                          itemBuilder: (_, index) {
                            return Column(
                              children: notice_waiting ? [
                                friend.isNotEmpty ?
                                Notice(profileimage: "d", freindName: "${friends[index]}", check: true, content: "친구 요청을 보냈습니다", onTap: FriendPage()) :
                                Text("새로운 친구 요청이 없습니다"),
                              ]:[],
                            );
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h,),


          ],
        ),
      ),
    );
  }
}



class Notice extends StatelessWidget {
  Notice({
    Key? key,
    required this.profileimage,
    required this.freindName,
    required this.content,
    required this.check,
    this.onTap,
  }) : super(key: key);

  final String profileimage;
  final String freindName;
  final String content;
  final bool check;
  final onTap;


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
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              CircleAvatar(
                radius: 16.w,
                backgroundImage : profileimage!=null
                  ? AssetImage("assets/image/non_profile.png",)
                  : AssetImage("assets/image/non_profile.png"),
              ),

              SizedBox(width: 6.w,),

              Container(
                width: 290.w,
                //height: 10.h,
                child: Text("${freindName} 님이 ${content}",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',)),
              ),

              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                    color: check==false ? Colors.red : AppColor.background,
                    shape: BoxShape.circle
                ),
              ),

            ],
          ),
        ),
      ),

    );
  }
}





// InkWell(
//   onTap: () {
//
//   },
//   child: Container(
//     width: double.infinity,
//     child: Padding(
//       padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 10.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//
//
//
//           CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png",), radius: 16.w,),
//
//           SizedBox(width: 6.w,),
//
//           Container(
//             width: 290.w,
//             //height: 10.h,
//             child: Text("퇴근퇴근 님이 하루 물 3잔 마시기 미션에 초대하셨습니다",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',)),
//           ),
//
//           Container(
//             width: 8.w,
//             height: 8.h,
//             decoration: BoxDecoration(
//               color: Colors.red,
//               shape: BoxShape.circle
//
//             ),
//           ),
//
//         ],
//       ),
//     ),
//   ),
//
// ),
