import 'dart:convert';

import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/screen/Friend/FriendPage.dart';
import 'package:daycus/screen/specificMissionPage/SpecificMissionPage.dart';
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
  var invitesss;
  from_invitation () async {
    invite = [];
    invitekey = [];
    var invites = await select_request("select invitation from user_table where user_email = '${user_data['user_email']}'", null, true);
    var invitess = invites[0]['invitation'];
    invitesss = jsonDecode(invitess);
    for (var item in invitesss.keys){
      var username = await select_request("select user_name from user_table where user_id = '$item'", null, true);
      invite.add(username[0]['user_name']);
      invitekey.add(item);
    }
    setState(() {

    });
  }
  var i;
  var invitekey;
  finding_index(String name) async {
    for (int j = 0; j < all_missions.length; j++) {
      if (all_missions[j]['mission_id'] == invitesss[name]) {
        i = j;
        break;
      }
    }
    invitesss.remove(name);
    // 하임님 요거 all_missions[index] 에서 mission_id랑 Index가 안맞아서 mission 상세 페이지로 이동이 안되요 ㅠㅠ
    setState(() {

    });
  }


  from_friend () async {
    friend = [];
    friends = [];
    invitekey = [];
    var invites = await select_request("select friends from user_table where user_email = '${user_data['user_email']}'", null, true);
    var invitess = invites[0]['friends'];
    var invitesss = jsonDecode(invitess);
    for (var item in invitesss.keys){
      invitekey.add(item);
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
    await from_invitation();
    setState(() { notice_waiting = true; });
  }

  void initState(){
    super.initState();
    notice_waiting = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // from_invitation();
      //from_friend();
      allin_one_init();
    });
  }

  SpecificMissionPage onfunc() {
    update_request("update user_table set invitation = '${jsonEncode(invitesss)}' where user_email = '${user_data['user_email']}'", null);
    return SpecificMissionPage(
            mission_data: all_missions[i],
            startDate: all_missions[i]['start_date'],
            mission_id: all_missions[i]['mission_id'],
            topimage: all_missions[i]['thumbnail'] ?? 'topimage1.png',

            progress:all_missions[i]['start_date']==null
                ? (all_missions[i]['next_start_date']==null
                ? "willbutton" : "comeonbutton") : "ingbutton",

            title : all_missions[i]['title'],

            duration: all_missions[i]['start_date']==null
                ? comingSoonString : all_missions[i]['start_date']+" ~ "+all_missions[i]['end_date'],

            totaluser: int.parse(all_missions[i]['total_user']),
            certifi_user: int.parse(all_missions[i]['certifi_user']),
            downimage: 'downimage1',
            content: all_missions[i]['content'],
            rules: all_missions[i]['rules'],
            rewardPercent: all_missions[i]['reward_percent']);
  }

  void dispose (){
    super.dispose();
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
                            finding_index(invitekey[index]);
                            print(invite.isEmpty);
                            return Column(
                              children: !(invite.isEmpty) ? [
                                Notice(profileimage: "d", freindName: "${invite[index]}", check: true, content: "${all_missions[i]['title']} 미션에 초대하셨습니다", onTap:

                                onfunc())

                              ] : [Text("ddgee")],
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
        onTap;
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
