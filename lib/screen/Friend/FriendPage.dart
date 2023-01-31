import 'dart:convert';

import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/core/notification.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/Friend/FriendsMissonCheck.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../backend/Api.dart';
import 'package:http/http.dart' as http;

import '../../backend/UserDatabase.dart';

var namedb;
bool waitingsuccess = false;

bool searched = false;
ScrollController scroller = ScrollController();

TextEditingController checkCtrl = TextEditingController();

class FriendPage extends StatefulWidget {
  @override
  _FriendPageState createState() => _FriendPageState();
}

var MyFriendsData = null;
var RequestedList = null;
var FriendList = null;
var RequestFriend = null;

String who_are_friends_string = '';
String who_requested_string = '';

var friendIndexes;

check_friend() async {
  original_friends = await getfriend_fromdb(user_data['user_id']);
  who_are_friends_already = [];
  for (var item in original_friends.keys) {
    if (original_friends[item] == '1') {
      //who_are_friends_already.add(item);
      if (who_are_friends_string==''){
        who_are_friends_string += "$item";
      } else {
        who_are_friends_string += ",$item";
      }

    }
    else if (original_friends[item] == '-1'){
      //who_requested.add(item);
      if (who_requested_string==''){
        who_requested_string += "$item";
      } else {
        who_requested_string += ",$item";
      }

    }
  }

  friendIndexes =
  {"friends":who_are_friends_string,
    "requested": who_requested_string}; //print("${who_are_friends_string} / ${who_requested_string}");

  print("${who_are_friends_string} / ${who_requested_string}");
}



select_friends_information() async {

  await check_friend();

  RequestedList = friendIndexes["requested"].split(",");
  FriendList =  friendIndexes["friends"].split(",");
  print("받은 요청 : ${RequestedList} 친구 : ${FriendList}");

  // 친구가 0명일때도 다시시도해달라고 해서 false로 처리
  MyFriendsData = await select_request(
      "SELECT user_id, user_name, user_email, reward, Ranking FROM DayCus.user_table where user_id in (${friendIndexes["friends"]}) order by Ranking;",
      null,
      false);
  //print(MyFriendsData);

  RequestFriend = await select_request(
      "SELECT user_id, user_name from user_table where user_id in (${friendIndexes["requested"]});",
      null,
      false);

  //MyFriendsData = MyFriendsRes["friends"];
}

