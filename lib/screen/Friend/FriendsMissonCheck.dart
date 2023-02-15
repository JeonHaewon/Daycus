import 'dart:convert';
import 'dart:ui';

import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/widget/PopPage.dart';
//import 'package:like_button/like_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../backend/NowTime.dart';


var LikeCount;

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

  var isBigonggae;

  @override
  void initState() {

    //print("친구의 미션 import");
    super.initState();
    isBigonggae = false;

    WidgetsBinding.instance.addPostFrameCallback((_){
      print("불러올 친구 : ${widget.userData}");
      importFriendMissions(widget.userData['user_email']);
    });
  }


  importFriendMissions(String userEmail) async {
    MissionOfFriend = await select_request(
        "SELECT * FROM do_mission WHERE user_email = '${userEmail}' and how = '친구공개'",
        null,
        false);
    isBigonggae = await select_request(
        "SELECT public FROM user_table WHERE user_email = '${userEmail}'",
        null,
        false);

    MissionOfFriendCnt = (isBigonggae[0]['public']=="비공개" || MissionOfFriend==null || MissionOfFriendCnt==false) ? 0 : MissionOfFriend.length;

    setState(() {});

  }

  @override
  Widget build(BuildContext context) {

    String misson_cnt = MissionOfFriendCnt.toString();

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
            ? Column(
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


                              Row(
                                children: [

                                  SizedBox(width: 40.w,),

                                  Icon(Icons.control_point_duplicate,
                                    size: 16.w,),

                                  SizedBox(width: 3.w,),


                                  SizedBox(
                                    width: 160.w,
                                    height: 18.h,
                                    child: FittedBox(
                                      alignment: Alignment.topLeft,
                                      fit: BoxFit.contain,
                                      child: Text((double.parse(widget.userData['reward'])).toStringAsFixed(1), style: TextStyle(color: Colors.black, )),
                                    ),
                                  ),


                                ],
                              ),

                            ],
                          ),

                          //0127 소셜기능 - 친구 삭제
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              primary: Colors.grey[700],
                              onPrimary: Colors.white,
                              minimumSize: Size(18.w, 28.h),
                              textStyle: TextStyle(fontSize: 18.sp),
                            ),

                            onPressed: () async {
                              PopPage(
                                "친구 삭제", context,
                                Text("삭제하시겠습니까?"),
                                "예",
                                "아니요",
                                    () async {
                                  var fr = await select_request("select friends from user_table where user_email = '${widget.userData['user_email']}' ", null, true);
                                  var myfr = await select_request("select friends from user_table where user_email = '${user_data['user_email']}'",null,true);
                                  var fr2 = jsonDecode(fr[0]['friends']);
                                  var myfr2 = jsonDecode(myfr[0]['friends']);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  fr2.remove("${user_data['user_id']}");
                                  myfr2.remove("${widget.userData['user_id']}");
                                  await update_request("update user_table set friends = '${jsonEncode(fr2)}' where user_email = '${widget.userData['user_email']}'", null);
                                  await update_request("update user_table set friends = '${jsonEncode(myfr2)}' where user_email = '${user_data['user_email']}'", null);
                                }, null,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("친구 삭제",
                                    style: TextStyle(fontFamily: 'korean', fontSize: 10.sp)),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.black), //default
                              children: [
                                TextSpan(text: '현재 '),
                                TextSpan(text: '${widget.userData['user_name']}', style: TextStyle(fontWeight: FontWeight.bold, )),
                                TextSpan(text: '님이 진행 중인 공개된 미션이 없습니다'),
                              ])
                      ),
                      //Text("현재 ${widget.userData['user_name']}님이 진행 중인 미션이 없습니다"),
                    ],
                  ),
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


                            Row(
                              children: [

                                SizedBox(width: 40.w,),

                                Icon(Icons.control_point_duplicate,
                                  size: 16.w,),

                                SizedBox(width: 3.w,),


                                SizedBox(
                                  width: 160.w,
                                  height: 18.h,
                                  child: FittedBox(
                                    alignment: Alignment.topLeft,
                                    fit: BoxFit.contain,
                                    child: Text((double.parse(widget.userData['reward'])).toStringAsFixed(1), style: TextStyle(color: Colors.black, )),
                                  ),
                                ),


                              ],
                            ),

                          ],
                        ),

                        //0127 소셜기능 - 친구 삭제
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            primary: Colors.grey[700],
                            onPrimary: Colors.white,
                            minimumSize: Size(18.w, 28.h),
                            textStyle: TextStyle(fontSize: 18.sp),
                          ),

                          onPressed: () async {
                            PopPage(
                              "친구 삭제", context,
                              Text("삭제하시겠습니까?"),
                              "예",
                              "아니요",
                                  () async {
                                var fr = await select_request("select friends from user_table where user_email = '${widget.userData['user_email']}' ", null, true);
                                var myfr = await select_request("select friends from user_table where user_email = '${user_data['user_email']}'",null,true);
                                var fr2 = jsonDecode(fr[0]['friends']);
                                var myfr2 = jsonDecode(myfr[0]['friends']);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                fr2.remove("${user_data['user_id']}");
                                myfr2.remove("${widget.userData['user_id']}");
                                await update_request("update user_table set friends = '${jsonEncode(fr2)}' where user_email = '${widget.userData['user_email']}'", null);
                                await update_request("update user_table set friends = '${jsonEncode(myfr2)}' where user_email = '${user_data['user_email']}'", null);
                              }, null,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("친구 삭제",
                                  style: TextStyle(fontFamily: 'korean', fontSize: 10.sp)),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h,),


                Padding(
                  padding: EdgeInsets.fromLTRB(42.w, 0, 42.w, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 5.w,),
                      Text("${misson_cnt}개 미션 참여 중",style: TextStyle(color: Colors.grey[700],fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                    ],
                  ),
                ),

                SizedBox(height: 8.h,),

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

              SizedBox(height: 20.h,),


            ],

          ),
        ),

      ),

    );
  }
}



