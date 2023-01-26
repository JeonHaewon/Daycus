import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/screen/MissionCheckPageCustom.dart';
import 'package:daycus/widget/popWidget/bottomPopWidget.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/myPage/privatesettings/PrivateSettings.dart';
import 'package:daycus/screen/myPage/settings/Settings.dart';
import 'package:daycus/screen/myPage/feed/MissionFeed.dart';
import 'package:daycus/screen/NoticePage.dart';
import 'package:daycus/screen/myPage/ask/ToDeveloper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:daycus/core/app_bottom.dart';
import 'package:daycus/core/app_controller.dart';
import 'package:get/get.dart';


final OfficeFurnitureController controller =  Get.put(OfficeFurnitureController());





CountCategory() {
  int cnt = do_mission==null ? 0 : do_mission.length;
  List<double> cntList = [0,0,0,0,0];
  for (int i = 0; i<cnt; i++){
    int _index = do_mission[i]['mission_index'];
    if (all_missions[_index]['category'] == "건강") { cntList[0] += 1; }
    else if (all_missions[_index]['category'] == "공부") { cntList[1] += 1; }
    else if (all_missions[_index]['category'] == "운동") { cntList[2] += 1; }
    else if (all_missions[_index]['category'] == "생활") { cntList[3] += 1; }
    else if (all_missions[_index]['category'] == "취미") { cntList[4] += 1; }
  }
  return cntList;
}

List<double> GraphWidth = CountCategory();
int do_mission_cnt = do_mission==null ? 0 : do_mission.length;


