import 'dart:convert';
import 'dart:typed_data';

import 'package:daycus/backend/Api.dart';
import 'package:daycus/backend/ImportData/imageDownload.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/backend/admin/imageDownload.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/screen/LabelPageCustom.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:daycus/widget/PopPage.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_bottom.dart';
// import '../MyPageCustom.dart';
import 'LabelingEnd.dart';

var fromdb;
int ccnt = 0;
int button_clicked = 0;

Map <String, dynamic> real_cnt_data={};

class LabelingMission extends StatefulWidget {
  LabelingMission({
    Key? key,
    // required this.callback,
    required this.folder,
    required this.title,
    required this.rule,
    required this.label_category,
    required this.content,
    this.onTap,

  }) : super(key: key);

  // Function callback;
  final String folder;
  final String title;
  final String rule;
  final String label_category;
  final String content;
  final onTap;

  @override
  State<LabelingMission> createState() => _LabelingMissionState();
}

class _LabelingMissionState extends State<LabelingMission> {
  var f = NumberFormat('###,###,###,###');

  int degree = 0;
  Image? downloadImage = null;

  var imageList = null;
  int imageListCnt = 0;
  int index = 0;

  var label_category_list = null;
  int label_cnt = 0;

  // 다른 파일에 있는 똑같은 image_download 함수를 사용
  // image_download(String folder, String imageName) async {
  //   setState(() { is_load = false; });
  //   try{
  //     var update_res = await http.post(Uri.parse(API.imageDownload),
  //         body: {
  //           "folder" : folder,
  //           "imageName" : imageName,
  //         });
  //
  //     if (update_res.statusCode == 200) {
  //       print("이미지를 불러왔습니다 : ");
  //       var res = jsonDecode(update_res.body);
  //       Uint8List bytes = Base64Decoder().convert(res['image']);
  //       print("${res['size1'].toStringAsFixed(2)} kb > ${res['size2'].toStringAsFixed(2)} kb, ${res['exif']}");
  //       //print(bytes.isEmpty);
  //
  //       setState(() {
  //         if (res['exif']==3){degree = 180;}
  //         else if (res['exif']==6){degree = 90;}
  //         else if (res['exif']==8){degree = 270;}
  //         else{degree = 0;}
  //
  //         if (bytes.isEmpty){downloadImage = null;
  //         } else{
  //           setState(() {
  //             downloadImage = Image.memory(bytes);
  //           });
  //         }
  //       });
  //
  //       return true;
  //
  //     } else {
  //       setState(() {
  //         downloadImage = null;
  //       });
  //       print("<error : > ${update_res.body}");
  //       return false;
  //     }
  //   }
  //   catch (e) {
  //     print(e.toString());
  //     //Fluttertoast.showToast(msg: e.toString());
  //     return false;
  //   }
  // }

  update_map(int idx, String name) {
    if (real_cnt_data[widget.folder]==null){
      real_cnt_data[widget.folder] = {'${imageList[idx]['id']}' : name};
    }
    else {
      real_cnt_data[widget.folder]!['${imageList[idx]['id']}'] = name;
    }
  }

