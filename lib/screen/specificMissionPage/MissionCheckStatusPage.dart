import 'dart:convert';
import 'dart:ui';
import 'package:daycus/screen/specificMissionPage/notSeeForWeek.dart';
import 'package:daycus/widget/certifyTool/pedometerWidget.dart';
import 'package:daycus/backend/ImportData/imageDownload.dart';
import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UploadImage.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/missionComplete/MissionComplete.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/core/constant.dart';
import 'package:daycus/screen/specificMissionPage/SpecificMissionPage.dart';
import 'package:daycus/widget/certifyTool/record/recordWidget.dart';
import 'package:daycus/widget/popWidget/bottomPopWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math';
import 'package:http/http.dart' as http;


late ScrollController _scrollController = ScrollController();

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

class _MissionCheckStatusPageState extends State<MissionCheckStatusPage> with WidgetsBindingObserver {


  String? _chosenValue = "친구공개";
  var _heart = 0;

  importHowAndHeartMission() async {
    var chh = await select_request("select how from do_mission where user_email = '${user_data['user_email']}' and mission_id = '${widget.mission_data['mission_id']}'", null, true);
    _chosenValue = chh[0]['how'] ?? "친구공개";
    var chh2 = await select_request("select heart from do_mission where user_email = '${user_data['user_email']}' and mission_id = '${widget.mission_data['mission_id']}'", null, true);
    _heart = (chh2[0]['heart']==null ? 0 : int.parse(chh2[0]['heart']));
  }

  var isPublic;

  var friendsList;

  ImportFriend() async {
    friendsList = [];
    var friendsdb = await select_request("select friends from user_table where user_email = '${user_data['user_email']}'", null, true);
    var friends = friendsdb[0]['friends'] ?? "{}";
    var friend = jsonDecode(friends);
    for (var item in friend.keys){
      var ff = await select_request("select user_name from user_table where user_id = '$item'", null, true);
      friendsList.add(ff[0]['user_name']);
    }
  }

  ImportPublic() async {
    var chh = await select_request("select public from user_table where user_email = '${user_data['user_email']}'", null, true);
    isPublic = chh[0]['public'] ?? "일부공개";
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch(state){
  //     case AppLifecycleState.resumed:
  //       break;
  //     case AppLifecycleState.inactive:
  //       break;
  //     case AppLifecycleState.detached:
  //       break;
  //     case AppLifecycleState.paused:
  //       break;
  //   }
  // }

  double _textSpacing = 10.w;

  // 하임 1220 : 미션 시작일로부터 지난 날짜 (초기화)
  int todayBlockCnt = 0;
  int missionDate = 0;

  int _oneWeek = 7;
  double return_reward = 0;
  int toCertify = 14;

  String returnRewardString = "0";

  int mission_result = 0;

  bool is_load = false;

  var real_not_see;


  todayMissionCertify(int do_i, String source) async {

    String todayString = await NowTime('yyyyMMddHHmmss');
    String imageName = "${widget.mission_data['mission_id']}_${todayString.substring(0,8)}_${todayString.substring(8,14)}_${user_data['user_id']}_${widget.do_mission_data['do_id']}";


    if (source=='gallery'){
      await getImage(imageName, ImageSource.gallery);
    }
    else if (source == 'camera'){
      await getImage(imageName, ImageSource.camera);
    }

    setState(() {
      is_load = true;
    });


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

    do_mission[do_i]["d$todayBlockCnt"] = imageReNamed;
    setState(() { is_load = false; });
    // result 개수 다시 업데이트
    cnt_done();
    return_reward = mission_result/toCertify>1 ? 1 : mission_result/toCertify;



    Fluttertoast.showToast(msg: "오늘 미션이 인증되었습니다");
  }

  // 하임 0121 : 데이터베이스에 있습니다 !
  // get_not_see(String id) async{
  //   try {
  //     var update_res = await http.post(Uri.parse(API.select), body: {
  //       'update_sql': "select not_see from do_mission where do_id = '$id';",
  //     });
  //
  //     if (update_res.statusCode == 200 ) {
  //       var resMission = jsonDecode(update_res.body);
  //       // print(resMission);
  //       if (resMission['success'] == true) {
  //         real_not_see = resMission['data'][0]['not_see'];
  //         print(real_not_see);
  //
  //       } else {
  //         print("에러발생");
  //         print(resMission);
  //         Fluttertoast.showToast(msg: "다시 시도해주세요");
  //       }
  //     }
  //   } on Exception catch (e) {
  //     print("에러발생");
  //     Fluttertoast.showToast(msg: "업데이트를 진행하는 도중 문제가 발생했습니다.");
  //   }
  // }

  // get_not_seee() async {
  //   await get_not_see(widget.do_mission_data['do_id']);
  // }



  @override
  void initState () {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      ImportFriend();
      ImportPublic();
      importHowAndHeartMission();
      _asyncMethod();
    });
    // 하임 0121 : 이거 뭐에요??
    //WidgetsBinding.instance?.addObserver(this);
    //get_not_seee();
    //print(real_not_see);
    // 하임 0121 : DateTime.now로 하면 시간이 서울 기준으로 찍히나요?
    // if (real_not_see != null && DateTime.now().difference(DateTime.parse(real_not_see)).inDays < 7){
    //   return;
    // }




  }