class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  static final storage = FlutterSecureStorage();

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  print_during() {
    DateTime ll = DateTime.parse(user_data['last_login']);
    DateTime rd = DateTime.parse(user_data['register_date']);
    Duration diff = ll.difference(rd);
    if (diff.inDays >= 0 && diff.inDays <= 30){
      return ("${diff.inDays} 일");
    }
    else {
      return ("${(diff.inDays ~/ 30)} 개월");
    }
  }

  // 사용자 > 개발자 gmail 이메일 보내기
  void _sendEmail(texting) async {
    final Email email = Email(
      body: texting,
      subject: '[DayCus 앱 사용 중 문제가 생겨 문의드립니다]',
      recipients: [adminEmail],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      // 하임 : 메일 안갔는데도 완료되었다고 할 때가 있어서 주석처리함.
      //Fluttertoast.showToast(msg: "메일 전송이 완료되었습니다 !");
    } catch (error) {
      String title = toDeveloperCantString+"\n\n${adminEmail}";
      String message = "";
      Fluttertoast.showToast(msg: title);
    }
  }


  bool _isInitialValue = true;

  @override
  void initState() {
    super.initState();
    int do_mission_cnt_after = do_mission==null ? 0 : do_mission.length;

    // 갯수 다시 로드
    if (do_mission_cnt != do_mission_cnt_after){
      print("미션 참여빈도 업데이트");
      GraphWidth = CountCategory();
      do_mission_cnt = do_mission_cnt_after;
    }

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _isInitialValue = !_isInitialValue;
      });
    });

  }
  

  @override
  Widget build(BuildContext context) {

    Size m = MediaQuery.of(context).size;
    int cnt1 = do_mission==null ? 0 : do_mission.length;
    double cnt2 = cnt1.toDouble();

    Future<void> refresh() async {
      await LoginAsyncMethod(MyPage.storage, context, true);
      setState(() { });
    };

    int do_mission_cnt = do_mission==null ? 0 : do_mission.length;

    Widget toDeveloperBottomSheet = bottomPopWidget(
        context,
        // 메일 문의
            () async {
          _sendEmail(" ");
          Navigator.pop(context);
        },

        // 일반 문의
            () async {
          // 문의 선택 창만 닫기
              Navigator.pop(context);
              
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ToDeveloper()),
              );
        },
        '메일 문의', '일반 문의',
        Icons.email, Icons.info_rounded);

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('마이페이지',
            style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold)),
        actions: [
          //IconButton(icon: Icon(Icons.search), color: Colors.grey, onPressed: (){}),

          //알림 확인
          // IconButton(icon: Icon(Icons.notifications), color: Colors.grey,
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => NoticePage()),
          //       );
          //     }),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrivateSettings()),
              );
            },

            child: Container(
                padding: EdgeInsets.all(14.sp),
                child: (profileImage==null)
                // 고른 프로필 사진이 없을 때
                    ? (user_data['profile']==null || downloadProfileImage==null)
                    ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png"), radius: 13.sp,)
                    : Transform.rotate(angle: profileDegree* pi/180, child: CircleAvatar( backgroundImage: downloadProfileImage!.image, radius: 13.sp), )
                    : CircleAvatar( backgroundImage : FileImage(profileImage!), radius: 13.sp,)
            ),
          ),


        ],
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          RefreshIndicator(
            onRefresh: refresh,
            color: AppColor.happyblue,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: m.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 0),
                      child: Column(
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  SizedBox(
                                    width: 210.w,
                                    height: 38.h,
                                    child: FittedBox(
                                      alignment: Alignment.centerLeft,
                                      fit: BoxFit.contain,

                                      child: Text("${user_data['user_name']} 님",style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                    ),
                                  ),

                                  // Container(
                                  //   child: Row(
                                  //     children: [
                                  //       Text("${user_data['user_name']} 님",style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                  //     ],
                                  //   ),
                                  // ),


                                  Container(
                                    child: Row(
                                      children: [
                                        Text("현재등급 ",style: TextStyle(fontSize: 24.sp, fontFamily: 'korean') ),
                                        Text("Lv${user_data['user_lv']}",style: TextStyle(color: AppColor.happyblue, fontSize: 24.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                        Text("입니다",style: TextStyle(fontSize: 24.sp, fontFamily: 'korean') ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [

                                  Container(
                                    width: 90.w,
                                    height: 55.h,
                                    decoration: BoxDecoration(
                                      color: Colors.indigo[100],
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        SizedBox(width: 6.w,),
                                        Icon(Icons.calendar_month, color: AppColor.happyblue,size: 25.w,),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Text("갓생", style: TextStyle(fontSize: 10, fontFamily: 'korean', color: AppColor.happyblue,),),

                                            Container(
                                              alignment: Alignment.center,
                                              width: 42.w,
                                              height: 16.h,
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text("${user_data['attendance']}일차", style: TextStyle(fontSize: 11, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue,),),
                                              ),
                                            ),

                                            //Text("${user_data['attendance']}일차", style: TextStyle(fontSize: 11, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue,),),
                                          ],
                                        ),

                                        SizedBox(width: 10.w,),
                                      ],
                                    ),

                                  ),


                                  SizedBox(width: 15.w,)
                                ],
                              ),

                            ],
                          ),


                          SizedBox(height: 15.h,),


                          //주간랭킹

                          SizedBox(height: 15.h,),

                          // 미션 달성률 - 다음에 만나요 ^^
                          // Container(
                          //   width: 365.w,
                          //   height:280.h,
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   margin: EdgeInsets.symmetric(horizontal: 2.w),
                          //   child: Column(
                          //     children: [
                          //       SizedBox(height: 20.h,),
                          //
                          //       Container(
                          //         child: Row(
                          //           children: [
                          //             SizedBox(width: 20.w,),
                          //             Text("미션 달성률",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                          //           ],
                          //         ),
                          //       ),
                          //
                          //       SizedBox(height: 10.h,),
                          //       Image.asset('assets/image/graph.png' , height: 200.h)
                          //
                          //     ],
                          //   ),
                          // ), //주간랭킹

                          //SizedBox(height: 15.h,),

                          if (do_mission_cnt>0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (cnt1>0)
                                InkWell(
                                  onTap: () {
                                    controller.currentBottomNavItemIndex.value = AppScreen.missionCertify;
                                  },
                                child : Container(
                                  width: 170.w,
                                  //height:200.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                                  padding: EdgeInsets.only(left: 20.w, right: 5.w),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10.h,),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            SizedBox(
                                              width: 110.w,
                                              height: 40.h,
                                              child: FittedBox(
                                                alignment: Alignment.centerLeft,
                                                fit: BoxFit.contain,
                                                child: Text("현재 미션 현황",
                                                    style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold)  ),
                                              ),
                                            ),

                                            //Text("현재 미션 참여현황",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                                            // 회원가입 날짜로부터
                                            //Text("최근 ${print_during()}",style: TextStyle(color: Colors.grey,fontSize: 13.sp, fontFamily: 'korean') ),

                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 12.h,),

                                      ParticipateBar( title: "건강", cnt: cnt2, graphWidth: GraphWidth[0], initialValue: _isInitialValue,),

                                      SizedBox(height: 8.h,),

                                      ParticipateBar( title: "공부", cnt: cnt2, graphWidth: GraphWidth[1], initialValue: _isInitialValue,),

                                      SizedBox(height: 8.h,),

                                      ParticipateBar( title: "운동", cnt: cnt2, graphWidth: GraphWidth[2], initialValue: _isInitialValue,),

                                      SizedBox(height: 8.h,),

                                      ParticipateBar( title: "생활", cnt: cnt2, graphWidth: GraphWidth[3], initialValue: _isInitialValue,),

                                      SizedBox(height: 8.h,),

                                      ParticipateBar( title: "취미", cnt: cnt2, graphWidth: GraphWidth[4], initialValue: _isInitialValue,),

                                      SizedBox(height: 20.h,),

                                    ],
                                  ),
                                )), // 현재 참여

                              Container(
                                width: 170.w,
                                height:195.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 2.w),
                                padding: EdgeInsets.only(left: 20.w, right: 5.w),
                                child: Column(
                                  children: [
                                    SizedBox(height: 10.h,),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          SizedBox(
                                            width: 110.w,
                                            height: 40.h,
                                            child: FittedBox(
                                              alignment: Alignment.centerLeft,
                                              fit: BoxFit.contain,
                                              child: Text("누적 미션 현황",
                                                  style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold)  ),
                                            ),
                                          ),

                                          //Text("현재 미션 참여현황",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                                          // 회원가입 날짜로부터
                                          //Text("최근 ${print_during()}",style: TextStyle(color: Colors.grey,fontSize: 13.sp, fontFamily: 'korean') ),

                                        ],
                                      ),
                                    ),

                                    // 준비중
                                    Container(
                                      margin: EdgeInsets.only(top: 43.h, right: 15.w),
                                      width: 90.w,
                                      height: 35.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,//Colors.grey[300],
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          SizedBox(width: 6.w,),
                                          Icon(Icons.bar_chart, color: Colors.grey[700],size: 25.w,),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [



                                              //Text("갓생", style: TextStyle(fontSize: 10, fontFamily: 'korean', color: AppColor.happyblue,),),

                                              Container(
                                                alignment: Alignment.center,
                                                width: 42.w,
                                                height: 16.h,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text("준비중", style: TextStyle(fontSize: 11, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.grey[700],),),
                                                ),
                                              ),

                                              //Text("${user_data['attendance']}일차", style: TextStyle(fontSize: 11, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue,),),
                                            ],
                                          ),

                                          SizedBox(width: 10.w,),
                                        ],
                                      ),

                                    ),



                                    // SizedBox(height: 12.h,),
                                    //
                                    // ParticipateBar( title: "건강", cnt: cnt2, graphWidth: GraphWidth[0], initialValue: _isInitialValue,),
                                    //
                                    // SizedBox(height: 8.h,),
                                    //
                                    // ParticipateBar( title: "공부", cnt: cnt2, graphWidth: GraphWidth[1], initialValue: _isInitialValue,),
                                    //
                                    // SizedBox(height: 8.h,),
                                    //
                                    // ParticipateBar( title: "운동", cnt: cnt2, graphWidth: GraphWidth[2], initialValue: _isInitialValue,),
                                    //
                                    // SizedBox(height: 8.h,),
                                    //
                                    // ParticipateBar( title: "생활", cnt: cnt2, graphWidth: GraphWidth[3], initialValue: _isInitialValue,),
                                    //
                                    // SizedBox(height: 8.h,),
                                    //
                                    // ParticipateBar( title: "취미", cnt: cnt2, graphWidth: GraphWidth[4], initialValue: _isInitialValue,),
                                    //
                                    // SizedBox(height: 20.h,),

                                  ],
                                ),
                              ), // 현재 참여


                            ],
                          ),


                          SizedBox(height: 15.h,),

                          MyPageInformation(title: "${rewardName}",
                              content: "${double.parse(user_data['reward']).toStringAsFixed(1)} ${rewardName}"),

                          SizedBox(height: 15.h,),

                          MyPageInformation(title: "주간 랭킹",
                              content: "${user_data['Ranking'] ?? "-" } 등"),

                          SizedBox(height: 15.h,),



                          // 미션 피드
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              minimumSize: Size(365.w, 50.h),
                              textStyle: TextStyle(fontSize: 18.sp),
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => MissionFeed()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(" 미션피드",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, fontSize: 16.sp) ),
                                Image.asset('assets/image/arrow-right1.png' )
                              ],
                            ),
                          ),

                          SizedBox(height: 15.h,),



                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              minimumSize: Size(365.w, 50.h),
                              textStyle: TextStyle(fontSize: 18.sp),
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => PrivateSettings()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(" 개인정보 설정",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, fontSize: 16.sp) ),
                                Image.asset('assets/image/arrow-right1.png' )
                              ],
                            ),
                          ),

                          SizedBox(height: 15.h,),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              primary: Colors.white,
                              onPrimary: Colors.black,
                              minimumSize: Size(365.w, 50.h),
                              textStyle: TextStyle(fontSize: 18.sp),
                            ),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => Settings()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(" 설정",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, fontSize: 16.sp) ),
                                Image.asset('assets/image/arrow-right1.png' )
                              ],
                            ),
                          ),

                          SizedBox(height: 25.h,),

                          Container(
                            width: 400.w,
                            //height: 160.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Container(
                                  padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Container(
                                        width: 380.w,
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(context: context, builder: ((builder) => toDeveloperBottomSheet));
                                          },
                                          child: Container(
                                            width: 250.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                            ),
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [

                                                  Text("개발자에게 문의하기",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, fontSize: 16.sp)),
                                                  SizedBox(width: 8.w,),
                                                  Icon(Icons.chat, color: Colors.grey[850],size: 25.w,),

                                                ],
                                              ),
                                            ),

                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 4.h,),

                                      Container(
                                        width: 370.w,

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Text("문의 종류",
                                            //     style: TextStyle(fontWeight: FontWeight.bold)),
                                            SizedBox(height: 5.h,),

                                            Text(" • 메일 문의 : 답변을 받아야 하는 문의를 보내주세요",
                                                style: TextStyle(fontSize: 10.sp)),
                                            Text(" • 일반 문의 : 답변을 받지 않아도 되는 문의를 보내주세요(오류 신고 등)",
                                                style: TextStyle(fontSize: 10.sp)),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 8.h,),

                                      Container(
                                        width: 380.w,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            Text("개발자 이메일 : ${adminEmail}",
                                              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 13.h,),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.h,),


                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),

          //Advertisement()
        ],

      ),

    );
  }
}

