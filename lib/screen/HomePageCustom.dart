import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/screen/specificMissionPage/MissionCheckStatusPage.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:daycus/widget/HomePageUserInfoBar.dart';
import 'package:daycus/widget/NowNoMission.dart';
import 'package:daycus/widget/SpecificMissionToPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';
import 'package:daycus/widget/nowingmission.dart';
import 'package:daycus/screen/NoticePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static final storage = FlutterSecureStorage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    int extraindex = -2;
    // 최대 3개만 보여줌
    int? do_mission_cnt = do_mission==null
        ? 0 : (do_mission.length<4 ? do_mission.length : 3);
    int do_mission_real_cnt = do_mission==null ? 0 : do_mission.length;


    // 데이터 리로드
    Future<void> refresh() async {
      await LoginAsyncMethod(HomePage.storage, null, true);
      setState(() { });
    };

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('DAYCUS',
            style: TextStyle(color: Colors.black, fontSize: 25.sp)),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: null),
          IconButton(icon: Icon(Icons.notifications),color: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NoticePage()),
                );
              }
          ),

        ],
        automaticallyImplyLeading: false,
      ),

      //

      body: RefreshIndicator(
        color: AppColor.happyblue,
        onRefresh: refresh,
        child: SingleChildScrollView(
          primary: true,
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),


          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(30.w, 0, 40.w, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 25.h,),
                                Text("안녕하세요",style: TextStyle(fontSize: 30.sp, fontFamily: 'korean') ),
                                SizedBox(
                                  width: 160.w,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.fitWidth,
                                    child: Text("${user_data['user_name']} 님",style: TextStyle(fontSize: 30.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
                                  ),
                                ),

                                //Text("${user_data['user_name']} 님",style: TextStyle(fontSize: 30.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
                                SizedBox(height: 60.h,),
                                Text("현재 등급",style: TextStyle(color: Colors. grey, fontSize: 20.sp, fontFamily: 'korean') ),
                                SizedBox(height: 5.h,),
                                Container(
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/image/medal.svg' , fit: BoxFit.fill, ),
                                      Text("Lv${user_data['user_lv']}",style: TextStyle(color: AppColor.happyblue, fontSize: 20.sp, fontFamily: 'korean') ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ),
                      ],
                    ), //왼쪽에 글자랑 등급들
                    Container(
                      child: Column(
                        children: [
                          SizedBox(height: 40.h,),
                          Image.asset('assets/image/character.png' , fit: BoxFit.fill,height: 240.h),
                          //SvgPicture.asset('assets/image/character.svg' , fit: BoxFit.fill,height: 240.h),
                        ],
                      ),
                    ),//오른쪽 asset
                  ],
                ),
              ),//위쪽 제일 큰 박스

              HomePageUserInfoBar(leftContent: "나의 리워드", rightContent: "${user_data['reward']} ${rewardName}",icon: Icons.control_point_duplicate,),
              SizedBox(height: 10.h,),
              HomePageUserInfoBar(leftContent: "이번주 랭킹", rightContent: "${user_data['Ranking'] ?? "-"} 등", icon: Icons.people),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: EdgeInsets.fromLTRB(35.w, 40.h, 30.w, 0),
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

                    SizedBox(height: 10.h,),

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
                          int _index = int.parse(do_mission[index]['mission_id'])-1;
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
                                totalUser: int.parse(all_missions[_index]['total_user']),
                                rank: 1,
                                reward: double.parse(do_mission[index]['get_reward']),
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
                      padding: EdgeInsets.only(left:35.w, top: 45.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50.h,),
                          Text("금주의 추천 미션",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                        ],
                      ),
                    ),

                    Container(
                      width: 360.w,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                        (missions_cnt % 2 == 0 ? missions_cnt / 2 : missions_cnt ~/ 2 + 1).toInt(),
                        itemBuilder: (_, index) {
                          extraindex += 2;
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SpecificMissionToPage(i: extraindex),
                                  if (extraindex + 1 < missions_cnt)
                                    SpecificMissionToPage(i: extraindex+1),
                                ],
                              ),
                              SizedBox(height: 15.h,),
                            ],
                          );
                        },
                      ),
                    ),




                    SizedBox(height: 30.h,),


                  ],
                ),

              ), //금주의 추천 미션



            ],
          ),
        ),
      ),


    );


  }
}