  storing_json() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('${user_data['user_email']}_label', jsonEncode(real_cnt_data));
  }

  from_jsondata() async {
    fromdb = await getjson_fromdb();
    print(fromdb);
    if (fromdb != null){
      return fromdb;
    }
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('${user_data['user_email']}_label') != null) {
        String? currr = prefs.getString('${user_data['user_email']}_label');
        print(jsonDecode(currr!));
        return jsonDecode(currr!);
      }
      else {
        return {};
      }
    }
  }

  getjson_fromdb() async {

    fromdb = user_data['jsondata'];

    if (fromdb == null){
      fromdb = "{}";

    }
    return fromdb;

    // try {
    //   var select_res = await http.post(Uri.parse(API.select), body: {
    //     'update_sql': "select jsondata from user_table where user_email = '${user_data['user_email']}'"
    //   });
    //   if (select_res.statusCode == 200 ) {
    //     var resUser = jsonDecode(select_res.body);
    //     fromdb = resUser['data'][0]['jsondata'];
    //     if (fromdb == null){
    //       fromdb = {};
    //     }
    //     return fromdb;
    //   }
    // } on Exception catch (e) {
    //   print("에러발생 : ${e}");
    //   return false;
    //   //Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
    // }
  }

  update_json() async {

    bool success = await update_request(
        "update user_table set jsondata = '${jsonEncode(real_cnt_data)}' where user_email = '${user_data['user_email']}'",
        null);

    if (success){
      if (button_clicked != 0) {
        user_data['jsondata'] = real_cnt_data;
        // 0121 하임 : 토스트 너무 많이 나오는 것 같아서 지웠어요
        print("라벨링 업데이트가 완료되었습니다");
        //Fluttertoast.showToast(msg: "라벨링 업데이트가 완료되었습니다 !");
      }
      else return print("변함 없음");
    }


    // try {
    //   var select_res = await http.post(Uri.parse(API.update), body: {
    //     'update_sql': "update user_table set jsondata = '${jsonEncode(real_cnt_data)}' where user_email = '${user_data['user_email']}'"
    //   });
    //   // print(jsonDecode(fromdb));
    //   // print(real_cnt_data);
    //   if (select_res.statusCode == 200 ) {
    //     if (button_clicked != 0) {
    //       // 0121 하임 : 토스트 너무 많이 나오는 것 같아서 지웠어요
    //       print("라벨링 업데이트가 완료되었습니다");
    //       //Fluttertoast.showToast(msg: "라벨링 업데이트가 완료되었습니다 !");
    //     }
    //     else return print("변함 없음");
    //   }
    // } on Exception catch (e) {
    //   print("에러발생 : ${e}");
    //   return false;
    //   //Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
    // }
  }

  // 라벨링 한거는 제외하기
  importImageList(String folder) async {
    try {
      var select_res = await http.post(Uri.parse(API.select), body: {
        'update_sql': "SELECT * FROM image_data WHERE image_locate='${folder}'",
      });

      if (select_res.statusCode == 200 ) {
        var resMission = jsonDecode(select_res.body);
        print(resMission);
        if (resMission['success'] == true) {
          //Fluttertoast.showToast(msg: "이메일을 확인해주세요 !");
          imageList = resMission["data"];
          imageList.shuffle();
          setState(() {
            imageListCnt = resMission["data"]==null ? 0 : resMission["data"].length;
          });
          print("imageListCnt : ${imageListCnt}");
          return true;
        } else {
          //Fluttertoast.showToast(msg: "문제가 발생했습니다");
          return false;
        }

      }
    } on Exception catch (e) {
      print("에러발생 : ${e}");
      return false;
      //Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
    }
  }
  
  // from_db_label_cnt() async {
  //   try {
  //     var select_res = await http.post(Uri.parse(API.select), body: {
  //       'update_sql': "select this_week_label_cnt from user_table where user_email = '${user_data['user_email']}'",
  //     });
  //
  //     if (select_res.statusCode == 200 ) {
  //       var resMission = jsonDecode(select_res.body);
  //       print(resMission);
  //       if (resMission['success'] == true) {
  //         if (resMission['data'][0]['this_week_label_cnt'] == null){
  //           ccnt = 0;
  //         }
  //         else{
  //           ccnt = int.parse(resMission['data'][0]['this_week_label_cnt']);
  //         }
  //         print("잘 불러옴");
  //       } else {
  //         print("못 불러옴");
  //       }
  //
  //     }
  //   } on Exception catch (e) {
  //     print("에러발생 : ${e}");
  //     return false;
  //   }
  // }

  get_data() async {
    real_cnt_data = await from_jsondata();
  }


  @override
  void initState() {
    super.initState();
    get_data();
    ccnt = int.parse(user_data['this_week_label_cnt']);

    label_category_list = widget.label_category.split(", ");
    label_cnt = label_category_list!.length;

    print(label_category_list);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool success = await importImageList(widget.folder);
      if (success==false) {
        // 다른 미션을 불러온다.
        controller.currentBottomNavItemIndex.value = AppScreen.labeling;
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => TemHomePage(),
              transitionDuration: Duration(seconds: 0),
            ),
            (route) => false);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (_) => LabelPage()),
        // );
        // PopPage(
        //     "라벨링 할 데이터가 없습니다.",
        //     context,
        //     Text("현재 이 라벨링 미션은 불가합니다.\n다른 미션을 선택해주세요 !"),
        //     "확인", null,
        //         (){
        //       Navigator.pop(context);
        //       controller.currentBottomNavItemIndex.value = AppScreen.home;
        //     }, null
        // );
      }
      else {
        setState(() { is_load = false; });
        var resImage = await image_download(widget.folder, imageList![index]['image']);
        downloadImage = resImage[0] ; degree = resImage[1];
        setState(() { is_load = true; });
      }
    });
  }

  void dispose(){
    super.dispose();
    storing_json();
    update_json();
    update_request("update user_table set this_week_label_cnt = '$ccnt' where user_email = '${user_data['user_email']}'",null);
  }
  // 로딩을 위한 key
  bool is_load = false;


  bool active = true;
  String exTitle = "접기";

  @override
  Widget build(BuildContext context) {

    final SizedBox _sizedBox = SizedBox(height: 5.h,);


    List<String> rule_list = widget.rule.split("\\n");
    // int rules_list_cnt = rule_list!=null ? rule_list.length : 0;

    int extraindex = -2;

    increase_index() async {
      if (index+1 >= imageListCnt){
        // Fluttertoast.showToast(msg: "마지막입니다");
        }
      else{
        index += 1;
        setState(() { is_load = false; });
        var resImage = await image_download(widget.folder, imageList[index]['image']);
        downloadImage = resImage[0] ; degree = resImage[1];
        setState(() { is_load = true; });// 혹 안뜨는 경우를 대비, 2번 set state 해준다
      }
    }

    do_label(String label_category){
      // 로딩이 다 됐을 때만 라벨링 가능
      if(is_load){
        update_request(
            "UPDATE image_data SET total_labelled=total_labelled+1 where image='${imageList[index]['image']}'",
            null);
        if (label_category=="아니오" || label_category=="인증불가") {
          update_request(
              "UPDATE image_data SET no_data=no_data+1 where image='${imageList[index]['image']}'",
              null);
        }
        increase_index();
      }
    }

    return Scaffold(
      backgroundColor: AppColor.background,

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(32.w, 30.h, 32.w, 0),
              child: ExpansionPanelList(
                expansionCallback: (panelIndex, isExpanded) {
                  active = !active;
                  if(exTitle=="접기")
                    exTitle="펼치기";
                  else
                    exTitle="접기";
                  setState(() {
                  });
                },
                children: <ExpansionPanel>[
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return Container(
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            SizedBox(width: 60.w,),

                            SizedBox(
                              width: 205.w,
                              height: 32.h,
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.contain,
                                child: Text(widget.title ,style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                              ),
                            ),

                          ],
                        )
                      );
                    },
                    body: Column(
                      children: [
                        Padding(

                          padding: EdgeInsets.fromLTRB(40.w, 0, 40.w, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // 하임 > 해원 : 미션 정책 위에 미션 설명도 예쁘게 넣어주면 좋을듯?

                              Container(
                                width: 290.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    Container(
                                      width: 78.w,
                                      //height: 28.h,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 2.h,),
                                          Text("인증 방법",style: TextStyle(color: Colors.indigoAccent, fontSize: 14.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                          SizedBox(height: 2.h,),

                                        ],
                                      ),
                                    ),

                                    SizedBox(height: 10.h,),

                                    Text("${widget.content}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
                                  ],
                                ),
                              ),

                              _sizedBox,

                            ],
                          ),
                        ),




                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5.h, 0,10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Container(
                                width: 280.w,
                                //height: 28.h,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    SizedBox(height: 6.h,),

                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 18.w,
                                            //height: 18.h,
                                            decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 2.h,),
                                                Text("!",style: TextStyle(color: Colors.white, fontSize: 8.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                                SizedBox(height: 2.h,),

                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 6.w,),

                                          Text(canLabelingString,style: TextStyle( fontSize: 9.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6.h,),




                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 30.h),
                          child: Column(
                            children: [
                              Text("※ 모든 사진에는 사람이 나오지 않아야 합니다.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),

                              Text("사람이 나오는 사진은 인증불가를 선택해주세요.",
                                  style: TextStyle(fontSize: 11.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
                            ],
                          ),
                        ),


                      ],
                    ),
                    isExpanded: active,
                    canTapOnHeader: true
                  )
                ],
              ),
            ),





            // Padding(
            //   padding: EdgeInsets.fromLTRB(0, 30.h, 0, 0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(widget.title ,style: TextStyle(fontSize: 24.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
            //     ],
            //   ),
            // ),
            //
            //
            //
            // Padding(
            //   // 하임 : 60.w > 40.w로 수정
            //   // 20.h > 27.h로 수정
            //   padding: EdgeInsets.fromLTRB(40.w, 27.h, 40.w, 0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //
            //       // 하임 > 해원 : 미션 정책 위에 미션 설명도 예쁘게 넣어주면 좋을듯?
            //
            //       Container(
            //         width: 290.w,
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Container(
            //               width: 55.w,
            //               height: 20.h,
            //               decoration: BoxDecoration(
            //                 color: Colors.grey[400],
            //                 borderRadius: BorderRadius.circular(5),
            //               ),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   Text("인증 방법",style: TextStyle(color: Colors.indigoAccent, fontSize: 10.sp, fontFamily: 'korean') ),
            //                 ],
            //               ),
            //             ),
            //
            //             _sizedBox,
            //
            //             Text("${widget.content}",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean') ),
            //           ],
            //         ),
            //       ),
            //
            //
            //
            //       // ListView.builder(
            //       //   shrinkWrap: true,
            //       //   physics: NeverScrollableScrollPhysics(),
            //       //   itemCount: rules_list_cnt,
            //       //
            //       //   itemBuilder: (_, index) {
            //       //     return Column(
            //       //       crossAxisAlignment: CrossAxisAlignment.start,
            //       //       children: [
            //       //         Text(
            //       //           // 하임 > 해원 : 이거 자동 내어쓰기 되도록 변경해야할듯.
            //       //           // 숫자까지 잘라서 list View로 넣으면 될지도??
            //       //             " - ${widget.rule.split("\\n")[index]}",
            //       //             style: TextStyle(fontSize: 14.sp, fontFamily: 'korean', ) ),
            //       //
            //       //         // 맨 마지막 SizedBox는 빼기
            //       //         if (index < rules_list_cnt-1)
            //       //           SizedBox(height: 5.h,),
            //       //       ],
            //       //     );
            //       //   },
            //       //
            //       // ),
            //
            //       _sizedBox,
            //
            //       // Text("ㆍ$rule",style: TextStyle(fontSize: 14.sp, fontFamily: 'korean',) ),
            //
            //     ],
            //   ),
            // ),
            //
            //
            //
            //
            // Padding(
            //   padding: EdgeInsets.fromLTRB(0, 10.h, 0,10.h),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //
            //       Container(
            //         width: 295.w,
            //         height: 30.h,
            //         decoration: BoxDecoration(
            //           color: Colors.deepOrange[100],
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //
            //
            //             Container(
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Container(
            //                     width: 18.w,
            //                     height: 18.h,
            //                     decoration: BoxDecoration(
            //                       color: Colors.deepOrange,
            //                       borderRadius: BorderRadius.circular(20),
            //                     ),
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       crossAxisAlignment: CrossAxisAlignment.center,
            //                       children: [
            //
            //                         Text("!",style: TextStyle(color: Colors.white, fontSize: 8.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
            //                       ],
            //                     ),
            //                   ),
            //                   SizedBox(width: 6.w,),
            //
            //                   Text(canLabelingString,style: TextStyle( fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
            //                 ],
            //               ),
            //             ),
            //
            //
            //
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            //
            // Padding(
            //   padding: EdgeInsets.fromLTRB(0, 0, 0, 15.h),
            //   child: Column(
            //     children: [
            //       Text("※ 모든 사진에는 사람이 나오지 않아야 합니다.\n사람이 나오는 사진은 인증불가를 선택해주세요.",
            //           style: TextStyle(fontSize: 11.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
            //     ],
            //   ),
            // ),
            //
            //
            //
            // Container(
            //   height: 5.h,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //   ),
            // ),

            SizedBox(height:30.h,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // InkWell(
                //   onTap: () async {
                //     if (index == 0){
                //       Fluttertoast.showToast(msg: "처음입니다");}
                //     else{
                //       index -= 1;
                //       await image_download(widget.folder, imageList[index]['image']);
                //       setState(() { is_load = true; });
                //     }
                //   },
                //   child: Container(
                //     height: 85.h,
                //     width: 40.w,
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Image.asset('assets/image/labelingmission/arrow_left.png' ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(width: 35.w,),

                Container(
                    alignment: Alignment.center, width: 310.w,
                    constraints: BoxConstraints(
                        minHeight: 335.h
                    ),
                    child: is_load
                        ? ( downloadImage!=null
                        ? Transform.rotate(angle: degree * pi/180, child: downloadImage,)
                        : Text("이미지가 없습니다", textAlign: TextAlign.center,))
                        : CircularProgressIndicator() ),

                InkWell(
                  onTap: () async {
                    increase_index();
                  },
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

            Container(
              child: Text("${index+1} / ${imageListCnt}"),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 50.w, top: 10.h),
            ),

            SizedBox(
              height: 20.h,
            ),

            Container(
              //alignment: Alignment.center,
              width: 370.w,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:
                (label_cnt % 2 == 0 ? label_cnt / 2 : label_cnt ~/ 2 + 1).toInt(),
                itemBuilder: (_, i) {
                  extraindex += 2;
                  return Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              update_map(index, label_category_list[i*2]);
                              do_label(label_category_list[i*2]);

                              setState(() {
                                button_clicked += 1;
                                ccnt += 1;

                                // final state = LabelPageState.of<LabelPage>();
                                // state?.se

                                // this.widget.callback();
                              });

                              if (ccnt % 10 == 0){
                                Fluttertoast.showToast(msg: "축하합니다! 추가 리워드를 획득하셨습니다!");
                                update_request("update user_table set reward = reward + 0.1 where user_email = '${user_data['user_email']}'", null);
                              }
                              if (index+1 >= imageListCnt){
                                LabelState = "end";
                                controller.currentBottomNavItemIndex.value = AppScreen.labeling;
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (_) => TemHomePage()), (
                                        route) => false);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(builder: (_) => LabelingEnd()));
                              }
                            },
                            child: Text(label_category_list[extraindex]),
                            style: ElevatedButton.styleFrom(
                              primary: label_category_list[extraindex]=="아니오"||label_category_list[extraindex]=="인증불가"
                                  ? Colors.indigo[800] : Colors.indigo[300],
                              minimumSize: Size(140.w, 35.h),
                              textStyle: TextStyle(color : Colors.indigo),
                            ),
                          ),

                          // if (extraindex + 1 < label_cnt)
                          SizedBox(width: 50.w,),

                          if (extraindex + 1 < label_cnt )
                            ElevatedButton(
                              onPressed: () {
                                // 로딩이 다 됐을 때만 라벨링 가능
                                update_map(index, label_category_list[2*i+1]);
                                do_label(label_category_list[2*i+1]);

                                setState(() {
                                  ccnt += 1;
                                  button_clicked += 1;
                                  // this.widget.callback();
                                });
                                if (ccnt % 10 == 0){
                                  Fluttertoast.showToast(msg: "축하합니다! 추가 리워드를 획득하셨습니다!");
                                }
                                if (index+1 >= imageListCnt){
                                  LabelState = "end";
                                  controller.currentBottomNavItemIndex.value = AppScreen.labeling;
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (_) => TemHomePage()), (
                                          route) => false);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(builder: (_) => LabelingEnd()));
                                }
                              },
                              child: Text(label_category_list[extraindex+1]),
                              style: ElevatedButton.styleFrom(
                                primary: label_category_list[extraindex+1]=="아니오"||label_category_list[extraindex+1]=="인증불가"
                                    ? Colors.indigo[800] : Colors.indigo[300],
                                minimumSize: Size(140.w, 35.h),
                                textStyle: TextStyle(color : Colors.indigo),
                              ),
                            ),

                          if (extraindex + 1 == label_cnt )
                          // 껍데기 버튼
                            ElevatedButton(
                              onPressed: () { },
                              child: Text(" "),
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                primary: Colors.transparent,
                                minimumSize: Size(140.w, 35.h),
                                //textStyle: TextStyle(color : Colors.indigo),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(height: 5.h,),

                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 25.h,),




            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //
            //     ElevatedButton(
            //       onPressed: () {
            //         // 로딩이 다 됐을 때만 라벨링 가능
            //         if(is_load){
            //
            //         }
            //       },
            //       child: Text('예'),
            //       style: ElevatedButton.styleFrom(
            //         primary: Colors.indigo[800],
            //         minimumSize: Size(120.w, 35.h),
            //         textStyle: TextStyle(color : Colors.indigo),
            //       ),
            //     ),
            //
            //
            //     SizedBox(width: 20.w,),
            //
            //     ElevatedButton(
            //       onPressed: () {
            //         // 로딩이 다 됐을 때만 라벨링 가능
            //         if(is_load){
            //
            //         }
            //       },
            //       child: Text('아니오'),
            //       style: ElevatedButton.styleFrom(
            //         primary: Colors.indigo[300],
            //         minimumSize: Size(120.w, 35.h),
            //         textStyle: TextStyle(color : Colors.indigo),
            //       ),
            //     ),
            //
            //
            //   ],
            // ),





          ],
        ),
      ),

    );
  }
}

