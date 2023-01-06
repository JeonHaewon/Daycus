import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:daycus/core/app_text.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/myPage/privatesettings/PrivateSettings.dart';
import 'package:daycus/screen/myPage/settings/Settings.dart';
import 'package:daycus/screen/myPage/feed/MissionFeed.dart';
import 'package:daycus/screen/NoticePage.dart';
import 'package:daycus/screen/myPage/ask/ToDeveloper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';



class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  static final storage = FlutterSecureStorage();

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {

    Size m = MediaQuery.of(context).size;

    Future<void> refresh() async {
      await LoginAsyncMethod(MyPage.storage, null, true);
      setState(() { });
    };

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('마이페이지',
            style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.search), color: Colors.grey,
              onPressed: (){}),
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
      body: RefreshIndicator(
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

                              Container(
                                child: Row(
                                  children: [
                                    Text("${user_data['user_name']} 님",style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                  ],
                                ),
                              ),
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
                                        Text("4일차", style: TextStyle(fontSize: 11, fontFamily: 'korean', fontWeight: FontWeight.bold, color: AppColor.happyblue,),),
                                      ],
                                    ),

                                    SizedBox(width: 10.w,),
                                  ],
                                ),

                              ),


                              SizedBox(width: 15.w,)
                            ],
                          ),


                          // Stack(
                          //   alignment: Alignment.topLeft,
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsets.fromLTRB(15.w, 15.h, 0, 0),
                          //       child: Container(
                          //         width: 100.w,
                          //         height: 60.h,
                          //         decoration: BoxDecoration(
                          //           color: Colors.yellow[100],
                          //         ),
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.center,
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             Text("갓생", style: TextStyle(fontSize: 14, fontFamily: 'koreantwo'),),
                          //             Text("4일차", style: TextStyle(fontSize: 18, fontFamily: 'koreantwo', fontWeight: FontWeight.bold),),
                          //
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     Transform.rotate(
                          //       angle: 320 * pi / 180,
                          //       child: IconButton(
                          //         icon: Icon(Icons.push_pin, color: Colors.red[900],),
                          //         onPressed: null,
                          //       ),
                          //     ),
                          //     //Icon(Icons.push_pin, color: Colors.red[900],),
                          //   ],
                          // ),



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


                      // 미션 참여 빈도 - 다음에 만나요
                      // Container(
                      //   width: 365.w,
                      //   height:260.h,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(15),
                      //   ),
                      //   margin: EdgeInsets.symmetric(horizontal: 2.w),
                      //   child: Column(
                      //     children: [
                      //       SizedBox(height: 20.h,),
                      //       Container(
                      //         child: Row(
                      //           children: [
                      //             SizedBox(width: 20.w,),
                      //             Text("미션 참여빈도",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      //             SizedBox(width: 120.w,),
                      //             Text("최근 3개월",style: TextStyle(color: Colors.grey,fontSize: 15.sp, fontFamily: 'korean') ),
                      //
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(height: 10.h,),
                      //
                      //       Image.asset('assets/image/graph2.png' , height: 180.h),
                      //
                      //     ],
                      //   ),
                      // ), //주간랭킹

                      MyPageInformation(title: "${rewardName}",
                          content: "${user_data['reward']} ${rewardName}"),

                      SizedBox(height: 15.h,),

                      MyPageInformation(title: "주간 랭킹",
                          content: "${user_data['Ranking'] ?? "-" } 등"),

                      //SizedBox(height: 55.h,),

                      // 미션 피드 - 다음에 만나요 ㅎㅎ

                      // ElevatedButton(
                      //   style: ElevatedButton.styleFrom(
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10)
                      //     ),
                      //     primary: Colors.white,
                      //     onPrimary: Colors.black,
                      //     minimumSize: Size(365.w, 50.h),
                      //     textStyle: TextStyle(fontSize: 18.sp),
                      //   ),
                      //
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (_) => MissionFeed()),
                      //     );
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(" 미션피드",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      //       Image.asset('assets/image/arrow-right1.png' )
                      //     ],
                      //   ),
                      // ),

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
                            Text(" 개인정보 설정",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
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
                            Text(" 설정",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                            Image.asset('assets/image/arrow-right1.png' )
                          ],
                        ),
                      ),

                      SizedBox(height: 25.h,),


                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ToDeveloper()),
                          );
                        },

                        child: Container(
                          width: 250.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                          ),
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("개발자에게 문의하기",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                SizedBox(width: 10.w,),
                                Icon(Icons.chat, color: Colors.grey[850])
                              ],
                            ),
                          ),

                        ),
                      ),


                    ],
                  ),
                ),







              ],
            ),
          ),
        ),
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
