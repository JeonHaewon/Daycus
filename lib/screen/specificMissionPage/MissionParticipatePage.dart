
import 'package:daycus/backend/ImportData/doMissionImport.dart';
import 'package:daycus/backend/ImportData/importMissions.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:daycus/backend/missionParticipate/missionParticipate.dart';
import 'package:daycus/backend/missionParticipate/missionUserUpdate.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/core/constant.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:daycus/widget/PopPage.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../backend/ImportData/userDataImport.dart';


class MissionParticipatePage extends StatefulWidget {
  MissionParticipatePage({
    Key? key,
    required this.mission_id,
    required this.topimage,
    required this.title,
    required this.remainDate,
    required this.duration,
    required this.totaluser,
    required this.avgreward,

    this.onTap,

  }) : super(key: key);

  final String mission_id;
  final String topimage;
  final String title;
  final String duration;
  final int totaluser;
  final int avgreward;
  final int remainDate;

  final onTap;

  @override
  State<MissionParticipatePage> createState() => _MissionParticipatePageState();
}

class _MissionParticipatePageState extends State<MissionParticipatePage> {
  final TextEditingController rewardCtrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var f = NumberFormat('###,###,###,###');

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {

    // 참여할 때 로딩 되도록 하기
    participateMission() async {
      // 꼭 await해야하는거랑 안해야하는거 구분해서 수정하기
      // 참여자수 늘리는건 굳이 안해도 되므로, 로딩기능이 추가되면 await에서 빼기 !

      // 참여 미션 등록하기
      bool success2 = false;
      bool success1 = await missionParticipate(widget.mission_id, user_data['user_email'], rewardCtrl.text.trim()=='' ? '0' : rewardCtrl.text.trim());
      //print("gggg");
      if (success1) {
        success2 = await minus_reward(
            rewardCtrl.text.trim() == ''
                ? '0'
                : rewardCtrl.text);
      }
      // 참여 유저 업데이트
      // 이건 잘 됨.
      // await missionUserUpdate(mission_id);

      // 이것도 어플 상에서 UI 업데이트 구현하고, 네트워크는 백그라운드상에서 구현
      // 로딩 시 네트워크로 구현해도 될듯.

      // 백그라운
      // 이후에 변경된 미션만 다시 불러오는 것도 좋을듯.
      // missionImport();
      // importMissionByCategory();
      // userDataImport();
      // doMissionSave();
      if (success1 && success2)
      {
        // 진행중인 미션 목록 불러오기
        await doMissionImport();

        await userLogin(user_data['user_email'],
            user_data['password'], true);
        await afterLogin();

        // 평균 리워드 업로드
        update_request(
            "with count_table as (select mission_id as mission_id, avg(bet_reward) as average from do_mission group by mission_id) UPDATE count_table A INNER JOIN missions B ON A.mission_id = B.mission_id SET B.average = A.average;",
            null);

        update_request("call update_ranking();", null);
        // 레벨 업데이트
        update_request(
            "call update_level5('${user_data['user_email']}');",
            null);

        // 돌아가면 홈으로 이동.
        controller.currentBottomNavItemIndex.value = 0;

        // 페이지 다 닫고 이동
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => TemHomePage()),
                (route) => false);
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Padding(
                padding: EdgeInsets.fromLTRB(30.w, 25.h, 30.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      width: 400.w,
                      // 335 > 400으로 변경 (왜 에러가 생기는지, 400은 유효한지 확인 필요)
                      //height: 360.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColor.grey1,
                            style: BorderStyle.solid,
                            width: 2.w
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 15.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(image: AssetImage('assets/image/thumbnail/${widget.topimage}', ),fit: BoxFit.cover),
                                  ),
                                  width: 300.w, height: 200.h,
                                ),
                                SizedBox(height: 15.h,),
                                Text(widget.title,style: TextStyle(color: Colors.black,fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                SizedBox(height: 15.h,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('챌린지 기간',style: TextStyle(color: Colors.grey,fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                    Text(widget.duration,style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', ) ),
                                  ],
                                ),

                                SizedBox(height: 10.h,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('참가인원',style: TextStyle(color: Colors.grey,fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                    Text('${f.format(widget.totaluser)} 명',style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', ) ),
                                  ],
                                ),

                                SizedBox(height: 10.h,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('평균 참여 ${rewardName}',style: TextStyle(color: Colors.grey,fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                    Text('${f.format(widget.avgreward)} ${rewardName}',style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', ) ),
                                  ],
                                ),

                                SizedBox(height: 12.h,),

                                Container(
                                  width: 385.w,
                                  //height: 20.h,
                                  decoration: BoxDecoration(
                                    color: Colors.indigo[50],
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [

                                      SizedBox(height: 4.h,),
                                      Text('미션 종료까지 ${widget.remainDate+1}일 남았습니다',style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', ) ),
                                      SizedBox(height: 4.h,),

                                    ],
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

              // 하임 : 추가함
              SizedBox(height: 8.h,),

              Padding(
                padding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("미션 참여 ${rewardName}", style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),


                            // Container(
                            //   width: 150.w,
                            //   height: 25.h,
                            //   decoration: BoxDecoration(
                            //     color: Colors.grey[300],
                            //     borderRadius: BorderRadius.circular(5),
                            //   ),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Text("나의 보유 ${rewardName} :  ", style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ,textAlign: TextAlign.center,),
                            //       Text("${user_data['reward']} ${rewardName}", style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            //     ],
                            //   ),
                            // ),

                            Container(
                              width: 150.w,
                              //height: 25.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [

                                  SizedBox(height: 4.h,),

                                  SizedBox(
                                    child: FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.contain,

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(width: 5.w,),
                                            Text("나의 보유 ${rewardName} :  ", style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', ) ,textAlign: TextAlign.center,),
                                            Text("${(double.parse(user_data['reward'])).toStringAsFixed(1)} ${rewardName}", style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                            SizedBox(width:7.w,),
                                          ],
                                        )
                                    ),
                                  ),

                                  SizedBox(height: 4.h,),

                                ],

                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 5.h,),


                        SizedBox(
                          height: 85.h,
                          // 항상 뒤에 "원"이 따라다녔으면 좋겠다
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.bottom,
                            controller: rewardCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: " 0 ${rewardName}",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (String? value){
                              // 리워드를 걸지 않았을 때
                              if (value!.isEmpty){
                                return null;
                              }
                              else if(rewardCtrl.text.replaceAll("-", "")!= rewardCtrl.text){
                                rewardCtrl.clear();
                                return "숫자만 입력해 주세요";
                              }
                              // 최대로 걸 수 있는 리워드를 넘었을 때
                              else if(double.parse(value) > limit_bet_reward){
                                return "최대 ${limit_bet_reward} ${rewardName}까지 걸 수 있습니다";
                              }
                              // 리워드를 자신이 가진 리워드보다 더 많이 걸었을 때
                              else if (double.parse(value) > double.parse(user_data['reward'])){
                                return "보유 ${rewardName}보다 많이 걸 수 없습니다";
                              }

                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 5.h,),

                    // 하임 : 폰트 크기 16 > 15로 변경

                    Text('· 참여금이 높을수록 받는 ${rewardName}도 많아져요',style: TextStyle(fontSize: 13.sp, fontFamily: 'korean',) ),
                    SizedBox(height: 5.h,),

                    Text('· ${rewardName}를 걸지 않고도 미션에 참여할 수 있어요',style: TextStyle(fontSize: 13.sp, fontFamily: 'korean',) ),

                  ],
                ),
              ),



              SizedBox(height: 15.h,),

            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: AppColor.happyblue,
        child: Row(
          children: [
            SizedBox(
              height: 70.h,
              width: 412.w,
              child:TextButton(onPressed: ()  async {
                //print("${user_data['reward']} and ${user_data['reward'].runtimeType}");
                if (_formKey.currentState!.validate()) {

                  // 참여할건지 마지막 확인
                  PopPage(
                      "미션 참여", context,
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black), //default
                          children: [
                            TextSpan(text: '${widget.title}', style: TextStyle(fontWeight: FontWeight.bold, )),
                            TextSpan(text: ' 미션에 '),
                            TextSpan(text: '${rewardCtrl.text=='' ? '0' : double.parse(rewardCtrl.text).toStringAsFixed(1)}${rewardName}', style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.happyblue)),
                            TextSpan(text: "를 투자하시겠습니까?"),
                          ])
                      ),
                       "미션 시작", "취소",
                      //onPressed
                        (){
                          participateMission();
                        },
                      null);

                    }
              }, child: Text('미션 시작하기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),
    );
  }
}