class FriendMissionButton extends StatefulWidget {

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
  State<FriendMissionButton> createState() => _FriendMissionButtonState();
}

class _FriendMissionButtonState extends State<FriendMissionButton> {
  var HowManyHeart = 0;

  int doneCnt = 0;
  int todayBlockCnt = 0;
  bool is_load = false;

  double _height = 35.w;
  double _sp = 12.w;
  double _width = 35.w;

  double _betweenWidth = 3.w;

  var isHeart;
  var whoPressHeart;

  settingisHeart() async {
    var prewhoheart = await select_request("select who_heart from do_mission where user_email = '${widget
        .doMission['user_email']}' and mission_id = '${widget
        .doMission['mission_id']}'", null, true);
    var whoheart = jsonDecode(prewhoheart[0]['who_heart'] ?? "{}");
    if (whoheart.keys.contains(user_data['user_id'])){
      isHeart = true;
    }
    else {
      isHeart = false;
    }

    return whoheart;
  }

  initHeart() async {
    whoPressHeart = await settingisHeart();
  }

  bool waitingg = false;

  inn_one_init() async {

    await initHeart();
    setState(() { waitingg = true; });

  }


  // 최적화가 필연적으로 필요

  onHeartTap() async {
    await initHeart();
    if (isHeart){
      whoPressHeart.remove(user_data['user_id']);
    }
    else{
      whoPressHeart['${user_data['user_id']}'] = '1';
    }
    await update_request("update do_mission set who_heart = '${jsonEncode(whoPressHeart)}' where user_email = '${widget
        .doMission['user_email']}' and mission_id = '${widget
        .doMission['mission_id']}'", null);
  }



  ImportHowManyHeart () {
    HowManyHeart = (widget.doMission['heart']==null ? 0 : int.parse(widget.doMission['heart']));
  }

  var pdatelist;
  var datelist;

  select_datelist() async {
    datelist = [];
    var predatelist = await select_request("select d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14 from do_mission where user_email = '${widget
        .doMission['user_email']}' and mission_id = '${widget
        .doMission['mission_id']}'", null, true);
    pdatelist = predatelist[0];
    for (var key in pdatelist.keys){
      if (pdatelist[key]!=null && pdatelist[key]!='0'){
        datelist.add(key[1].toString());
      }
    }
  }


  void initState() {
    super.initState();
    ImportHowManyHeart();
    WidgetsBinding.instance.addPostFrameCallback((_){
      inn_one_init();
    });

  }

  void dispose() {
    super.dispose();
    update_request("update do_mission set heart = '$HowManyHeart' where user_email = '${widget
        .doMission['user_email']}' and mission_id = '${widget
        .doMission['mission_id']}'", null);
  }