class _FriendPageState extends State<FriendPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;


  all_in_one_init() async {

    // 변수 초기화
    MyFriendsData = null;RequestedList = null;FriendList = null;RequestFriend = null;
    who_are_friends_string = '';who_requested_string = '';friendIndexes = null;
    
    await select_friends_information();
    setState(() { waitingsuccess = true; });
    // await check_friend();
    // await get_user_name_from_id();
    // await get_reward_from_id();
    // waitingsuccess = true;
    // setState(() {
    //   waitingsuccess = waitingsuccess;
    // });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    waitingsuccess = false;
    WidgetsBinding.instance.addPostFrameCallback((_){
      all_in_one_init();
    });
    // print(who_are_friends_already);
    // print(names_from_id);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    searched = false;
    checkCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 0),
        child: Column(
          children: [
            Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,

                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: AppColor.happyblue,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [

                  Tab(
                    text: '친구의 미션',
                  ),

                  Tab(
                    text: '친구 추가하기',
                  ),


                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [

                  CheckFriend(),

                  AddFriend(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 사용자가 있는지 확인
check_exist_user(String name, String id) async{
  try {
    var update_res = await http.post(Uri.parse(API.select), body: {
      'update_sql': "select user_name from user_table where user_name = '$name' and user_id = '$id'",
    });

    if (update_res.statusCode == 200 ) {
      var resMission = jsonDecode(update_res.body);
      // print(resMission);
      if (resMission['success'] == true) {
        searched = true;
        namedb = resMission['data'][0]['user_name'];
      } else {
        searched = false;
        Fluttertoast.showToast(msg: "사용자를 찾을 수 없습니다");
      }
    }
  } on Exception catch (e) {
    print("에러발생");
    Fluttertoast.showToast(msg: "업데이트를 진행하는 도중 문제가 발생했습니다.");
  }
}

getfriend_fromdb(String id) async {
  var resultDecode = null;
  var result = await select_request(
      "select friends from user_table where user_id = '$id' ",
      null, false);

  //print("result : ${result[0]['friends']}");

  if (result[0]['friends']!=null){
    resultDecode = jsonDecode(result[0]['friends']);
  } else {
    resultDecode = {};
  }

  return resultDecode;

  // try {
  //   var select_res = await http.post(Uri.parse(API.select), body: {
  //     'update_sql':
  //   });
  //   if (select_res.statusCode == 200 ) {
  //     var resUser = jsonDecode(select_res.body);
  //     var friendsdb = resUser['data'][0]['friends'];
  //     if (friendsdb == null){
  //       friendsdb = {};
  //       return friendsdb;
  //     }
  //     return jsonDecode(friendsdb);
  //   }
  // } on Exception catch (e) {
  //   print("에러발생 : ${e}");
  //   return false;
  //   //Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
  // }
}
requesting_friend(String id) async {
  var original_friends = await getfriend_fromdb(id);
  original_friends[user_data['user_id']] = '-1';

  bool result = await update_request(
      "update user_table set friends = '${jsonEncode(original_friends)}' where user_id = '$id'",
      null);

  return result;

  // try {
  //
  //
  //   var update_res = await http.post(Uri.parse(API.update), body: {
  //     'update_sql': ,
  //   });
  //
  //   if (update_res.statusCode == 200 ) {
  //     var resMission = jsonDecode(update_res.body);
  //     if (resMission['success'] == true) {
  //       print("성공~~~");
  //     } else {
  //       print("에러발생");
  //     }
  //   }
  // } on Exception catch (e) {
  //   print("에러발생");
  //   Fluttertoast.showToast(msg: "정산을 신청하는 도중 문제가 발생했습니다.");
  // }
}


add_friend_fromdb(String id) async {

    var original_friends = await getfriend_fromdb(user_data['user_id']);
    original_friends[id] = '0';
    bool result = await update_request(
        "update user_table set friends = '${jsonEncode(original_friends)}' where user_id = '${user_data['user_id']}'",
        "친구 요청이 완료되었습니다 !");

    // 키보드 숨기기
    if (result){
      FocusManager.instance.primaryFocus?.unfocus();
    }

    return result;

  // try {
  //   var select_res = await http.post(Uri.parse(API.update), body: {
  //     'update_sql':
  //   });
  //   if (select_res.statusCode == 200 ) {
  //     var resUser = jsonDecode(select_res.body);
  //     if (resUser['success'] == true) {
  //       Fluttertoast.showToast(msg: "친구 요청이 완료되었습니다 !");
  //     }
  //     else {
  //       Fluttertoast.showToast(msg: "시도 중 오류가 발견되었습니다");
  //     }
  //   }
  // } on Exception catch (e) {
  //   print("에러발생 : ${e}");
  //   //Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
  // }
}

accepted_friend(String id) async {
  try {
    var original_friends = await getfriend_fromdb(id);
    original_friends[user_data['user_id']] = '1';
    var select_res = await http.post(Uri.parse(API.update), body: {
      'update_sql': "update user_table set friends = '${jsonEncode(original_friends)}' where user_id = '$id'"
    });
    if (select_res.statusCode == 200 ) {
      var resUser = jsonDecode(select_res.body);
      if (resUser['success'] == true) {
      }
      else {
      }
    }
  } on Exception catch (e) {
    print("에러발생 : ${e}");
  }
}

// var names_from_id = [];

// preget_user_name_from_id(String id) async {
//   try {
//     var select_res = await http.post(Uri.parse(API.select), body: {
//       'update_sql': "select user_name from user_table where user_id = '$id'"
//     });
//     if (select_res.statusCode == 200 ) {
//       var resUser = jsonDecode(select_res.body);
//       if (resUser['success'] == true) {
//         return resUser['data'][0]['user_name'];
//       }
//       else {
//         return null;
//       }
//     }
//   } on Exception catch (e) {
//     print("에러발생 : ${e}");
//   }
// }

//
// get_user_name_from_id() async {
//   names_from_id = [];
//   for (var item in who_are_friends_already){
//     var gaboza = await preget_user_name_from_id(item);
//     names_from_id.add(gaboza);
//   }
// }

// var rewards_from_id = [];
// preget_reward_from_id(String id) async {
//   try {
//     var select_res = await http.post(Uri.parse(API.select), body: {
//       'update_sql': "select reward from user_table where user_id = '$id'"
//     });
//     if (select_res.statusCode == 200 ) {
//       var resUser = jsonDecode(select_res.body);
//       if (resUser['success'] == true) {
//         return resUser['data'][0]['reward'];
//       }
//       else {
//         return null;
//       }
//     }
//   } on Exception catch (e) {
//     print("에러발생 : ${e}");
//   }
// }

// get_reward_from_id() async {
//   rewards_from_id = [];
//   for (var item in who_are_friends_already){
//     var gaboza = await preget_reward_from_id(item);
//     rewards_from_id.add(gaboza);
//   }
// }


var who_requested = [];
var original_friends;
var who_are_friends_already = [];

// check_who_request_friend() async {
//   original_friends = await getfriend_fromdb(user_data['user_id']);
//   who_requested = [];
//   for (var item in original_friends.keys) {
//     if (original_friends[item] == '-1') {
//       who_requested.add(item);
//     }
//   }
// }


// 친구 요청 수락
accept_particular_friend(String user_id) async {

    await accepted_friend(user_id);
    original_friends[user_id] = '1';

    bool result = await update_request(
        "update user_table set friends = '${jsonEncode(
            original_friends)}' where user_id = '${user_data['user_id']}'",
        "친구 요청을 받았습니다");

    return result;
}

// 모든 친구 요청 수락
// accept_all_friend() async {
//   try {
//     for (var item in who_requested) {
//       await accepted_friend(item);
//       original_friends[item] = '1';
//     }
//     var update_res = await http.post(Uri.parse(API.update), body: {
//       'update_sql': "update user_table set friends = '${jsonEncode(original_friends)}' where user_id = '${user_data['user_id']}'",
//     });
//
//     if (update_res.statusCode == 200 ) {
//       var resMission = jsonDecode(update_res.body);
//       if (resMission['success'] == true) {
//         print("성공~~~");
//         Fluttertoast.showToast(msg: "성공적으로 친구 요청을 받았습니다!");
//       } else {
//         print("에러발생");
//       }
//     }
//   } on Exception catch (e) {
//     print("에러발생");
//     Fluttertoast.showToast(msg: "수락하는 도중 문제가 발생했습니다.");
//   }
// }


class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {


  @override
  Widget build(BuildContext context) {

    int RequestedCnt = (RequestFriend==null || RequestFriend==false) ? 0 : RequestFriend.length;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 30.h, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                Container(
                  width: 320.w,
                  //height: 300.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                      Padding(
                        padding: EdgeInsets.fromLTRB(25.w, 22.h, 25.w, 0),
                        child: Container(
                          width: 320.w,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("친구 검색하기",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, fontSize: 18.sp) ),
                              SizedBox(height: 3.h,),
                              Text("친구와 함께 미션을 수행해보세요",style: TextStyle(fontFamily: 'korean',  fontSize: 10.sp, color: AppColor.happyblue) ),
                              SizedBox(height: 15.h,),

                              Container(
                                width: 320.w,
                                height: 1.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300]
                                ),
                              )
                            ],
                          )
                        ),
                      ),

                      SizedBox(height: 20.h,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lightbulb, size: 12.w,),
                          Text(" 검색방법  :  친구의 '닉네임 + @사용자 코드'를 입력하세요",style: TextStyle(fontFamily: 'korean',  fontSize: 10.sp, ) ),

                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lightbulb, size: 12.w,),
                          Text(" 사용자 코드는 마이페이지>개인정보 설정에서 확인하세요 ",style: TextStyle(fontFamily: 'korean',  fontSize: 10.sp, ) ),

                        ],
                      ),

                      SizedBox(height: 3.h,),

                      Text("ex) 친구의 닉네임이 roy, 사용자 코드가 01인 경우 'roy@01' 입력",style: TextStyle(fontFamily: 'korean',  fontSize: 8.sp, ) ),
                      SizedBox(height: 10.h,),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20.w,),

                          SizedBox(
                            height: 60.h,
                            width: 220.w,
                            child : TextFormField(
                              controller: checkCtrl,
                              decoration: InputDecoration(
                                  hintText: "친구의 닉네임과 사용자 코드를 입력하세요",
                                  hintStyle: TextStyle(fontFamily: 'korean',fontSize: 10.sp )
                              ),
                            ),
                          ),

                          SizedBox(width: 8.w,),

                          IconButton(
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.search),color: Colors.black,
                            onPressed: () async {
                              await check_exist_user(checkCtrl.text.trim().split('@')[0], checkCtrl.text.trim().split('@')[1]);
                              setState(() {
                              });
                            }
                          ),

                        ],
                      ),


                      SizedBox(height: 10.h,),


                      Container(
                        width: 250.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: searched ? [

                            SizedBox(width: 5.w,),
                            SizedBox(
                              width: 140.w,
                              height: 24.h,
                              child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.contain,

                                child: Text(checkCtrl.text.trim().split('@')[0],
                                    style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
                              ),
                            ),


                            SizedBox(width: 8.w,),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                primary: Colors.indigo[600],
                                onPrimary: Colors.white,
                                minimumSize: Size(18.w, 28.h),
                                textStyle: TextStyle(fontSize: 18.sp),
                              ),

                              onPressed: () {
                                if (FriendList.contains(checkCtrl.text.trim().split('@')[1]) == false) {
                                  add_friend_fromdb(checkCtrl.text.trim().split(
                                      '@')[1]);
                                  requesting_friend(checkCtrl.text.trim().split(
                                      '@')[1]);

                                }
                                else{
                                  Fluttertoast.showToast(msg: "이미 친구로 등록되어 있습니다.");
                                }

                                checkCtrl.clear();
                                setState(() {
                                  searched = false;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("친구 요청",style: TextStyle(fontFamily: 'korean', fontSize: 10.sp) ),
                                ],
                              ),
                            ),

                            SizedBox(width: 4.w,),



                          ] : [Container()],
                        ),
                      ),

                      // Container(
                      //   width: 250.w,
                      //   height: 48.h,
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey[300],
                      //     borderRadius: BorderRadius.circular(5),
                      //   ),
                      //   child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //
                      //         SizedBox(width: 5.w,),
                      //         SizedBox(
                      //           width: 140.w,
                      //           height: 24.h,
                      //           child: FittedBox(
                      //             alignment: Alignment.center,
                      //             fit: BoxFit.contain,
                      //             child: Text("dgdgdgd",
                      //                 style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
                      //           ),
                      //         ),
                      //         SizedBox(width: 8.w,),
                      //         ElevatedButton(
                      //           style: ElevatedButton.styleFrom(
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(10)
                      //             ),
                      //             primary: Colors.indigo[600],
                      //             onPrimary: Colors.white,
                      //             minimumSize: Size(18.w, 28.h),
                      //             textStyle: TextStyle(fontSize: 18.sp),
                      //           ),
                      //           onPressed: () {},
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Text("친구 요청",style: TextStyle(fontFamily: 'korean', fontSize: 10.sp) ),
                      //             ],
                      //           ),
                      //         ),
                      //       ]
                      //   ),
                      // ),

                      SizedBox(height: 28.h,),

                    ],
                  ),
                ),




                SizedBox(height: 30.h,),

                Container(
                  width: 320.w,
                  //height: 300.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [

                      Padding(
                        padding: EdgeInsets.fromLTRB(25.w, 22.h, 25.w, 0),
                        child: Container(
                            width: 320.w,
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("친구 요청 확인하기",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, fontSize: 18.sp) ),
                                SizedBox(height: 3.h,),
                                Text("친구가 보낸 요청을 확인해보세요",style: TextStyle(fontFamily: 'korean',  fontSize: 10.sp, color: AppColor.happyblue) ),
                                SizedBox(height: 15.h,),

                                Container(
                                  width: 320.w,
                                  height: 1.h,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300]
                                  ),
                                )
                              ],
                            )
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 30.h),
                        child: Column(
                          children: [


                            Container(
                              width : 280.w,
                              height: 180.h,

                              child: Scrollbar(
                                controller: scroller,
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
                                    controller: scroller,

                                    child: Column(
                                      children: [

                                        Container(
                                          child: Column(
                                            children: List.generate(RequestedCnt, (index) {
                                              return   Column(
                                                children: [
                                                  Container(
                                                    width: 250.w,
                                                    height: 48.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blueGrey[50],
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [

                                                        SizedBox(width: 5.w,),

                                                        SizedBox(
                                                          width: 140.w,
                                                          height: 24.h,
                                                          child: FittedBox(
                                                            alignment: Alignment.center,
                                                            fit: BoxFit.contain,
                                                            child: Text("${RequestFriend[index]['user_name']}",
                                                                style: TextStyle(
                                                                  fontSize: 16.sp,
                                                                  fontFamily: 'korean',
                                                                  fontWeight: FontWeight.bold,)),
                                                          ),
                                                        ),

                                                        SizedBox(width: 8.w,),

                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .circular(10)
                                                            ),
                                                            primary: Colors.indigo[600],
                                                            onPrimary: Colors.white,
                                                            minimumSize: Size(18.w, 28.h),
                                                            textStyle: TextStyle(
                                                                fontSize: 18.sp),
                                                          ),

                                                          onPressed: () async {
                                                            bool success1 = false;
                                                            print("요청 받는 친구의 id : ${RequestFriend[index]['user_id']}");
                                                            success1 = await accept_particular_friend(RequestFriend[index]['user_id']);
                                                            
                                                            if (success1){
                                                              // 알람 보내기
                                                              showNotification(RequestFriend[index]['user_name']);
                                                              
                                                              setState(() {
                                                                RequestFriend.removeAt(index);
                                                              });
                                                              // 수락 후 다시 데이터 불러오기
                                                              MyFriendsData = null;RequestedList = null;FriendList = null;RequestFriend = null;
                                                              who_are_friends_string = '';who_requested_string = '';friendIndexes=null;

                                                              await select_friends_information();

                                                               setState(() {

                                                               });
                                                            }


                                                          },
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text("요청 수락",
                                                                  style: TextStyle(
                                                                      fontFamily: 'korean',
                                                                      fontSize: 10.sp)),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(width: 4.w,),

                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.h,),


                                                ],

                                              );
                                            }),
                                          )
                                        ),

                                        // for (int idx = 0; idx < who_requested.length; idx ++)





                                          SizedBox(height: 20.h,),

                                          // Container(
                                          //   width: 260.w,
                                          //   height: 45.h,
                                          //   decoration: BoxDecoration(
                                          //     color: Colors.blueGrey[50],
                                          //     borderRadius: BorderRadius.circular(
                                          //         15),
                                          //   ),
                                          // ),
                                          // SizedBox(height: 10.h,),
                                      ],
                                    ),
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



              ],
            ),
          ),
        ),
      ),


    );
  }
}

