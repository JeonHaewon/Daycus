import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:daycus/widget/BigMissionButtonToPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';


class AllMission extends StatefulWidget {
  AllMission({Key? key}) : super(key: key);

  @override
  State<AllMission> createState() => _AllMissionState();
}

class _AllMissionState extends State<AllMission> {
  @override
  Widget build(BuildContext context) {

    Future<void> refresh() async {
      await afterLogin();
      setState(() { });
    };

    int extraindex = -2;

    return Scaffold(
      body:RefreshIndicator(
        color: AppColor.happyblue,
        onRefresh: refresh,
        child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(left: 18.w, top: 25.h, bottom: 25.h),
              child: Wrap(
                children: List.generate(missions_cnt, (index) {
                  if (all_missions[index]['now_user_do']==null) {
                    return Container(
                      width: 190.w,
                      margin: EdgeInsets.only(bottom: 15.h, left: 5.w),
                      child: BigMissionButtonToPage(i: index, data: all_missions,),
                    );
                  }
                  else {
                    return Container(width: 0.w,);
                  }
                }
                ),
              ),

              // Column(
              //   children: <Widget>[
              //     Container(
              //       width: 370.w,
              //       child: ListView.builder(
              //         shrinkWrap: true,
              //         physics: NeverScrollableScrollPhysics(),
              //         itemCount:
              //         (missions_cnt % 2 == 0 ? missions_cnt / 2 : missions_cnt ~/ 2 + 1).toInt(),
              //         itemBuilder: (_, index) {
              //           extraindex += 2;
              //           return Column(
              //             children: [
              //
              //               SizedBox(height: 20.h,),
              //
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   BigMissionButtonToPage(i: extraindex, data: all_missions,),
              //                   if (extraindex + 1 < missions_cnt)
              //                     BigMissionButtonToPage(i: extraindex+1, data: all_missions,),
              //                 ],
              //               ),
              //
              //             ],
              //           );
              //         },
              //       ),
              //     ),
              //     SizedBox(height: 20.h,),
              //
              //   ],
              // ),
            )
        ),
      ),
    );
  }
}