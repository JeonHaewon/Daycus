import 'package:daycus/backend/doMissionImport.dart';
import 'package:daycus/backend/missionParticipate.dart';
import 'package:daycus/backend/missionUserUpdate.dart';
import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/core/app_controller.dart';
import 'package:daycus/backend/importMissions.dart';

import '../../backend/userDataImport.dart';



class MissionParticipatePage extends StatelessWidget {
  MissionParticipatePage({
    Key? key,
    required this.mission_id,
    required this.topimage,
    required this.title,
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

  final onTap;

  final TextEditingController rewardCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var f = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {
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
                      height: 400.h,
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
                            padding: EdgeInsets.fromLTRB(30.w, 15.h, 30.w, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/image/specificmissionpage/$topimage.png' , width: 330.w,),
                                SizedBox(height: 15.h,),
                                Text(title,style: TextStyle(color: Colors.black,fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                SizedBox(height: 15.h,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('챌린지 기간',style: TextStyle(color: Colors.grey,fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                    Text(duration,style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', ) ),
                                  ],
                                ),

                                SizedBox(height: 10.h,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('참가인원',style: TextStyle(color: Colors.grey,fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                    Text('${f.format(totaluser)}명',style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', ) ),
                                  ],
                                ),

                                SizedBox(height: 10.h,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('평균 참여 리워드',style: TextStyle(color: Colors.grey,fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                    Text('${f.format(avgreward)}원',style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', ) ),
                                  ],
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
              SizedBox(height: 15.h,),

              Padding(
                padding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("미션 참여 리워드", style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        SizedBox(
                          height: 100.h,
                          // 항상 뒤에 "원"이 따라다녔으면 좋겠다
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.bottom,
                            controller: rewardCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: " 0원",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (String? value){
                              // 리워드를 걸지 않았을 때
                              if (value!.isEmpty){
                                return null;
                              }
                              // 리워드를 자신이 가진 리워드보다 더 많이 걸었을 때
                              // 최대로 걸 수 있는 리워드를 정해야함.
                              else if (int.parse(value) > int.parse(user_data['reward'])){
                                return "보유 리워드보다 많이 걸 수 없습니다";
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    // 하임 : 폰트 크기 16 > 15로 변경
                    SizedBox(height: 15.h,),
                    Text('· 참여금이 높을수록 받는 리워드도 많아져요',style: TextStyle(fontSize: 15.sp, fontFamily: 'korean',) ),
                    SizedBox(height: 5.h,),

                    Text('· 리워드를 걸지 않고도 미션에 참여할 수 있어요',style: TextStyle(fontSize: 15.sp, fontFamily: 'korean',) ),

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
                print("${user_data['reward']} and ${user_data['reward'].runtimeType}");
                if (_formKey.currentState!.validate()) {
                  // 꼭 await해야하는거랑 안해야하는거 구분해서 수정하기
                  // 참여자수 늘리는건 굳이 안해도 되므로, 로딩기능이 추가되면 await에서 빼기 !

                  // 참여 미션 등록하기
                  await missionParticipate(mission_id, user_data['user_email'], rewardCtrl.text=='' ? '0' : rewardCtrl.text);

                  // 참여 유저 업데이트
                  await missionUserUpdate(mission_id);

                  // 이것도 어플 상에서 UI 업데이트 구현하고, 네트워크는 백그라운드상에서 구현
                  // 로딩 시 네트워크로 구현해도 될듯.
                  // 진행중인 미션 목록 불러오기
                  await doMissionImport();

                  // 백그라운
                  // 이후에 변경된 미션만 다시 불러오는 것도 좋을듯.
                  missionImport();
                  importMissionByCategory();
                  userDataImport();


                  // 돌아가면 홈으로 이동.
                  controller.currentBottomNavItemIndex.value = 2;

                  // 페이지 다 닫고 이동
                  Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (_) => TemHomePage()), (route) => false);







                }
              }, child: Text('미션 시작하기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),
    );
  }
}