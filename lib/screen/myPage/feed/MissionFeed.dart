import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/widget/feedpage/feedButton.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/widget/missionfeedbutton.dart';



class MissionFeed extends StatefulWidget {
  const MissionFeed({Key? key}) : super(key: key);

  @override
  State<MissionFeed> createState() => _MissionFeedState();
}

class _MissionFeedState extends State<MissionFeed> {
  @override

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      importPastMission();
    });

  }

  // 28이 지난 미션을 불러옴
  // - 잠깐 에러가 깜빡일 수 있다. 그것은 불러오기 전에 UI를 그리기 때문
  importPastMission() async {
    past_missions = await select_request(
        "SELECT mission_id, title, start_date, end_date, thumbnail FROM DayCus.past_missions",
        null, false);
    setState(() { });
    //print("past_missions : $past_missions");
  }

  Widget build(BuildContext context) {

    int doneMissionCnt = done_mission==null ? 0 : done_mission.length;
    String temMonth = "";
    String month = "0000-00";

    return ScreenUtilInit(
      designSize: Size(412, 892),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColor.background,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.white,
            title: Text('미션피드',
                style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [

                Padding(
                  padding: EdgeInsets.only(left: 10.w,
                      // bottom: 10.h,
                      top: 40.h),
                  child: Container(
                    // padding: EdgeInsets.only(left: 30.w, ),
                      width: 250.w,
                      height: 20.h,
                      // decoration: BoxDecoration(
                      //   color: Colors.grey[100],
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("※ 미션 종료 후 48일이 경과되지 않은 미션은 뜨지 않습니다",
                            style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',  color: Colors.red) ),)), ),

                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: doneMissionCnt,
                //   itemBuilder: (_, index) {
                //     index ++;
                //     return Container(
                //
                //       color: Colors.white,
                //       padding: EdgeInsets.fromLTRB(20.w, 20.h, 10.w, 0),
                //       child: Column(
                //         children: [
                //           Text("1"),
                //         ],
                //       ),
                //     );
                //   },
                // ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 10.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 370.w,
                        // height:310.h,
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Padding(
                              padding: EdgeInsets.fromLTRB(5.w, 18.h, 5.w, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Text("2022. 10",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                  // SizedBox(height: 12.h,),

                                  // Container(
                                  //
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     children:[
                                  //       MissionFeedButton(title :"일찍 일어나기", duration:"10.01 ~ 10.10",image: "feedimage" ,percent: 90, reward: 1200,),
                                  //       MissionFeedButton(title :"일찍 일어나기", duration:"10.01 ~ 10.10",image: "feedimage" ,percent: 90, reward: 1200, ),
                                  //     ],
                                  //   ),
                                  // ),
                                  if (doneMissionCnt==0)
                                    Column(
                                      children: [
                                        Text("완료한 미션이 없습니다"),
                                        SizedBox(height: 20.h,),
                                      ],
                                    ),



                                  // 몇개의 미션을 안그려주는 것 같음
                                  if (doneMissionCnt>0)
                                  Container(
                                    width: 400.w,
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      children: List.generate(doneMissionCnt, (index) {

                                        if (month!=temMonth ){
                                          temMonth = month;
                                        }

                                        // indexWhere에서 오류가 생겨서 null인 경우 무조건 index -1을 반환.
                                        int _index = past_missions!=null
                                            ? past_missions.indexWhere((all_data) => all_data['mission_id'] == done_mission[index]['mission_id'])
                                            : -1;
                                        month = done_mission[index]['mission_start'].substring(0,7);

                                        //int mission_index = int.parse(source)
                                        return (month != temMonth) ?
                                          Padding(
                                            padding: EdgeInsets.only(left: 10.w, bottom: 10.h, top: 20.h),
                                            child: Container(
                                              padding: EdgeInsets.only(left: 20.w, ),
                                                width: 340.w,
                                                height: 55.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                    child: Text("${month}",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ))), )
                                        : Column(
                                          children: [

                                            // MissionFeedButton(
                                            //   title : "${all_missions[_index]['title']}",
                                            //   duration:"${all_missions[_index]['start_date'].substring(5)} ~ ${all_missions[_index]['end_date'].substring(5)}",
                                            //   image: "${all_missions[_index]['thumbnail']}" ,
                                            //   percent: int.parse(done_mission[index]['get_reward']),
                                            //   reward: 1200,),
                                            if (_index!=-1)
                                            FeedButton(
                                                title: "${past_missions[_index]['title']}",

                                                // duration 안씀
                                                duration: "${past_missions[_index]['start_date'].substring(5)} ~ ${past_missions[_index]['end_date'].substring(5)}",
                                                endTime : past_missions[_index]['end_date'].substring(5),
                                                image: "${past_missions[_index]['thumbnail']}",
                                                percent: double.parse(done_mission[index]['percent']),
                                                startTime: done_mission[index]['mission_start'].substring(5,10),
                                            ),

                                            SizedBox(height: 12.h,),
                                          ],
                                        );



                                      }
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            // past_missions와 연계하여 뜨도록 할 예정



                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h,),
              ],
            ),
          ),
        );
      },
    );
  }
}