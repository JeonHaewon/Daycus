import 'package:daycus/screen/temHomePage.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/widget/nowingmission.dart';
import 'package:daycus/screen/NoticePage.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/widget/NowNoMission.dart';
import 'package:daycus/screen/specificMissionPage/MissionCheckStatusPage.dart';




class MissionCheckPage extends StatelessWidget {
  const MissionCheckPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    int? do_mission_cnt = do_mission==null ? 0 : do_mission.length;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('미션인증',
            style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: null),
          IconButton(icon: Icon(Icons.notifications), color: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NoticePage()),
                );
              }),

        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 30.h, 0, 0),
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
                        NowMissionButton(image: all_missions[_index]['thumbnail']==''
                            ? 'missionbackground.png' : all_missions[_index]['thumbnail'],
                          title: all_missions[_index]['title'],
                          totalUser: int.parse(all_missions[_index]['total_user']),
                          rank: 1,
                          reward: int.parse(do_mission[index]['get_reward']),
                          onTap: MissionCheckStatusPage(
                            mission_index: _index,
                            mission_data: all_missions[_index],
                            do_mission_data: do_mission[index],
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

        );
  }
}