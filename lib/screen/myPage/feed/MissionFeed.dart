import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/widget/missionfeedbutton.dart';



class MissionFeed extends StatelessWidget {
  const MissionFeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int doneMissionCnt = done_mission==null ? 0 : done_mission.length;

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
                  padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 350.w,
                        // height:310.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Padding(
                              padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("2022. 10",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                  SizedBox(height: 12.h,),

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

                                  Wrap(
                                    children: List.generate(doneMissionCnt, (index) {

                                      //int mission_id = int.parse(done_mission[index]['mission_id']);
                                      int _index = all_missions.indexWhere((all_data) => all_data['mission_id'] == done_mission[index]['mission_id']);

                                      //int mission_index = int.parse(source)
                                      return Column(
                                        children: [
                                          MissionFeedButton(
                                            title : "${all_missions[_index]['title']}",
                                            duration:"${all_missions[_index]['start_date'].substring(5)} ~ ${all_missions[_index]['end_date'].substring(5)}",
                                            image: "feedimage" ,
                                            percent: int.parse(done_mission[index]['get_reward']),
                                            reward: 1200,),
                                          SizedBox(height: 12.h,),
                                        ],
                                      );
                                    }
                                    ),
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

                SizedBox(height: 20.h,),
              ],
            ),
          ),
        );
      },
    );
  }
}