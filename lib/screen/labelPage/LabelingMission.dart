import 'package:daycus/core/app_text.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';




class LabelingMission extends StatelessWidget {
  LabelingMission({
    Key? key,
    required this.title,
    required this.rule,
    this.onTap,

  }) : super(key: key);


  final String title;
  final String rule;
  final onTap;

  var f = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {

    final SizedBox _sizedBox = SizedBox(height: 5.h,);


    List<String> rule_list = rule.split("\\n");
    int rules_list_cnt = rule_list!=null ? rule_list.length : 0;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('라벨링 미션',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Padding(
              padding: EdgeInsets.fromLTRB(0, 30.h, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title ,style: TextStyle(fontSize: 24.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                ],
              ),
            ),



            Padding(
              // 하임 : 60.w > 40.w로 수정
              // 20.h > 27.h로 수정
              padding: EdgeInsets.fromLTRB(40.w, 27.h, 40.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 하임 > 해원 : 미션 정책 위에 미션 설명도 예쁘게 넣어주면 좋을듯?

                  Container(
                    width: 65.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 5.h,),
                        Text("미션 정책",style: TextStyle(color: Colors.indigoAccent, fontSize: 12.sp, fontFamily: 'korean') ),
                      ],
                    ),
                  ),

                  _sizedBox,

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: rules_list_cnt,

                    itemBuilder: (_, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // 하임 > 해원 : 이거 자동 내어쓰기 되도록 변경해야할듯.
                            // 숫자까지 잘라서 list View로 넣으면 될지도??
                              " - ${rule.split("\\n")[index]}",
                              style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', ) ),

                          // 맨 마지막 SizedBox는 빼기
                          if (index < rules_list_cnt-1)
                            SizedBox(height: 5.h,),
                        ],
                      );
                    },

                  ),

                  _sizedBox,

                  // Text("ㆍ$rule",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean',) ),

                ],
              ),
            ),




            Padding(
              padding: EdgeInsets.fromLTRB(0, 10.h, 0, 25.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 290.w,
                    height: 30.h,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height:5.h,),

                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 18.w,
                                height: 18.h,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 3.h,),

                                    Text("!",style: TextStyle(color: Colors.white, fontSize: 8.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 6.w,),

                              Text(canLabelingString,style: TextStyle( fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),

            SizedBox(height: 20.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 85.h,
                    width: 40.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/image/labelingmission/arrow_left.png' ),
                      ],
                    ),
                  ),
                ),

                Image.asset('assets/image/labelingmission/labeling_image.png' ,width: 320.w,),

                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 85.h,
                    width: 40.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/image/labelingmission/arrow_right.png' ),
                      ],
                    ),
                  ),
                ),

              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                ElevatedButton(
                  onPressed: () {},
                  child: Text('예'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[800],
                    minimumSize: Size(120.w, 35.h),
                    textStyle: TextStyle(color : Colors.indigo),
                  ),
                ),


                SizedBox(width: 20.w,),

                ElevatedButton(
                  onPressed: () {},
                  child: Text('아니오'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[300],
                    minimumSize: Size(120.w, 35.h),
                    textStyle: TextStyle(color : Colors.indigo),
                  ),
                ),


              ],
            ),





          ],
        ),
      ),

    );
  }
}