  cnt_done(){
    mission_result = 0;
    for (int i = 1; i <= mission_week; i++) {
      if ((widget.do_mission_data['d${i}']!=null) && (widget.do_mission_data['d${i}']!='0'))
        mission_result++;
    } print(mission_result);
  }

  // 하임 1220: 미션 시작일로부터 지난 날짜 계산 후 set state
  _asyncMethod() async {
    cnt_done();

    print("init");
    // 하임 1220 : now_time = yy/MM/dd 형태
    String now_time = await NowTime("yyyyMMdd");
    //print(now_time);
    //print("mission_data : ${widget.mission_data}");
    //print("end date : "+widget.mission_data['end_date']);

    print("날짜 --  : ${DateTime.parse(now_time).difference((DateTime.parse(widget.mission_data['start_date']))).inDays + 1}");

      setState(() {
        todayBlockCnt = DateTime.parse(now_time)
            .difference((DateTime.parse(widget.mission_data['start_date']))).inDays + 1;
        //print("time_diff : $time_diff");

        missionDate = int.parse(widget.mission_data['term'])*_oneWeek;
        toCertify = int.parse(widget.mission_data['frequency']) * int.parse(widget.mission_data['term']);
        return_reward = mission_result/toCertify>1 ? 1 : mission_result/toCertify;

        print("todayBlockCnt : ${todayBlockCnt}");

      });

    var now = DateTime.now();
    // 일주일간 보기 기록이 없거나, not_see로부터 일주일이 넘었으면
    if (widget.do_mission_data['not_see']==null){
      NotSeeWeek(context, widget.do_mission_data, widget.mission_data, now);
      // 일주일이 넘었으면은 null이 아닌 경우이기 때문에, else if로 해주어야 Datetime.parse에서 에러가 나지 않는다
    }
    // else if(now.difference(DateTime.parse(widget.do_mission_data['not_see'])).inDays > 7){
    //   NotSeeWeek(context, widget.do_mission_data, widget.mission_data);
    // }


  }

  // dart.io로 file 불러왔음. html로 불러야할지도

  var f = NumberFormat('###,###,###,###');


