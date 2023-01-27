import 'package:daycus/backend/login/login.dart';
import 'package:daycus/core/app_bottom.dart';
import 'package:daycus/screen/Friend/FriendPage.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/widget/nowingmission.dart';
import 'package:daycus/screen/NoticePage.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/widget/NowNoMission.dart';
import 'package:daycus/screen/specificMissionPage/MissionCheckStatusPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';
import 'package:daycus/screen/myPage/privatesettings/PrivateSettings.dart';
import 'package:daycus/core/app_bottom.dart';




class MissionCheckPage extends StatefulWidget {
  const MissionCheckPage({Key? key}) : super(key: key);

  // 이거 그냥 한 곳에서 접근할 수 있게 하면 안되나??
  static final storage = FlutterSecureStorage();

  @override
  State<MissionCheckPage> createState() => _MissionCheckPageState();
}

class _MissionCheckPageState extends State<MissionCheckPage> {
  @override
  Widget build(BuildContext context) {

    int? do_mission_cnt = do_mission==null ? 0 : do_mission.length;
    Size m = MediaQuery.of(context).size;
    String misson_cnt = do_mission_cnt.toString();

    Future<void> refresh() async {
      await LoginAsyncMethod(MissionCheckPage.storage, context, true);
      setState(() { });
    };

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('미션인증',
            style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.person_add_alt_1_rounded),color: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FriendPage()),
                );
              }
          ),
          //IconButton(icon: Icon(Icons.search), onPressed: null),

          //알림 확인
          // IconButton(icon: Icon(Icons.notifications), color: Colors.grey,
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => NoticePage()),
          //       );
          //     }),

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
                    ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png"), radius: 13.sp,)
                    : Transform.rotate(angle: profileDegree* pi/180, child: CircleAvatar( backgroundImage: downloadProfileImage!.image, radius: 13.sp), )
                    : CircleAvatar( backgroundImage : FileImage(profileImage!), radius: 13.sp,)
            ),
          ),



        ],
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          RefreshIndicator(
            onRefresh: refresh,
            color: AppColor.happyblue,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: m.height,
                ),
                child: Column(

                  children: [

                    SizedBox(height: 30.h,),


                    Container(
                      width: 330.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.2),
                        //     spreadRadius: 5,
                        //     blurRadius: 7,
                        //   ),
                        // ],
                      ),
                      child: Padding(
                            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 15.h),
                            child: Column(
                              children: [
                                Text("미션 종료 후(15일차)에 반드시 '정산하기' 버튼을 눌러야 포인트가 지급됩니다. 단, 14일차에 인증을 하는 경우 인증 이후 바로 정산이 가능합니다.",
                                    style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', color: Colors.black) ),
                                SizedBox(height: 5.h,),

                                Text("※ 미션 종료 후 2주 내에 정산을 받지 않을 경우 리워드를 지급받지 못합니다.",
                                    style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',  color: Colors.red) ),
                              ],
                            ),
                          ),

                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 20.h,30.w, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [



                          Text("진행 중인 미션",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                          SizedBox(width: 20.w,),

                          Container(
                            height: 34.h,
                            child: Row(

                              children: [
                                Text(misson_cnt,style: TextStyle(color: Colors.grey[700],fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                Text("개 미션 참여 중",style: TextStyle(color: Colors.grey[700],fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                              ],
                            ),
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: 15.h,),

                    // 진행중인 미션이 없을 때
                    if(do_mission==null)
                    // 미션란으로 이동 !
                      NowNoMissionButton(onTap: (){
                        controller.currentBottomNavItemIndex.value = AppScreen.mission;
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
                            //print("do_mission : ${do_mission[index]['mission_index']}");
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
                                    mission_data: all_missions[_index],
                                    do_mission_data: do_mission[index],
                                  ),
                                ),

                                SizedBox(height: 7.h,),
                              ],
                            );
                          },
                        ),
                      ),


                    SizedBox(height: 60.h,),

                  ],
                ),
              ),

            ),
          ),
          //Advertisement(),
        ],

      ), //진행중인 미션



    );
  }
}