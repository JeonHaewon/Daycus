import 'dart:io';
import 'dart:ui';
import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UploadImage.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/missionComplete/MissionComplete.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/core/constant.dart';
import 'package:daycus/screen/specificMissionPage/SpecificMissionPage.dart';
import 'package:daycus/widget/popWidget/bottomPopWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class MissionCheckStatusPage extends StatefulWidget {
  MissionCheckStatusPage({
    Key? key,
    required this.mission_index,
    required this.do_mission_data,
    required this.mission_data,
    this.onTap,
  }) : super(key: key);
  final int mission_index;
  final onTap;
  final do_mission_data;
  final mission_data;

  @override
  State<MissionCheckStatusPage> createState() => _MissionCheckStatusPageState();

}



class _MissionCheckStatusPageState extends State<MissionCheckStatusPage> {

  double _textSpacing = 10.w;


  todayMissionCertify(int do_i, String source) async {

    String todayString = await NowTime('yyyyMMddHHmmss');
    String imageName = "${widget.mission_data['mission_id']}_${todayString.substring(0,8)}_${todayString.substring(8,14)}_${user_data['user_id']}_${widget.do_mission_data['do_id']}";

    if (source=='gallery'){
      await getImage(imageName, ImageSource.gallery);
    }
    else if (source == 'camera'){
      await getImage(imageName, ImageSource.camera);
    }


    // 갤러리로 찍을 경우 다시 보여준다
    // if (source==ImageSource.gallery){
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
    //     body: Column(
    //       children: [
    //         Image.file(File(image!.path)),
    //       ],
    //     ),
    //   )));
    // }

    print("${widget.mission_data['image_locate']}");
    await uploadImage(
          imageName,
        "${widget.mission_data['image_locate']}",
        source,
      widget.do_mission_data['do_id'],
      todayBlockCnt,
    );

    setState(() {
      do_mission[do_i]["d$todayBlockCnt"] = true;
      return_reward = doneCnt/toCertify>1 ? 1 : doneCnt/toCertify;
    });

    Fluttertoast.showToast(msg: "오늘 미션이 인증되었습니다");
  }

  // 하임 1220 : 미션 시작일로부터 지난 날짜 (초기화)
  int todayBlockCnt = 0;
  int missionDate = 0;

  int _oneWeek = 7;
  double return_reward = 0;
  int toCertify = 14;

  String returnRewardString = "0";

