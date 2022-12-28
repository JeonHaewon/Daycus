import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/widget/BigMissionButtonToPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';
import 'package:daycus/backend/UserDatabase.dart';


class CategoryMission extends StatelessWidget {
  CategoryMission({
    Key? key,
    required this.page_category,
  }) : super(key: key);

  final List<dynamic> page_category;

  @override
  Widget build(BuildContext context) {

    int extraindex = -2;
    int _build_cnt = page_category.length;

    Size m = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.background,
      body:SingleChildScrollView(
        // height를 폰 크기 정도로 해줘야 작동함. 아니면 스크롤 자체가 안되기 때문에 작동 안함.
        physics: BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: m.height,

                  width: 370.w,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                    (_build_cnt % 2 == 0 ? _build_cnt / 2 : _build_cnt ~/ 2 + 1).toInt(),
                    itemBuilder: (_, index) {
                      extraindex += 2;
                      return Column(
                        children: [

                          SizedBox(height: 20.h,),

                          Row(

                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // spaceAround > spaceBetween으로 변경 : 맨마지막 가운데정렬 방지
                              // 데이터를 all로 넘기고, 인덱스를 all의 do_mission 인덱스로만 넘겨야할듯?
                              BigMissionButtonToPage(i: extraindex, data: page_category),
                              if (extraindex + 1 < _build_cnt)
                                BigMissionButtonToPage(i: extraindex+1, data: page_category,),
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