class CheckFriend extends StatefulWidget {
  const CheckFriend({Key? key}) : super(key: key);

  @override
  State<CheckFriend> createState() => _CheckFriendState();
}

class _CheckFriendState extends State<CheckFriend> {

  @override
  Widget build(BuildContext context) {

    int FriendCnt = (MyFriendsData==null || MyFriendsData==false) ? 0 : MyFriendsData.length;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (FriendCnt!=0)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Text("※ 프로필 사진은 추후 업데이트에서 반영할 예정입니다",
                  style: TextStyle(fontSize: 9.sp, fontFamily: 'korean',  color: Colors.red) ),
            ),



            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20.h, left: 0, right: 0),
              child: (FriendCnt==0)
                  ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.black), //default
                              children: [
                                TextSpan(text: '친구 추가하기', style: TextStyle(fontWeight: FontWeight.bold,)),
                                TextSpan(text: ' 페이지에서 친구를 추가해 보세요 !'),
                              ])
                      ),
                    ],
                  )
                  : Wrap(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(FriendCnt, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                FriendMissionCheckPage(userData: MyFriendsData[index],)));
                    },
                    child: Container(
                      width: 155.w,
                      //height: 80.h,
                      padding: EdgeInsets.only(right: 6.w, left: 6.w),
                      margin: EdgeInsets.only(right: 5.w, left: 5.w, bottom: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 6.h, 0, 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: waitingsuccess ? [
                            SizedBox(width: 4.w,),
                            CircleAvatar(
                              radius: 25.h,
                              //backgroundColor: Colors.grey,
                              backgroundImage: AssetImage("assets/image/non_profile.png",) ,

                            ),
                            Container(
                              width: 80.w,
                              height: 60.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 70.w,
                                    height: 25.h,
                                    child: FittedBox(
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                      child: Text(MyFriendsData[index]['user_name'],
                                          style: TextStyle(fontSize: 10.sp,
                                            fontFamily: 'korean',
                                            fontWeight: FontWeight.bold,)),
                                    ),
                                  ),

                                  SizedBox(height: 3.h,),

                                  SizedBox(
                                    width: 70.w,
                                    height: 22.h,
                                    child: FittedBox(
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,
                                      child: Row(
                                        children: [
                                          Icon(Icons.control_point_duplicate,
                                            size: 14.w,
                                            color: AppColor.happyblue,),
                                          SizedBox(width: 3.w,),
                                          Text((double.parse(MyFriendsData[index]['reward'])).toStringAsFixed(1),
                                              style: TextStyle(fontSize: 10.sp,
                                                fontFamily: 'korean',
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.happyblue,)),
                                        ],
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                            SizedBox(width: 4.w,),
                          ] : [],
                        ),
                      ),
                    ),
                  );

                  // InkWell(
                  //   onTap: () {},
                  //   child: Container(
                  //     width: 150.w,
                  //     height: 80.h,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white60,
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         SizedBox(width: 4.w,),
                  //         CircleAvatar(
                  //           radius: 25.h,
                  //           backgroundColor: Colors.grey,
                  //         ),
                  //         Container(
                  //           width: 80.w,
                  //           height: 60.h,
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //
                  //
                  //               SizedBox(
                  //                 width: 70.w,
                  //                 height: 25.h,
                  //                 child: FittedBox(
                  //                   alignment: Alignment.center,
                  //                   fit: BoxFit.contain,
                  //                   child: Text("kdjkgjkjdk",
                  //                       style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
                  //                 ),
                  //               ),
                  //
                  //               SizedBox(height: 3.h,),
                  //
                  //               SizedBox(
                  //                 width: 70.w,
                  //                 height: 22.h,
                  //                 child: FittedBox(
                  //                   alignment: Alignment.center,
                  //                   fit: BoxFit.contain,
                  //                   child: Row(
                  //                     children: [
                  //                       Icon(Icons.control_point_duplicate, size: 14.w,color: AppColor.happyblue,),
                  //                       SizedBox(width: 3.w,),
                  //                       Text("5.0",
                  //                           style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,color: AppColor.happyblue, ) ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //
                  //
                  //             ],
                  //           ),
                  //         ),
                  //         SizedBox(width: 4.w,),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                }
              ),
            ),

            )],
        ),
      ),


    );
  }
}