  @override
  void initState () {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncMethod();
    });
  }


  // 하임 1220: 미션 시작일로부터 지난 날짜 계산 후 set state
  _asyncMethod() async {
    print("init");
    // 하임 1220 : now_time = yy/MM/dd 형태
    String now_time = await NowTime("yyyyMMdd");
    //print(now_time);
    //print("mission_data : ${widget.mission_data}");
    //print("end date : "+widget.mission_data['end_date']);

      setState(() {
        todayBlockCnt = DateTime.parse(now_time)
            .difference((DateTime.parse(widget.mission_data['start_date']))).inDays + 1;
        //print("time_diff : $time_diff");

        missionDate = int.parse(widget.mission_data['term'])*_oneWeek;
        toCertify = int.parse(widget.mission_data['frequency']) * int.parse(widget.mission_data['term']);
        return_reward = doneCnt/toCertify>1 ? 1 : doneCnt/toCertify;

        print("todayBlockCnt : ${todayBlockCnt}");

      });


  }

  // dart.io로 file 불러왔음. html로 불러야할지도

  var f = NumberFormat('###,###,###,###');


  int doneCnt = 0;

  @override
  void dispose() {
    super.dispose();

    int mission_result = 0;
    double return_reward = 0;
    for (int i = 1; i <= mission_week; i++) {
      if (widget.do_mission_data['d${i}'] != null)
        mission_result++;
    } print(mission_result);

    // +0원 계산하기
    // if (widget.do_mission_data['bet_reward']=='0' && (15-mission_result >= toCertify-doneCnt)){
    //   return_reward = double.parse(mission_result.toString());}
    // else if ()
    //   Text("+ ${(return_reward*14).toStringAsFixed(1)} ${rewardName}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
    //
    // // 건 리워드가 없을 경우 & 실패했을 경우
    // if (widget.do_mission_data['bet_reward']=='0' && (15-todayBlockCnt < toCertify-doneCnt) )
    // Text(" - ",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
    //
    // // 건 리워드가 있을 경우
    // if (widget.do_mission_data['bet_reward']!='0' && (15-todayBlockCnt >= toCertify-doneCnt) )
    // Text("+ ${((return_reward*14)+int.parse(widget.do_mission_data['bet_reward'])/100*int.parse(widget.mission_data['reward_percent'])).toStringAsFixed(1)} ${rewardName}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
    //
    // // 건 리워드가 있을 경우 & 실패했을 경우
    // if (widget.do_mission_data['bet_reward']!='0' && (15-todayBlockCnt < toCertify-doneCnt) )
    // Text("+ ${((return_reward*14)+(int.parse(widget.do_mission_data['bet_reward'])/2)).toStringAsFixed(1)} ${rewardName}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
  }


  @override
  Widget build(BuildContext context) {

    //print("build :: ");

    int index_i = -1; int index_j = -1;

    String title = widget.mission_data['title'];
    String duration = '${widget.mission_data['start_date']} ~ ${widget.mission_data['end_date']}';
    int totaluser = int.parse(widget.mission_data['total_user']);
    // int certifiuser = int.parse(widget.mission_data['certifi_user']);

    // 크기 안맞아서 변경
    // height 35.h > 35.w, sp 15.sp > 12.w
    double _height = 35.w;
    double _sp = 12.w;
    double _width = 35.w;

    double _betweenWidth = 9.w;


    int i = widget.mission_index;
    int do_i = all_missions[i]['now_user_do'];

    Widget cameraOrGallery = bottomPopWidget(
        context,

        () async {
          Navigator.pop(context);
          await todayMissionCertify(do_i, "camera");
        },

        () async {
          Navigator.pop(context);
          await todayMissionCertify(do_i, "gallery");
        },
        "카메라", "갤러리",
        Icons.camera_alt, Icons.photo);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('인증 현황',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: null),
          IconButton(icon: Icon(Icons.notifications), onPressed: null),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: EdgeInsets.fromLTRB(30.w, 15.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title,style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                      Column(
                        verticalDirection: VerticalDirection.up,
                        children: [
                          TextButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>
                                    SpecificMissionPage(
                                      mission_data: widget.mission_data,
                                        startDate: widget.mission_data['start_date'],
                                        topimage: widget.mission_data['thumbnail'] ?? 'topimage1.png',
                                        progress: widget.mission_data['start_date']==null
                                            ? (widget.mission_data['next_start_date']==null
                                            ? "willbutton" : "comeonbutton") : "ingbutton",
                                        title: widget.mission_data['title'],
                                        duration: widget.mission_data['start_date']==null
                                            ? (widget.mission_data['next_start_date']==null
                                            ? comingSoonString : '${widget.mission_data['next_start_date']} ~ ${widget.mission_data['next_end_date']}') : '${widget.mission_data['start_date']} ~ ${widget.mission_data['end_date']}',

                                        totaluser: int.parse(widget.mission_data['total_user']),
                                        certifi_user: int.parse(widget.mission_data['certifi_user']),
                                        downimage: 'downimage1',
                                        content: widget.mission_data['content'],
                                        rules: widget.mission_data['rules'],
                                        mission_id: widget.mission_data['mission_id'],
                                        buttonTitle : false,
                                      rewardPercent: widget.mission_data['reward_percent'],
                                    )));
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                              child: Text('미션 상세 페이지 >',style: TextStyle(color: AppColor.happyblue, fontSize: 12.sp, fontFamily: 'korean', decoration: TextDecoration.underline,) ) ),

                          SizedBox(height: 7.sp,),
                        ],
                      ),

                    ],
                  ),
                  //SizedBox(height: 15.h,),

                  Container(
                    width: 500.w,
                    height: 85.h,
                    padding: EdgeInsets.fromLTRB(14.w, 0, 0,0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("• 인증 빈도  :  ${widget.mission_data['term']}주 동안 1주일에 ${widget.mission_data['frequency']}번",
                            style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', color: Colors.grey[800]) ),
                        
                        SizedBox(height: 2.h,),
                    
                        Text("• 총    횟수   :  ${toCertify}회",
                            style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', color: Colors.grey[800]) ),

                        SizedBox(height: 2.h,),

                        Text("• 인증 방법  :  ${widget.mission_data['content']}",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', color: Colors.grey[800]) ),

                      ],
                    ),
                  ),


                  SizedBox(height: 25.h,),
                  Text("미션기간",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', color: Colors.grey) ),
                  SizedBox(height: 5.h,),
                  Text(duration,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean') ),
                  SizedBox(height: 15.h,),


                  // 하임 : height 175.h > 155.w
                  // 이거 휴대폰마다 다른지 확인 필요
                  // 아마 가로길이로 다 설정했기 때문에 거의 맞을 것으로 예상 !
                  Container(
                    width: 500.w,
                    height: _height * 2 + 95.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          padding: EdgeInsets.fromLTRB(20.w, 17.w, 20.w, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("인증 현황",style: TextStyle( color: AppColor.happyblue, fontSize: 14.w, fontFamily: 'korean') ),
                              // SizedBox(height: 3.w,),

                              // 미션 기간 이전
                              if (0>=todayBlockCnt)
                                Text("좋은 습관에 도전하기까지 ${todayBlockCnt+1}일 전",style: TextStyle(  fontSize: 16.w, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                              // 미션 기간 동안
                              if (0<todayBlockCnt && todayBlockCnt<mission_week+1)
                                Text("좋은 습관 만들기까지 ${mission_week-todayBlockCnt+1}일",style: TextStyle(  fontSize: 16.w, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                              // 미션이 끝났을 때
                              if (todayBlockCnt>=15)
                                Text("${mission_week}일간 좋은 습관 만드셨나요?",style: TextStyle(  fontSize: 16.w, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                              SizedBox(height: 10.w,),

                              Container(
                                height: _height * 2 + _betweenWidth,
                                width: _width * _oneWeek + _betweenWidth * _oneWeek + 30.w,
                                child: ListView.builder(
                                  itemCount: 2,
                                  itemBuilder: (_, ___){
                                    index_i += 1; index_j = -1;
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width:_width * _oneWeek + _betweenWidth * (_oneWeek-1),
                                              height: _height,

                                              // 하임 : 정렬 어떻게 하면 완벽한 가운데 정렬이나 완벽하게 좌우가 맞을 수 있을까
                                              // 이거 숫자 잘 계산해야할듯. ListView.builder은 그 부모가 꼭 사이즈를 가져야하는 것 같아서.
                                              child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,

                                                  itemCount : _oneWeek,
                                                  itemBuilder: (_,__) {
                                                    index_j += 1;
                                                    int date = (index_i*7)+(index_j+1);

                                                    if (widget.do_mission_data['d${date}']!=null){
                                                      doneCnt += 1 ;
                                                    }
                                                    return Row(
                                                      children: [
                                                        SizedBox(
                                                          height: _height,
                                                          width: _width,
                                                          child: widget.do_mission_data['d${date}']==null

                                                          // 아직 인증하지 않은 날짜 블럭, date+1 = 오늘 카운트
                                                              ? (todayBlockCnt <= date ?
                                                                  // 날짜가 지나지 않았으면
                                                                  YetMissionBlock(i: index_i, j: index_j, sp: _sp,
                                                                  onPressed: () async {
                                                                    if (date == todayBlockCnt){
                                                                      if (widget.mission_data['certify_tool'] == 'gallery'){
                                                                        showModalBottomSheet(context: context,
                                                                            builder: ((builder) => cameraOrGallery
                                                                            ));
                                                                      } else {
                                                                        todayMissionCertify(do_i, "camera");
                                                                      }
                                                                    } else {
                                                                      Fluttertoast.showToast(msg: "해당 날짜에 인증할 수 있습니다");
                                                                    }
                                                                        },)
                                                              : FailMissionBlock(sp: _sp)
                                                          )
                                                          // 인증 완료된 날짜 블럭
                                                              : DoneMissionBlock(i: index_j, j: index_j, sp: _sp,
                                                            image: image, date: date,)
                                                        ),
                                                        if(index_j != _oneWeek-1)
                                                          SizedBox(
                                                            width: _betweenWidth,
                                                          ),
                                                      ],
                                                    );
                                                  }),
                                            ),
                                          ],
                                        ),

                                        if (index_i == 0)
                                          SizedBox(
                                            height: _betweenWidth,
                                          ),
                                      ],
                                    );

                                  },

                                ),

                              ),


                            ],
                          ),
                        ),

                      ],
                    ),
                  ),



                  SizedBox(height: 30.h,),

                  Text("나의 미션 리포트",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  SizedBox(height: 7.h,),

                  Padding(
                    padding: EdgeInsets.only(left: _textSpacing),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("나의 인증 수",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                            Text("${doneCnt}/${toCertify}회",
                                style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                          ],
                        ),

                        SizedBox(height: 5.h,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("나의 인증률",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                            Text("${(return_reward*100).toStringAsFixed(2)} % ",
                                style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                          ],
                        ),

                        // SizedBox(height: 5.h,),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text("지금까지 성공한 인증 수",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                        //     Text("${doneCnt}회",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        //   ],
                        // ),

                        // SizedBox(height: 5.h,),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text("앞으로 해야할 인증 수",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                        //     Text("5회",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        //   ],
                        // ),

                        SizedBox(height: 5.h,),

                        if (widget.do_mission_data['bet_reward']!='0')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("나의 참여 리워드",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                              Text("${widget.do_mission_data['bet_reward']} ${rewardName} ",
                                  style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                            ],
                          ),

                        if (widget.do_mission_data['bet_reward']!='0')
                        SizedBox(height: 5.h,),

                        if (widget.do_mission_data['bet_reward']!='0')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("리워드 증가율",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                            Text("${widget.mission_data['reward_percent']} % ",
                                style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                          ],
                        ),

                        if (widget.do_mission_data['bet_reward']!='0')
                        SizedBox(height: 5.h,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("예상 환급 리워드",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                            // 건 리워드가 없을 경우
                            if (widget.do_mission_data['bet_reward']=='0' && (15-todayBlockCnt >= toCertify-doneCnt))
                            Text("+ ${(return_reward*14).toStringAsFixed(1)} ${rewardName}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                            // 건 리워드가 없을 경우 & 실패했을 경우
                            if (widget.do_mission_data['bet_reward']=='0' && (15-todayBlockCnt < toCertify-doneCnt) )
                            Text(" - ",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                            // 건 리워드가 있을 경우
                           if (widget.do_mission_data['bet_reward']!='0' && (15-todayBlockCnt >= toCertify-doneCnt) )
                              Text("+ ${((return_reward*14)+int.parse(widget.do_mission_data['bet_reward'])/100*int.parse(widget.mission_data['reward_percent'])).toStringAsFixed(1)} ${rewardName}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                            // 건 리워드가 있을 경우 & 실패했을 경우
                            if (widget.do_mission_data['bet_reward']!='0' && (15-todayBlockCnt < toCertify-doneCnt) )
                              Text("+ ${((return_reward*14)+(int.parse(widget.do_mission_data['bet_reward'])/2)).toStringAsFixed(1)} ${rewardName}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                          ],
                        ),
                      ],
                    ),
                  ),




                  SizedBox(height: 25.h,),

                  Text("전체 결과",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  SizedBox(height: 7.h,),

                  Padding(
                    padding: EdgeInsets.only(left: _textSpacing),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("참여 인원",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                            Text("${f.format(totaluser)} 명",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                          ],
                        ),

                        SizedBox(height: 5.h,),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text("인증 횟수",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                        //     Text("${f.format(certifiuser)} 회",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),



                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        color: AppColor.happyblue,
        child: Row(
          children: [
            SizedBox(
              height: 70.h,
              width: 412.w,
              child:TextButton(onPressed: () async {
                // 성공 개수 카운트
                int mission_result = 0;
                for (int i = 1; i <= mission_week; i++) {
                  if (widget.do_mission_data['d${i}'] != null)
                    mission_result++;
                }
                print("미션 성공한 갯수 :  : ${mission_result}");

                // 미션 끝 : 정산하기
                if (todayBlockCnt > missionDate) {
                  mission_complete(
                      todayBlockCnt,
                      widget.do_mission_data,
                      toCertify,
                      context,
                      user_data['user_email'],
                      mission_result
                  );
                }

                // 미션 포기가 가능할 때
                else if (((15-todayBlockCnt >= toCertify-mission_result) || (widget.do_mission_data['bet_reward']!='0'))==false){
                  mission_complete(
                      todayBlockCnt,
                      widget.do_mission_data,
                      toCertify,
                      context,
                      user_data['user_email'],
                      mission_result
                  );
                }

                // 아직 미션 기간이 되지 않았을 때
                else if(todayBlockCnt <= 0){
                  Fluttertoast.showToast(msg: "아직 미션 기간이 아닙니다.");
                }


                // 14일이 넘어가지 않았을 경우 : 미션 인증
                 else{
                  if (widget.mission_data['certify_tool'] == 'gallery'){
                    showModalBottomSheet(context: context, builder: ((builder) => cameraOrGallery));
                  } else {
                    todayMissionCertify(do_i, "camera");
                  }
                }

                // 시작 날짜의 14일보다 넘어가면 미션 정산하기로 바뀐다.
              }, child: Text( (todayBlockCnt > missionDate) ? '미션 정산하기'
                // 남은 날 다 인증해도 미션을 수행할 수 있을 때 (좌) : 없을 때 (우)
                  : ((15-todayBlockCnt >= toCertify-doneCnt) || (widget.do_mission_data['bet_reward']!='0'))
                    ? '오늘 미션 인증하기' : '미션 포기하기',
                  style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),

    );
  }
}

void showAlertDialog(BuildContext context, File? file, int date) async {
  String result = await showDialog(
    context: context, // user must tap button!
    builder: (BuildContext context) {
      return BackdropFilter(
        child: AlertDialog(
          // 하임 : 내가 인증한 사진 > n일째 인증 사진으로 변경
          title: Text("${date}일째 인증 사진",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
          content: InkWell(
            onTap: (){Navigator.of(context).pop();},
            child: file == null ?
                Text("이미지를 불러올 수 없습니다 :(") :
                Image.file(File(file.path)),
            //Image.asset('assets/image/specificmissionpage/downimage1.png', fit: BoxFit.fill),
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

class FailMissionBlock extends StatelessWidget {
  const FailMissionBlock({
    Key? key,
    required this.sp,
    this.onTap,
  }) : super(key: key);

  final double sp;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){},
        // 원래 pink[40], red 이었음.
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[300])),
        child: Text('X',style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
    );
  }
}

class DoneMissionBlock extends StatelessWidget {
  DoneMissionBlock({
    Key? key,
    required this.i,
    required this.j,
    required this.sp,
    required this.image,
    required this.date,
  }) : super(key: key);

  final int i;
  final int j;
  final double sp;
  final File? image;
  final int date;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){
          // 이미지 다운로드가 될 때까지는 이렇게 있자.
          //showAlertDialog(context, image, date);
          },
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
        // child: Text(((i*7)+(j+1)).toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
        child: Text(date.toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
    );
  }
}

class YetMissionBlock extends StatelessWidget {
  const YetMissionBlock({
    Key? key,
    required this.i,
    required this.j,
    required this.sp,
    this.onPressed,
  }) : super(key: key);

  final int i;
  final int j;
  final double sp;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
        child: Text(((i*7)+(j+1)).toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) ) );
  }
}
