  int doneCnt = 0;

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);

    print("return_reward : $return_reward");

    update_request(
        "UPDATE do_mission SET percent='${(return_reward*100).toStringAsFixed(2)}' WHERE do_id = '${widget.do_mission_data['do_id']}'",
        null);
    update_request("update do_mission set how = '$_chosenValue' where mission_id = '${widget.mission_data['mission_id']}' and user_email = '${user_data['user_email']}'", null);
    update_request("update do_mission set heart = '${_heart.toString()}' where mission_id = '${widget.mission_data['mission_id']}' and user_email = '${user_data['user_email']}'", null);
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

  bool active = true;
  String exTitle = "접기";

  @override
  Widget build(BuildContext context) {

    //print("build :: ");

    int index_i = -1; int index_j = -1;

    String title = widget.mission_data['title'];
    String duration = '${widget.mission_data['start_date']} ~ ${widget.mission_data['end_date']}';
    int totaluser = int.parse(widget.mission_data['total_user']);
    // int certifiuser = int.parse(widget.mission_data['certifi_user']);
    String rule = widget.mission_data['rules'];


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

    List rules_list = rule.split("\\n");
    int rules_list_cnt = rules_list.length;


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('인증 현황',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
        // actions: [
        //   IconButton(icon: Icon(Icons.search), onPressed: null),
        //   IconButton(icon: Icon(Icons.notifications), onPressed: null),
        // ],
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

                      Container(
                          width: 240.w,

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.clip,
                                    maxLines: 3,
                                    text: TextSpan(
                                        text: title,
                                        style: TextStyle(fontSize: 24.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                                  )
                              ),
                            ],
                          )
                      ),

                      //Text(title,style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),


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


                  //해원 0109_원래 안내 페이지
                  // Container(
                  //   width: 500.w,
                  //   height: 85.h,
                  //   padding: EdgeInsets.fromLTRB(14.w, 0, 0,0),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text("• 인증 빈도  :  ${widget.mission_data['term']}주 동안 1주일에 ${widget.mission_data['frequency']}번",
                  //           style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', color: Colors.grey[800]) ),
                  //
                  //       SizedBox(height: 2.h,),
                  //
                  //       Text("• 총    횟수   :  ${toCertify}회",
                  //           style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', color: Colors.grey[800]) ),
                  //
                  //       SizedBox(height: 2.h,),
                  //
                  //       Text("• 인증 방법  :  ${widget.mission_data['content']}",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean', color: Colors.grey[800]) ),
                  //
                  //     ],
                  //   ),
                  // ),


                  //0127 소셜기능 - 친구와 함께하기
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        children: [
                          SizedBox(width: 10.w,),

                          if (isPublic != "비공개")
                          Row(
                            children: [
                              Container(

                                padding: EdgeInsets.zero,
                                child: DropdownButton<String>(
                                  value: _chosenValue,
                                  //elevation: 5,
                                  style: TextStyle(color: Colors.black),

                                  items: <String>[
                                    '친구공개',
                                    '비공개',
                                  ].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    "공개범위 선택",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _chosenValue = value;
                                    });
                                  },
                                ),
                              ),

                              SizedBox(width: 15.w,),
                            ],
                          ),


                          Icon(Icons.favorite_sharp, color: Colors.red, size: 18.w,),
                          SizedBox(width: 2.w,),
                          Text(_heart.toString(),style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.red) ),
                        ],
                      ),

                      TextButton(
                          onPressed: (){

                            showDialog(context: context, builder: (BuildContext context) {
                              return BackdropFilter(
                                filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                                child: AlertDialog(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("친구를 미션에 초대할 수 있습니다",style: TextStyle(fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                      InkWell(
                                        onTap:(){Navigator.of(context).pop();},
                                        child: Icon(Icons.clear),
                                      )
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      Container(
                                        width : 300.w,
                                        height: 200.h,
                                        child: Scrollbar(
                                          controller: _scrollController,
                                          isAlwaysShown: true,
                                          thickness: 8,
                                          radius: Radius.circular(10),
                                          //scrollbarOrientation: ScrollbarOrientation.right,
                                          child: NotificationListener<OverscrollIndicatorNotification>(
                                            onNotification: (OverscrollIndicatorNotification overScroll) {
                                              overScroll.disallowGlow();
                                              return false;
                                            },
                                            child: SingleChildScrollView(
                                              controller: _scrollController,
                                              child: Column(
                                                children: [


                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: friendsList.length, //친구수
                                                    itemBuilder: (_, index) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(bottom: 5.h),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.indigo[50],
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          width : 300.w,
                                                          height: 45.h,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [

                                                              SizedBox(width: 6.w,),

                                                              Container(

                                                                  width: 110.w,
                                                                  child: FittedBox(
                                                                    fit: BoxFit.scaleDown,
                                                                    child:Text("${friendsList[index]}", style: TextStyle(fontWeight: FontWeight.bold, ),textAlign: TextAlign.center,),
                                                                  )
                                                              ),

                                                              // Container(
                                                              //     width: 50.w,
                                                              //     child: FittedBox(
                                                              //       fit: BoxFit.scaleDown,
                                                              //       child:Text("20", style: TextStyle(fontWeight: FontWeight.bold, ),textAlign: TextAlign.center,), //사용자코드
                                                              //     )
                                                              // ),

                                                              SizedBox(
                                                                width: 65.h,
                                                                height: 25.w,
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    padding: EdgeInsets.zero,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(10)
                                                                    ),
                                                                    primary: Colors.indigo[600],
                                                                    onPrimary: Colors.white,
                                                                    //minimumSize: Size(18.w, 28.h),
                                                                  ),

                                                                  onPressed: () async {
                                                                    var invitationss = await select_request("select invitation from user_table where user_name = '${friendsList[index]}'", null, true);
                                                                    var invitations = invitationss[0]['invitation'] ?? "{}";
                                                                    var invitation = jsonDecode(invitations);
                                                                    invitation[user_data['user_name']] = widget.mission_data['mission_id'];
                                                                    await update_request("update user_table set invitation = '${jsonEncode(invitation)}' where user_name = '${friendsList[index]}'", null);
                                                                    Fluttertoast.showToast(msg: "친구 초대가 완료되었습니다!");
                                                                  },
                                                                  child: Text("초대하기", style: TextStyle(fontFamily: 'korean', fontSize: 10.sp)),
                                                                ),
                                                              ),

                                                              SizedBox(width: 6.w,),

                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),





                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),


                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                          child: Text('친구와 함께하기',style: TextStyle(color: Colors.grey[700], fontSize: 12.sp, fontFamily: 'korean', decoration: TextDecoration.underline,) )
                      ),

                    ],
                  ),


                  SizedBox(height: 10.h,),

                  Container(
                    width: 500.w,
                    //height: 20.h,
                    padding: EdgeInsets.fromLTRB(14.w, 0, 14.w,0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Theme(
                      data: ThemeData(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        iconColor: AppColor.happyblue,
                        initiallyExpanded: true,
                        //leading: Icon(Icons.file_copy_rounded, size: 20.w, color: Colors.grey[400],),
                        title: Container(
                            child : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: 15.w,),

                                Text("미션 안내",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),


                              ],
                            )
                        ),
                        //subtitle: Text('미션 관련 안내 사항을 확인해보세요',style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', color: Colors.black)),
                        children: <Widget>[

                          Padding(
                            padding: EdgeInsets.fromLTRB(14.w, 5.h, 14.w, 20.h),
                            child: Column(
                              children: [

                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                  // Text("1. 미션 종료 후(15일차)에 반드시 '정산하기' 버튼을 눌러주세요!",
                                  //     style: TextStyle(fontSize: 11.5.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                                  // SizedBox(height: 3.h,),
                                  // Text("15일차에 '정산하기' 버튼을 눌러 포인트를 지급받을 수 있습니다. 단, 14일차에 인증을 하는 경우 인증 이후 바로 정산이 가능합니다.",
                                  //     style: TextStyle(fontSize: 10.sp, fontFamily: 'korean',  color: Colors.grey) ),
                                  // SizedBox(height: 2.h,),
                                  // Text("※ 미션 종료 후 2주 내에 정산을 받지 않을 경우 리워드를 지급받지 못합니다.",
                                  //     style: TextStyle(fontSize: 8.sp, fontFamily: 'korean',  color: Colors.grey) ),

                                      Text("1. 주 ${widget.mission_data['frequency']}회, ${widget.mission_data['term']}주간, 총 ${toCertify}회!",
                                          style: TextStyle(fontSize: 11.5.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                                      SizedBox(height: 3.h,),
                                      Text("미션 기간 ${widget.mission_data['term']}주 동안 주 ${widget.mission_data['frequency']}일, 하루 1번 인증 사진을 올리셔야 합니다.",
                                          style: TextStyle(fontSize: 10.sp, fontFamily: 'korean',  color: Colors.grey) ),


                                      SizedBox(height: 15.h,),
                                      Text(widget.mission_data['notice']==null
                                          ? "2. 미션에 알맞은 사진을 올려주세요!"
                                          : "2. " + (widget.mission_data['notice'].split("\n")[0]).toString(),
                                          style: TextStyle(fontSize: 11.5.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                                      SizedBox(height: 3.h,),
                                      if (widget.mission_data['notice']!=null)
                                        Text("${(widget.mission_data['notice'].split("\n")[1]).toString()}",
                                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean',  color: Colors.grey) ),

                                      if (widget.mission_data['notice']==null)
                                        Text("${widget.mission_data['content']}",
                                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean',  color: Colors.grey) ),

                                      if (widget.mission_data['certify_tool']=='camera' || widget.mission_data['certify_tool']=='gallery')
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 15.h,),
                                            Text("3. 미션 인증 시 사람이 나오지 않게 주의해주세요!",
                                                style: TextStyle(fontSize: 11.5.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                                            SizedBox(height: 3.h,),
                                            Text("개인정보 보호를 위해 본인을 포함하여 특정 인물을 나타낼 수 있는 모습이 사진에 나타나지 않도록 주의해주세요.",
                                                style: TextStyle(fontSize: 10.sp, fontFamily: 'korean',  color: Colors.grey) ),
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
                  ),



                  SizedBox(height: 25.h,),

                  Text("미션기간",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', color: Colors.grey) ),


                  SizedBox(height: 10.h,),


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
                          padding: EdgeInsets.fromLTRB(25.w, 17.w, 25.w, 0),
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
                                                                    isLoad: is_load, is_today: (todayBlockCnt==date),
                                                                  onPressed: () async {
                                                                    if (date == todayBlockCnt){
                                                                      if (widget.mission_data['certify_tool'] == 'gallery'){
                                                                        showModalBottomSheet(context: context,
                                                                            builder: ((builder) => cameraOrGallery
                                                                            ));
                                                                      } else if(widget.mission_data['certify_tool'] == 'pedometer'){
                                                                        Fluttertoast.showToast(msg: "아직 미션이 완료되지 않았습니다");
                                                                      }
                                                                      if (widget.mission_data['certify_tool'] == 'recorder'){

                                                                        Fluttertoast.showToast(msg: "녹음 버튼을 눌러 미션을 수행해보세요 !");
                                                                        // showModalBottomSheet(context: context,
                                                                        //     builder: ((builder) => cameraOrGallery
                                                                        //     ));
                                                                      }
                                                                      else {
                                                                        todayMissionCertify(do_i, "camera");
                                                                      }
                                                                    } else {
                                                                      Fluttertoast.showToast(msg: "해당 날짜에 인증할 수 있습니다");
                                                                    }
                                                                        },)
                                                              : FailMissionBlock(sp: _sp)
                                                          )
                                                          // 인증 완료된 날짜 블럭
                                                              : (widget.do_mission_data['d${date}']!='0' ?
                                                          DoneMissionBlock(i: index_j, j: index_j, sp: _sp, date: date,
                                                            is_today: (todayBlockCnt==date), isLoad : is_load,

                                                            folder: widget.mission_data['image_locate'], do_mission_data: widget.do_mission_data, tool: widget.mission_data['certify_tool'],)
                                                          : RejectedMissionBlock(sp: _sp)
                                                          )
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

                  // 만보기 위젯
                  if (widget.mission_data['certify_tool']=='pedometer')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40.h,),

                        Text("현재 걸음 수",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                        SizedBox(height: 5.h,),

                        Row(
                          children: [
                            Text("※ 미션 완료 시 ",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',) ),
                            Text("오늘 미션 인증하기",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
                            Text(" 버튼을 눌러주세요.",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',) ),
                          ],
                        ),

                        Container(
                          child : Text("※ 코딩하다 산책하기 미션은 어플을 종료 시 만보기가 초기화됩니다.",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',) ),
                        ),

                        Container(
                            padding: EdgeInsets.fromLTRB(17.w, 14.h, 17.w, 0),
                            width: 600.w, height: 200.h,
                            child: WalkCountWidget(walkNumber: int.parse(widget.mission_data['condition']))),
                      ],
                    ),

                  if (widget.mission_data['certify_tool']=='recorder')
                    Padding(
                      padding: EdgeInsets.only(top: 30.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("녹음 미션 수행",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                          SizedBox(height: 5.h,),

                          Row(
                            children: [
                              Text("※ ",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',) ),
                              Text("${widget.mission_data['condition']}초 이상 ",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
                              Text("녹음한 후 ",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',) ),
                              Text("오늘 미션 인증하기",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
                              Text(" 버튼을 눌러주세요.",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',) ),

                            ],
                          ),
                          //SizedBox(height: 25.h,),
                          RecordWidget(),

                          //Text("record mission"),
                        ],
                      ),
                    ),


                  if (widget.mission_data['certify_tool']!='recorder')
                  SizedBox(height: 40.h,),


                      ],
                    ),
                  ),

            Container(
              padding: EdgeInsets.fromLTRB(30.w, 20.h, 40.w,0),
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text("나의 미션 리포트",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),


                  if (return_reward>=1)
                    Container(
                      margin: EdgeInsets.only(left: 8.w, top: 7.h, bottom: 3.h),
                      width: 395.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Container(
                            height: 70.h,
                            width: 35.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 10.w,),
                                Icon(Icons.notifications_rounded, color: Colors.blueGrey[400], size: 25.h,),

                              ],
                            ),
                          ),

                          Container(
                            height: 70.h,
                            width: 275.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("미션 총 횟수(인증률 100%)를 넘어도\n미션 기간 동안 계속해서 인증할 수 있습니다.\n꾸준히 여러분의 갓생을 기록해보세요!",
                                    style: TextStyle(fontSize: 11.sp, fontFamily: 'korean') ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ),

                  SizedBox(height: 7.h,),


                  Padding(
                    padding: EdgeInsets.only(left: _textSpacing),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("나의 인증 수",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                            Text("${mission_result}/${toCertify}회",
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
                              Text("나의 참여 ${rewardName}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
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
                              Text("${rewardName} 증가율",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                              Text("${widget.mission_data['reward_percent']} % ",
                                  style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                            ],
                          ),

                        if (widget.do_mission_data['bet_reward']!='0')
                          SizedBox(height: 5.h,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("예상 환급 ${rewardName}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                            // 건 리워드가 없을 경우
                            if (widget.do_mission_data['bet_reward']=='0' && (15-todayBlockCnt >= toCertify-mission_result))
                              Text("+ ${(return_reward*14).toStringAsFixed(1)} ${rewardName}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                            // 건 리워드가 없을 경우 & 실패했을 경우
                            if (widget.do_mission_data['bet_reward']=='0' && (15-todayBlockCnt < toCertify-mission_result) )
                              Text(" - ",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                            // 건 리워드가 있을 경우
                            if (widget.do_mission_data['bet_reward']!='0' && (15-todayBlockCnt >= toCertify-mission_result) )
                              Text("+ ${((return_reward*14)+int.parse(widget.do_mission_data['bet_reward'])/100*int.parse(widget.mission_data['reward_percent'])).toStringAsFixed(1)} ${rewardName}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                            // 건 리워드가 있을 경우 & 실패했을 경우
                            if (widget.do_mission_data['bet_reward']!='0' && (15-todayBlockCnt < toCertify-mission_result) )
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

                        SizedBox(height: 20.h,),

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

            SizedBox(height: 40.h,),


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
                // int mission_result = 0;
                // for (int i = 1; i <= mission_week; i++) {
                //   if (widget.do_mission_data['d${i}'] != null)
                //     mission_result++;
                // }
                // print("미션 성공한 갯수 :  : ${mission_result}");

                // 미션 끝 : 정산하기
                if (todayBlockCnt > missionDate || (todayBlockCnt==missionDate&&do_mission[do_i]["d$todayBlockCnt"]!=null)) {
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

                    // 만보기
                  } else if (widget.mission_data['certify_tool']=='pedometer'){
                    //print("만보기");
                    print("$PedometerSteps ${widget.mission_data['condition']}");
                    if((int.parse(PedometerSteps) >= int.parse(widget.mission_data['condition']))){
                      // 미션 인증
                      bool success = await update_request(
                          "UPDATE do_mission SET d${todayBlockCnt}='${PedometerSteps}' WHERE do_id = '${widget.do_mission_data['do_id']}'",
                          null);
                      if (success){
                        setState(() {
                          do_mission[do_i]["d$todayBlockCnt"] = PedometerSteps;
                        });
                        // result 개수 다시 업데이트
                        cnt_done();
                        return_reward = mission_result/toCertify>1 ? 1 : mission_result/toCertify;
                        Fluttertoast.showToast(msg: "오늘 미션이 인증되었습니다");
                      }
                    } else if (do_mission[do_i]["d$todayBlockCnt"]!=null){
                      Fluttertoast.showToast(msg: "미션을 이미 인증하셨습니다");
                    }
                    else {
                      Fluttertoast.showToast(msg: "${(int.parse(widget.mission_data['condition'])-int.parse(PedometerSteps))} 걸음 남았습니다");
                    }

                  }
                  // 녹음하기 미션
                  else if (widget.mission_data['certify_tool']=='recorder'){
                    // 7이 아닌 경우 이상한 값이 들어갔을 가능성이 있으므로 에러 처리
                    if (temTimer.length == 7){
                      if (temTimer=="00 : 00"){
                        // 녹음 버튼을 누르지도 않았을 때
                        Fluttertoast.showToast(msg: "녹음하기 버튼을 눌러 녹음을 진행해주세요 !");
                      }
                      else {
                        List splitTime = temTimer.split(" : ");
                        int totalRecordTime = int.parse(splitTime[0])*60 + int.parse(splitTime[1]);

                        if (totalRecordTime >= int.parse(widget.mission_data['condition'])){
                          print("녹음된 파일 초 : ${totalRecordTime}");
                          Fluttertoast.showToast(msg: "미션을 인증할 수 있습니다 !");

                          uploadAudio("test", widget.mission_data['image_location']);

                          // 이름으로 하면 좋지만, 임시방편으로 녹음한 시간만 넣음.
                          bool success = await update_request(
                              "UPDATE do_mission SET d${todayBlockCnt}='${temTimer}' WHERE do_id = '${widget.do_mission_data['do_id']}'",
                              null);
                          if (success){
                            setState(() {
                              do_mission[do_i]["d$todayBlockCnt"] = temTimer;
                            });
                            // result 개수 다시 업데이트
                            cnt_done();
                            return_reward = mission_result/toCertify>1 ? 1 : mission_result/toCertify;
                            Fluttertoast.showToast(msg: "오늘 미션이 인증되었습니다");
                          }
                        } else{
                          // 녹음 시간이 부족할때
                          Fluttertoast.showToast(msg: "${widget.mission_data['condition']}초 이상 녹음을 완료야합니다.");

                        }
                      }

                    }
                    else {
                      Fluttertoast.showToast(msg: "알 수 없는 문제가 발생했습니다.\n앱을 완전히 종료한 후 다시 시도해수제요.");
                    }

                    //Fluttertoast.showToast(msg: "녹음미션");
                  }
                  else {
                    todayMissionCertify(do_i, "camera");
                  }
                }

                // 시작 날짜의 14일보다 넘어가면 미션 정산하기로 바뀐다.
              }, child: Text( (todayBlockCnt>missionDate || (todayBlockCnt==missionDate&&do_mission[do_i]["d$todayBlockCnt"]!=null)) ? '미션 정산하기'
                // 남은 날 다 인증해도 미션을 수행할 수 있을 때 (좌) : 없을 때 (우)
                  : ((15-todayBlockCnt >= toCertify-mission_result) || (widget.do_mission_data['bet_reward']!='0'))
                    ? '오늘 미션 인증하기' : '미션 포기하기',
                  style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),

    );
  }
}

void showPedometerAlertDialog(BuildContext context, int date, String? pedometerNum) async {
  var f = NumberFormat('###,###,###,###');
  String result = await showDialog(
    context: context, // user must tap button!
    builder: (BuildContext context) {
      return BackdropFilter(
        child: AlertDialog(
          // 하임 : 내가 인증한 사진 > n일째 인증 사진으로 변경
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${date}일째 걸음 수",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
              InkWell(
                onTap:(){Navigator.of(context).pop();},
                child: Icon(Icons.clear),
              )
            ],
          ),
          content: Container(
            height: 80.h,
            child: pedometerNum != null
            ? Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_run, size: 60.w, color: AppColor.happyblue,),
                  SizedBox(width: 6.w,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("갓생에 성공하셨군요!",style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', color: AppColor.happyblue) ),
                      Row(
                        children: [

                          Container(
                            alignment: Alignment.center,
                            height: 40.h,
                            child: Text("${f.format(int.parse(pedometerNum))}", style: TextStyle(fontSize: 28.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                          ),


                          Container(
                            alignment: Alignment.center,
                            height: 40.h,
                            child: Text(" 걸음",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean',), ),
                          ),


                        ],
                      ),
                    ],
                  ),
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

void showAlertDialog(BuildContext context, int date, Image? downloadImage, int degree) async {

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
            child: downloadImage!=null
                ? Transform.rotate(angle: degree * pi/180, child: downloadImage,)
                : Text("이미지를 불러올 수 없습니다 :(", textAlign: TextAlign.center,),
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
        child: Text('x',style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
    );
  }
}

class DoneMissionBlock extends StatelessWidget {
  DoneMissionBlock({
    Key? key,
    required this.i,
    required this.j,
    required this.sp,
    required this.date,
    required this.folder,
    required this.do_mission_data,
    required this.tool,
    required this.isLoad,
    required this.is_today,
  }) : super(key: key);

  final int i;
  final int j;
  final double sp;
  final int date;
  final String folder;
  final do_mission_data;
  final String tool;
  final bool isLoad;
  final bool is_today;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          if (tool=="camera" || tool=='gallery') {
            var image_data = await image_download(folder, do_mission_data["d${date}"]);

            Image? downloadImage = image_data[0];
            int degree = image_data[1];

    showAlertDialog(context, date, downloadImage, degree);
  } else if (tool=="pedometer"){
  showPedometerAlertDialog(context, date, do_mission_data["d${date}"]);
  }
},
style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
        // child: Text(((i*7)+(j+1)).toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
        child: (isLoad && is_today)
            ? CircularProgressIndicator()
            : Text(date.toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
    );
  }
}

class YetMissionBlock extends StatelessWidget {
  const YetMissionBlock({
    Key? key,
    required this.i,
    required this.j,
    required this.sp,
    required this.is_today,
    this.onPressed,
    required this.isLoad,
  }) : super(key: key);

  final int i;
  final int j;
  final double sp;
  final onPressed;
  final bool isLoad;
  final bool is_today;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
        // 블럭이 오늘을 가리키고, isload가 true이면.
        child: (isLoad && is_today)
            ? CircularProgressIndicator()
            : Text(((i*7)+(j+1)).toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) ) );
  }
}

class RejectedMissionBlock extends StatelessWidget {
  const RejectedMissionBlock({
    Key? key,
    required this.sp,
    this.onTap,
  }) : super(key: key);

  final double sp;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){
          // 팝업창으로 바꾸어도 괜찮고.
          Fluttertoast.showToast(msg: "미션 인증이 반려되었습니다.\n이의 신청 시 \'개발에게 문의하기\' 페이지를 이용하시기 바랍니다.");
        },
        // 원래 pink[40], red 이었음.
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red[300])),
        child: Text('X',style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
    );
  }
}








