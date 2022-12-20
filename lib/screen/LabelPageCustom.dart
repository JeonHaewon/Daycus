import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/labelPage/LabelingMission.dart';
import 'package:daycus/screen/NoticePage.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/widget/LabelButtonToPage.dart';



class LabelPage extends StatelessWidget {
  const LabelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int extraindex = -2;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('라벨링',
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
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 370.w,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                    (missions_cnt % 2 == 0 ? missions_cnt / 2 : missions_cnt ~/ 2 + 1).toInt(),
                    itemBuilder: (_, index) {
                      extraindex += 2;
                      return Column(
                        children: [

                          SizedBox(height: 20.h,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 나중에 총 사진 개수가 0이면 라벨링 페이지에서 제거, 검증이 모두 끝났으면 라벨링 페이지에서 제거하면 될듯.
                              LabelButtonToPage(i: extraindex, data: all_missions),
                              if (extraindex + 1 < missions_cnt)
                                LabelButtonToPage(i: extraindex+1, data: all_missions,),

                              //BigMissionButtonToPage(i: extraindex, data: all_missions,),
                              //if (extraindex + 1 < missions_cnt)
                                //BigMissionButtonToPage(i: extraindex+1, data: all_missions,),
                            ],
                          ),

                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h,),

              ],
            ),
          )
      ),
    );
  }
}


