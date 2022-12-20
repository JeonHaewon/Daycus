import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/screen/specificMissionPage/MissionCheckStatusPage.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:daycus/widget/NowNoMission.dart';
import 'package:daycus/widget/SpecificMissionToPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';
import 'package:daycus/widget/nowingmission.dart';
import 'package:daycus/screen/NoticePage.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    int extraindex = -2;
    int? do_mission_cnt = do_mission==null ? 0 : do_mission.length;

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

      body: SingleChildScrollView(
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
                              SizedBox(height: 10.h,),
                              Container(
                                child: Row(
                                  children: [
                                    Image.asset('assets/image/Medal.png' , fit: BoxFit.fill),
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
                        Image.asset('assets/image/character.png' , fit: BoxFit.fill,height: 240.h)
                      ],
                    ),
                  ),//오른쪽 asset
                ],
              ),
            ),//위쪽 제일 큰 박스

            Container(
              width: 360.w,
              height: 55.h,
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(horizontal: 30.w),
              child: Row(
                children: [
                  SizedBox(width: 20.w,),

                  Container(
                    width: 85.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 7.h,),
                        Text("나의 리워드",style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'korean') ),
                      ],
                    ),
                  ),
                  // 하임 : 주간 > 전체로 변경
                  SizedBox(width: 30.w,),
                  Text("${user_data['reward']}원",style: TextStyle(color: AppColor.happyblue, fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold),  ),
                ],
              ),
            ), //주간랭킹

            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: EdgeInsets.fromLTRB(35.w, 40.h, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h,),
                        Text("진행 중인 미션",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h,),

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
                            NowMissionButton(image: 'nowmission',
                              title: all_missions[_index]['title'],
                              totalUser: int.parse(all_missions[_index]['total_user']),
                              rank: 1,
                              reward: int.parse(do_mission[index]['get_reward']),
                              onTap: MissionCheckStatusPage(
                                mission_index: _index,
                                do_mission_data: do_mission[index],
                                mission_data: all_missions[_index],
                              ),),

                            SizedBox(height: 7.h,),
                          ],
                        );
                      },
                    ),
                  )



                ],
              ),

            ), //진행중인 미션




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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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


    );


  }
}