  @override
  Widget build(BuildContext context) {


    String thumbnailImage = all_missions[widget.allMissionIndex]['thumbnail'] ?? 'topimage1.png';


    int index_i = -1; int index_j = -1;

    update_todayBlockcnt() async {
      String now_time = await NowTime("yyyyMMdd");
      var chh = await select_request("select start_date from missions where mission_id = '${widget.doMission['mission_id']}'", null, true);
      var cgg = chh[0]['start_date'];
      todayBlockCnt = DateTime.parse(now_time)
          .difference((DateTime.parse(cgg))).inDays + 1;
    }



    return InkWell(
      onTap: () async{
        await select_datelist();
        await update_todayBlockcnt();
        // 친구의 진행상황을 볼 수 있는 페이지 (추후 추가 예정)

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 6, sigmaX: 6),
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${widget.userData['user_name']}님의 미션",style: TextStyle(fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  InkWell(
                    onTap:(){
                      index_i = -1; index_j = -1;
                      Navigator.of(context).pop();
                      },
                    child: Icon(Icons.clear),
                  )
                ],
              ),
              content: Container(
                height: _height * 2 + _betweenWidth,
                width: _width * 7 + _betweenWidth * 7 + 30.w,
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (_, ___){
                    index_i += 1; index_j = -1;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width:_width * 7 + _betweenWidth * (7-1),
                              height: _height,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,

                                  itemCount : 7,
                                  itemBuilder: (_,__) {
                                    index_j += 1;
                                    int date = (index_i*7)+(index_j+1);

                                    if (all_missions[widget.allMissionIndex]['d${date}']!=null){
                                      doneCnt += 1 ;
                                    }
                                    // 최적화가 필요

                                    return Row(
                                      children: [

                                        SizedBox(
                                            height: _height,
                                            width: _width,
                                            child: datelist.contains(date.toString()) == false

                                            // 아직 인증하지 않은 날짜 블럭, date+1 = 오늘 카운트
                                                ? (todayBlockCnt <= date ?
                                            // 날짜가 지나지 않았으면
                                            YetMissionBlock(i: index_i, j: index_j, sp: _sp,
                                              )
                                                : FailMissionBlock(sp: _sp)
                                            )
                                            // 인증 완료된 날짜 블럭
                                                : DoneMissionBlock(i: index_j, j: index_j, sp: _sp, date: date,
                                            )
                                        ),
                                        if(index_j != 7-1)
                                          SizedBox(
                                            width: _betweenWidth,
                                          ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),

                        if (index_i == 0)
                          SizedBox(
                            height: 3.w,
                          ),
                      ],
                    );

                  },

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

                          Row(
                            children: [

                              Container(
                                  width: 240.w,
                                  //height: 28.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Container(
                                          width: 190.w,
                                          //height: 28.h,

                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    text: TextSpan(
                                                      //text: title,
                                                        text: "${all_missions[widget.allMissionIndex]['title']}",
                                                        style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                                                  )
                                              ),


                                            ],
                                          )
                                      ),


                                      // LikeButton(
                                      //   onTap: onLikeButtonTapped,
                                      //   size: 20.w,
                                      //   likeBuilder: (bool isLiked) {
                                      //     isLiked = ImLiked;
                                      //     return Icon(
                                      //       Icons.favorite,
                                      //       size: 20.w,
                                      //       color: isLiked ? Colors.red : Colors.grey,
                                      //     );
                                      //   },
                                      //   //likeCount: 10,
                                      //   countBuilder: (int? count, bool isLiked, String text) {
                                      //     isLiked = ImLiked;
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
                                      // ),

                                      SizedBox(width: 5.w,)

                                    ],
                                  )
                              ),

                            ],
                          ),



                          SizedBox(height: 3.h),



                          //0127 소셜기능 - 좋아요
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await onHeartTap();
                                  isHeart = !isHeart;
                                  setState(() {
                                    if (isHeart){
                                      HowManyHeart += 1;
                                    } else{HowManyHeart -= 1;}
                                  });
                                },
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: ((child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  }),
                                  child: waitingg
                                      ? (!isHeart ? Icon(
                                    key: ValueKey('UN_FAVORITE'),
                                    Icons.favorite_border_outlined,
                                    size: 18.sp,
                                  )
                                      : Icon(
                                      key: ValueKey('FAVORITE'),
                                      Icons.favorite_outlined,
                                      color: Colors.red,
                                      size: 18.sp)) : Icon(
                                    key: ValueKey('UN_FAVORITE'),
                                    Icons.favorite_border_outlined,
                                    size: 18.sp,
                                  )
                                ),
                              ),

                              SizedBox(width: 5.w,),

                              Text(HowManyHeart.toString(),style: TextStyle(color: Colors.black, fontSize: 13.sp, fontFamily: 'korean') ),
                            ],
                          ),

                          SizedBox(width: 9.w),


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
                                  width: (double.parse(widget.doMission['percent']).w)*1.45,
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
                                      Text("${widget.doMission['percent']}",style: TextStyle(color: AppColor.happyblue, fontSize: 11.sp, fontFamily: 'korean') ),
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



class FailMissionBlock extends StatelessWidget {
  const FailMissionBlock({
    Key? key,
    required this.sp,
    this.onTap,
  }) : super(key: key);

  final double sp;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){},
        // 원래 pink[40], red 이었음.
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[300])),
        child: Text('X',style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
    );
  }
}

class DoneMissionBlock extends StatelessWidget {
  DoneMissionBlock({
    Key? key,
    required this.i,
    required this.j,
    required this.sp,
    required this.date,

  }) : super(key: key);

  final int i;
  final int j;
  final double sp;
  final int date;


  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {

        },
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
        child: Text(date.toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
    );
  }
}

class YetMissionBlock extends StatelessWidget {
  const YetMissionBlock({
    Key? key,
    required this.i,
    required this.j,
    required this.sp,

  }) : super(key: key);

  final int i;
  final int j;
  final double sp;


  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {

        },
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
        child: Text(((i*7)+(j+1)).toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) ) );
  }
}




