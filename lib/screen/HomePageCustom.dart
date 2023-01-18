import 'package:daycus/backend/ImportData/imageDownload.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/core/notification.dart';
import 'package:daycus/screen/CheckConnection.dart';
import 'package:daycus/screen/specificMissionPage/MissionCheckStatusPage.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:daycus/widget/HomePageUserInfoBar.dart';
import 'package:daycus/widget/NowNoMission.dart';
import 'package:daycus/widget/SpecificMissionToPage.dart';
import 'package:daycus/widget/homePage/topRanking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';
import 'package:daycus/widget/nowingmission.dart';
import 'package:daycus/screen/NoticePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/widget/RankingBar.dart';
import 'dart:math';
import 'package:daycus/screen/myPage/privatesettings/PrivateSettings.dart';
import 'package:daycus/screen/MissionAddPage.dart';
import 'package:daycus/screen/Friend/FriendPage.dart';



late ScrollController _scrollController = ScrollController();
//late ScrollController _scrollController1 = ScrollController();

DateTime? currentBackPressTime;



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static final storage = FlutterSecureStorage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    InitAsyncMethod();
  }

  InitAsyncMethod() async {
    profileImageReNamed = null;
    // 이거검토 필요
    // profileImageRename은 그대로 null임. 그래서 change 했는지를 판단할 수 있음.
    if (user_data['profile']!=null && downloadProfileImage==null) {
      var result = await image_download_root(
          "image_application/user_profile", user_data['profile']);
      downloadProfileImage = result[0] ; profileDegree = result[1];
    }
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch(state){
  //     case AppLifecycleState.resumed:
  //       break;
  //     case AppLifecycleState.inactive:
  //       // time_showNotification();
  //       break;
  //     case AppLifecycleState.detached:
  //       // time_showNotification();
  //       break;
  //     case AppLifecycleState.paused:
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    // 최대 3개만 보여줌
    int? do_mission_cnt = do_mission==null
        ? 0 : (do_mission.length<4 ? do_mission.length : 3);
    int do_mission_real_cnt = do_mission==null ? 0 : do_mission.length;

    // 랭킹
    int rankingCnt = rankingList==null ? 0 : rankingList!.length;


    // 데이터 리로드
    Future<void> refresh() async {
      await LoginAsyncMethod(HomePage.storage, context, true);
      setState(() { });
    };




    return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('DAYCUS',
              style: TextStyle(color: Colors.black, fontSize: 25.sp)),
          actions: [
          //IconButton(icon: Icon(Icons.search), onPressed: null),

            //알림 확인
            // IconButton(icon: Icon(Icons.notifications),color: Colors.grey,
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (_) => NoticePage()),
            //       );
            //     }
            // ),

            //친구 추가
            IconButton(icon: Icon(Icons.person_add_alt_1_rounded),color: Colors.grey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FriendPage()),
                  );
                }
            ),


            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PrivateSettings()),
                );
              },

              child: Container(
                  padding: EdgeInsets.all(14.sp),
                  child: (profileImage==null)
                  // 고른 프로필 사진이 없을 때
                      ? (user_data['profile']==null || downloadProfileImage==null)
                      ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png",), radius: 13.sp,)
                      : Transform.rotate(angle: profileDegree* pi/180, child: CircleAvatar( backgroundColor : Colors.grey[200],  backgroundImage: downloadProfileImage!.image, radius: 13.sp), )
                      : CircleAvatar( backgroundImage : FileImage(profileImage!), radius: 13.sp,)
              ),
            ),



          ],
          automaticallyImplyLeading: false,
        ),

      //

        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            RefreshIndicator(
              color: AppColor.happyblue,
              onRefresh: refresh,
              child: SingleChildScrollView(
                primary: true,
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),


                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(30.w, 0, 25.w, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 25.h,),
                                    Text("안녕하세요",style: TextStyle(fontSize: 30.sp, fontFamily: 'korean') ),
                                    SizedBox(
                                      width: 170.w,
                                      height: 40.h,
                                      child: FittedBox(
                                        alignment: Alignment.topLeft,
                                        fit: BoxFit.contain,

                                        child: Text("${user_data['user_name']} 님",
                                            style: TextStyle(fontSize: 30.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
                                      ),
                                    ),

                                    //Text("${user_data['user_name']} 님",style: TextStyle(fontSize: 30.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
                                    SizedBox(height: 40.h,),
                                    Text("현재 등급",style: TextStyle(color: Colors. grey, fontSize: 20.sp, fontFamily: 'korean') ),
                                    SizedBox(height: 5.h,),
                                    Container(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset('assets/image/medal.svg' , fit: BoxFit.fill, ),
                                          Text("Lv${user_data['user_lv']}",style: TextStyle(color: AppColor.happyblue, fontSize: 20.sp, fontFamily: 'korean') ),
                                          SizedBox(width: 5.w,),
                                        ],
                                      ),
                                    ),


                                    // 레벨 바
                                    Container(
                                      //해원 : top 20.h > 10.h
                                      padding: EdgeInsets.only(top: 10.h, left: 3.w, right: 3.w),
                                      width: 170.w,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Text("0 ${rewardEnglish}"), Text("10 ${rewardEnglish}"),
                                          //   ],
                                          // ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("다음 레벨까지", style: TextStyle(fontSize: 10.sp),),
                                              Text("${(lv_end-double.parse(user_data['reward'])).toStringAsFixed(1)}${rewardName}", style: TextStyle(fontSize: 10.sp),),
                                            ],
                                          ),

                                          SizedBox(height: 2.h,),

                                          // 레벨 바
                                          Row(
                                            children: [
                                              Stack(
                                                children: [

                                                  Container(
                                                    width: 164.w,
                                                    height: 12.h,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey[400],
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                  ),

                                                  Container(
                                                    width: (164.w * lv_percent),
                                                    height: 12.h,
                                                    decoration: BoxDecoration(
                                                        color: AppColor.happyblue,
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                  ),

                                                ],
                                              ),

                                            ],
                                          ),


                                          //SizedBox(height: 5.h,),
                                        ],
                                      ),
                                    ),

                                  ],

                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 24.w, 0),
                            child: Container(

                              child: Column(
                                children: [

                                  SizedBox(height: 40.h,),

                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                        height: 210.h,
                                        width: 150.w,
                                        child: Image.asset('assets/image/character.png' , fit: BoxFit.fill,height: 220.h)),
                                  ),

                                  //Image.asset('assets/image/character.png' , fit: BoxFit.fill,height: 220.h),
                                  //SvgPicture.asset('assets/image/character.svg' , fit: BoxFit.fill,height: 240.h),
                                ],
                              ),
                            ),//오른쪽 asset,
                          ),
                          //왼쪽에 글자랑 등급들




                        ],
                      ),
                    ),//위쪽 제일 큰 박스

                    SizedBox(height: 15.h,),


                    HomePageUserInfoBar(leftContent: "나의 ${rewardName}", rightContent: "${double.parse(user_data['reward']).toStringAsFixed(1)} ${rewardName}",icon: Icons.control_point_duplicate,),


                    // SizedBox(height: 10.h,),
                    // HomePageUserInfoBar(leftContent: "이번주 랭킹", rightContent: "${user_data['Ranking'] ?? "-"} 등", icon: Icons.people),

                    topRanking(),

                    //SizedBox(height: 10.h,),
                    Column(
                      children: [
                        Container(
                          width: 360.w,
                          //height:250.h,
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Column(
                            children: [

                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5.h, 0, 5.h),
                                child: Container(
                                  width: 310.w,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      Text("주간랭킹",style: TextStyle(color: Colors.white, fontSize: 10.sp, fontFamily: 'korean') ),
                                    ],
                                  ),
                                ),
                              ),


                              Container(
                                width : 300.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[100],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50.w,
                                      alignment: Alignment.center,
                                      child: Text("순위", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.sp, )),
                                    ),

                                    SizedBox(width: 5.w,),

                                    Container(
                                      width: 135.w,
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child:Text("닉네임", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.sp, ),),
                                      ),
                                    ),


                                    Container(
                                      width: 90.w,
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child:Row(
                                            children: [

                                              Text("${rewardName}", style: TextStyle( fontWeight: FontWeight.bold, fontSize: 9.sp,),),
                                            ],
                                          )
                                      ),
                                    ),

                                  ],

                                ),
                              ),
                              SizedBox(height: 3.h,),

                              Container(
                                width : 300.w,
                                height: 170.h,
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

                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: rankingCnt,
                                            itemBuilder: (_, index) {
                                              return RankingBar(
                                                rankNum : int.parse(rankingList![index]['Ranking']),
                                                userName : rankingList![index]['user_name'],
                                                rewards : double.parse(rankingList![index]['reward']),
                                                mine: rankingList![index]['user_id']==user_data['user_id'],
                                              );
                                            },
                                          ),

                                          // RankingBar(2, "ggggg", 100000),
                                          // RankingBar(3, "bbbbbbb", 9800),
                                          // RankingBar(4, "dddddd", 1030),
                                          // RankingBar(5, "dfdfdfdf", 1030),
                                          // RankingBar(6, "dfdfdf3", 930),
                                          // RankingBar(7, "dfdge", 90),
                                          // RankingBar(8, "3t3t", 10),
                                          // RankingBar(9, "가가가가", 9),
                                          // RankingBar(10, "2145", 8),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 6.h,),
                              Text("※ 자신을 기준으로 위아래 2순위까지 표시됩니다",style: TextStyle(fontSize: 9.sp, fontFamily: 'korean', color: Colors.grey[600]) ),
                              SizedBox(height: 8.h,),

                            ],
                          ),
                        ),



                      ],


                    ),




                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding: EdgeInsets.fromLTRB(35.w, 40.h, 30.w, 5.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("진행 중인 미션",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                                Column(
                                  children: [
                                    SizedBox(
                                      height: 10.sp,
                                    ),
                                    // 미션 더보기
                                    TextButton(
                                        onPressed: (){
                                          controller.currentBottomNavItemIndex.value = 1;
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Text('더보기 >',style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', decoration: TextDecoration.underline,color: Colors.black, fontWeight: FontWeight.bold) )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          //SizedBox(height: 10.h,),

                          // 진행중인 미션이 없을 때
                          if(do_mission==null)
                          // 미션란으로 이동 !
                            NowNoMissionButton(onTap: (){
                              controller.currentBottomNavItemIndex.value = 3;
                            },),

                          // 진행중인 미션이 있을 때
                          if(do_mission!=null)
                            Container(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: do_mission_cnt,
                                itemBuilder: (_, index) {
                                  //id가 1부터 시작한다.
                                  int _index = do_mission[index]['mission_index'];
                                  //print("${_index}, ${_index.runtimeType}");
                                  //print(all_missions[_index]);
                                  return Column(
                                    children: [
                                      NowMissionButton(
                                        duration: all_missions[_index]['start_date']==null
                                            ? "미션 종료" : ((all_missions[_index]['start_date']).substring(5,10)+" ~ "+(all_missions[_index]['end_date']).substring(5,10)),
                                        image: all_missions[_index]['thumbnail']==''
                                            ? 'missionbackground.png' : all_missions[_index]['thumbnail'],
                                        title: all_missions[_index]['title'],
                                        currentUser: int.parse(all_missions[_index]['now_user']),
                                        rank: 1,
                                        percent: double.parse(do_mission[index]['percent']),
                                        onTap: MissionCheckStatusPage(
                                          mission_index: _index,
                                          do_mission_data: do_mission[index],
                                          mission_data: all_missions[_index],
                                        ),),

                                      if (index+1 < do_mission_cnt!)
                                        SizedBox(height: 7.h,),
                                    ],
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ), //진행중인 미션

                    // 진행중인 미션이 3개 이상일 경우
                    if (do_mission_real_cnt!=do_mission_cnt)

                      InkWell(
                        onTap: () {
                          controller.currentBottomNavItemIndex.value = 1;
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 15.h,0, 0),
                          child: Container(
                            width: 120.w,
                            height: 38.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("외 ${do_mission_real_cnt-3}개의 미션 ",
                                      style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 12.sp) ),

                                  Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 10.w,)
                                ],
                              ),

                            ),
                          ),
                        ),
                      ),





                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Padding(
                            padding: EdgeInsets.fromLTRB(35.w, 45.h, 25.w, 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("금주의 추천 미션",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),



                                // InkWell(
                                //   onTap: () {
                                //
                                //   },
                                //   child: Container(
                                //     width: 100.w,
                                //     height: 30.h,
                                //     decoration: BoxDecoration(
                                //       color: Colors.blueGrey[400],
                                //       borderRadius: BorderRadius.circular(3),
                                //     ),
                                //     child: Container(
                                //       child: Row(
                                //         crossAxisAlignment: CrossAxisAlignment.center,
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Text("미션 추가",
                                //               style: TextStyle(color: Colors.white, fontSize: 11.sp) ),
                                //
                                //           //Icon(Icons.arrow_forward_ios, color: Colors.white, size: 10.w,)
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                    ),
                                    onPressed: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => MissionAddPage()));
                                    },
                                    child: Icon(Icons.add, color: Colors.black,)),


                              ],
                            ),
                          ),


                          // Container(
                          //   width: 360.w,
                          //   child: ListView.builder(
                          //     shrinkWrap: true,
                          //     physics: NeverScrollableScrollPhysics(),
                          //     itemCount:
                          //     (missions_cnt % 2 == 0 ? missions_cnt / 2 : missions_cnt ~/ 2 + 1).toInt(),
                          //     itemBuilder: (_, index) {
                          //       extraindex += 2;
                          //       return Column(
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               SpecificMissionToPage(i: extraindex),
                          //               if (extraindex + 1 < missions_cnt)
                          //                 SpecificMissionToPage(i: extraindex+1),
                          //             ],
                          //           ),
                          //           SizedBox(height: 15.h,),
                          //         ],
                          //       );
                          //     },
                          //   ),
                          // ),

                          Wrap(
                            children: List.generate(missions_cnt, (index) {
                              // 참여하고 있지 않은 것만 뜸.
                              if (all_missions[missions_cnt-index-1]['now_user_do']==null && all_missions[missions_cnt-index-1]['mission_state']!='done') {
                                return Container(
                                  width: 175.w,
                                  margin: EdgeInsets.only(bottom: 15.h, left: 17.w),
                                  child: SpecificMissionToPage(i: missions_cnt-index-1),
                                );
                              }
                              // 참여하고 있는 건 안뜸.
                              else {
                                return Container(width: 0.w,);
                              }
                            }
                            ),
                          ),




                          SizedBox(height: 60.h,),


                        ],
                      ),

                    ), //금주의 추천 미션



                  ],
                ),
              ),

            ),

            //Advertisement(),
          ],

        ),



    );


  }
}