class MyPageInformation extends StatelessWidget {
  const MyPageInformation({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365.w,
      height: 55.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: Row(
        children: [

          SizedBox(width: 20.w,),

          Container(
            width: 90.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: AppColor.grey1,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,style: TextStyle(color: Colors.blue, fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
              ],
            ),
          ),


          SizedBox(width: 30.w,),
          // 가운데 정렬?
          Text(content,style: TextStyle(color: AppColor.happyblue, fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold),  ),
        ],
      ),
    );
  }
}


class MyPageButton extends StatelessWidget {
  const MyPageButton({
    Key? key,
    this.title,
  }) : super(key: key);

  final title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        primary: Colors.white,
        onPrimary: Colors.black,
        minimumSize: Size(365.w, 50.h),
        textStyle: TextStyle(fontSize: 18.sp),
      ),

      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MissionFeed()),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(" 미션피드",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
          Image.asset('assets/image/arrow-right1.png' )
        ],
      ),
    );
  }
}



class ParticipateBar extends StatelessWidget {
  const ParticipateBar({
    Key? key,
    required this.title,
    required this.cnt,
    required this.graphWidth,
    this.initialValue : true,
  }) : super(key: key);

  final String title;
  final double cnt;
  final double graphWidth;
  final bool initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270.w,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 30.w,
            child: Text(title,style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 10.w,),

          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width:  initialValue ? 0 : (72.w)*(graphWidth/cnt),
            height: 10.h,
            decoration: BoxDecoration(
                color: AppColor.happyblue,
                borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(10)
                )
            ),
          ),

          // Container(
          //   width: (225.w)*(graphWidth/cnt),
          //   height: 10.h,
          //   decoration: BoxDecoration(
          //       color: AppColor.happyblue,
          //       borderRadius: BorderRadius.horizontal(
          //           right: Radius.circular(10)
          //       )
          //   ),
          // ),

          SizedBox(width: 5.w,),

          // 갯수, 0이면 포함 안함.
          if (graphWidth.toStringAsFixed(0)!="0")
            Text("${graphWidth.toStringAsFixed(0)}", style: TextStyle(fontSize: 12.sp, ),),

        ],
      ),
    );
  }
}

