import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';


class AlertDialogPage extends StatelessWidget {
  AlertDialogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [


          TextButton(
              onPressed: (){
                showSoundMissionAlertDialog(context, 3, 6, 8);
              },
              child: Text("음성 미션 팝업")
          ),


          TextButton(
              onPressed: (){
                showRejectedAlertDialog(context, 1);
              },
              child: Text("반려된 미션 팝업")
          ),

          TextButton(
              onPressed: (){
                InvitedFreindDialog(context, "계란초밥", "만보 걷기");
              },
              child: Text("초대받은 팝업")
          ),





        ],
      ),
    );
  }
}


void showSoundMissionAlertDialog(BuildContext context, int date, int min, int sec) async {

  String result = await showDialog(
    context: context, // user must tap button!
    builder: (BuildContext context) {
      return BackdropFilter(
        child: AlertDialog(
          // 하임 : 내가 인증한 사진 > n일째 인증 사진으로 변경
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${date}일째 미션 수행",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
              InkWell(
                onTap:(){Navigator.of(context).pop();},
                child: Icon(Icons.clear),
              )
            ],
          ),
          content: Container(
            height: 80.h,
            child: min != null
                ? Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Column(
                    children: [
                      Icon(Icons.volume_down_alt, size: 60.w, color: AppColor.happyblue,),

                      Container(
                        alignment: Alignment.center,
                        child: Text("${min}분 ${sec}초 ", style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ),
                    ],
                  ),

                  SizedBox(width: 8.w,),

                  Text("갓생에\n성공하셨군요!",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', color: AppColor.happyblue, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

                  SizedBox(width: 15.w,),
                ],
              ),
            )
                : Text("데이터를 불러올 수 없습니다", style: TextStyle(fontSize: 28.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        filter: ImageFilter.blur(
          sigmaX : 6,
          sigmaY : 6,
        ),
      );
    },
  );
}

void showRejectedAlertDialog(BuildContext context, int date) async {

  String result = await showDialog(
    context: context, // user must tap button!
    builder: (BuildContext context) {
      return BackdropFilter(
        child: AlertDialog(
          // 하임 : 내가 인증한 사진 > n일째 인증 사진으로 변경
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${date}일째 인증 사진",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
              InkWell(
                onTap:(){Navigator.of(context).pop();},
                child: Icon(Icons.clear),
              )
            ],
          ),
          content: Container(
            height: 300.h,
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 18.w,),
                    SizedBox(width: 10.w,),
                    Text("미션 인증이 반려되었습니다",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                    SizedBox(width: 10.w,),
                    Icon(Icons.warning, color: Colors.red, size: 18.w,),

                  ],
                ),

                SizedBox(height: 10.h,),

                SizedBox(
                  width: 180.w,
                  child: Text("이의 신청 시 '개발자에게 문의하기' 페이지를 이용하시기 바랍니다.",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean'), textAlign: TextAlign.center,),

                ),

                SizedBox(height: 20.h,),

                Container(
                  height: 200.h,
                  width: 180.w,
                  decoration: BoxDecoration(
                    color: Colors.black
                  ),
                  child: Text("여기 반려된 사진 넣으면?",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', color: Colors.white), textAlign: TextAlign.center,),

                )
              ],
            )
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        filter: ImageFilter.blur(
          sigmaX : 6,
          sigmaY : 6,
        ),
      );
    },
  );
}


void InvitedFreindDialog(BuildContext context, String friendName, String missionName) async {

  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      // 하임 : 내가 인증한 사진 > n일째 인증 사진으로 변경
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("미션에 초대받았어요!",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
        ],
      ),
      content: Container(
        width: 304.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 20.h, 0, 0),
                //height: 200.h,
                child: Column(
                  children: [

                    Container(
                      width: 320.w,
                      decoration: BoxDecoration(
                        color: Colors.indigo[100]
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 10.h),
                        child: Text("${friendName}님이 ${missionName} 미션에 초대하셨습니다",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean'), textAlign: TextAlign.center,),
                      ),
                    ),

                    SizedBox(height: 15.h,),

                    Image.asset('assets/image/character.png' , fit: BoxFit.contain, height: 180.h),



                  ],
                )

            ),

            Container(
              width: 412.w,
              height: 1,
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                InkWell(
                  onTap:(){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 150.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(4))
                      //borderRadius: BorderRadius.circular(4),
                    ),
                    child:  Text("홈으로 가기",
                        style: TextStyle(fontSize: 11.sp, fontFamily: 'korean',  color: Colors.grey[800]) ),
                  ),
                ),


                Container(
                  width: 1.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                ),

                InkWell(
                  onTap:(){
                    //해당 미션 참여 페이지로 연결
                    Navigator.of(context).pop();
                    },
                  child: Container(
                    width: 150.w,
                    height: 50.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(4))

                      //borderRadius: BorderRadius.circular(4),
                    ),
                    child:  Text("미션 참여하기",
                        style: TextStyle(fontSize: 11.sp, fontFamily: 'korean',  color: Colors.grey[800]) ),
                  ),
                )
              ],
            ),

          ],
        ),
      ),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10),
      // ),
    ),
  );
  
}


