import 'package:daycus/backend/login/login.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/NoticePage.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/widget/LabelButtonToPage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';
import 'package:daycus/screen/myPage/privatesettings/PrivateSettings.dart';
import 'package:daycus/screen/Friend/FriendPage.dart';



class LabelPage extends StatefulWidget {
  const LabelPage({Key? key}) : super(key: key);

  static final storage = FlutterSecureStorage();

  @override
  State<LabelPage> createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {


  @override
  Widget build(BuildContext context) {

    Future<void> refresh() async {
      await afterLogin();
      setState(() { });
    };

    int extraindex = -2;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox(
          //width: 170.w,
          height: 30.h,
          child: FittedBox(
            alignment: Alignment.topLeft,
            fit: BoxFit.contain,

            child:Text(' 라벨링',
                style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold)),

          ),
        ),

        actions: [

          IconButton(icon: Icon(Icons.person_add_alt_1_rounded),color: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FriendPage()),
                );
              }
          ),
          //IconButton(icon: Icon(Icons.search), onPressed: null),

          //알림 확인
          // IconButton(icon: Icon(Icons.notifications), color: Colors.grey,
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => NoticePage()),
          //       );
          //     }),

          Padding(
            padding: const EdgeInsets.all(9.0),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PrivateSettings()),
                  );
                },

                child: (profileImage==null)
                // 고른 프로필 사진이 없을 때
                    ? (user_data['profile']==null || downloadProfileImage==null)
                    ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png",), radius: 13.sp,)
                    : Transform.rotate(angle: profileDegree* pi/180, child: CircleAvatar( backgroundColor : Colors.grey[200],  backgroundImage: downloadProfileImage!.image, radius: 13.sp), )
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


                                // 라벨링 ㅠㅠㅠㅠㅠㅠ 바꿔야돼 ㅠㅠㅠㅠㅠㅠ 라벨링 필요없는건 ㅠㅠㅠㅠㅠ
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
                      SizedBox(height: 60.h,),

                    ],
                  ),
                )
            ),
          ),

          //Advertisement()

        ],

      ),


    );
  }
}


