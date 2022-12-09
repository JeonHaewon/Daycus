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

    return Scaffold(


      backgroundColor: AppColor.background,
      body:SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
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
