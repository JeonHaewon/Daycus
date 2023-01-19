import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/Friend/FriendsMissonCheck.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../backend/Api.dart';
import 'package:http/http.dart' as http;

import '../../backend/UserDatabase.dart';

var namedb;

bool searched = false;

TextEditingController checkCtrl = TextEditingController();
class FriendPage extends StatefulWidget {
  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
                    text: '친구 추가하기',
                  ),

                  Tab(
                    text: '친구의 미션',
                  ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  AddFriend(),
                  CheckFriend(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  try {
    var select_res = await http.post(Uri.parse(API.select), body: {
      'update_sql': "select friends from user_table where user_id = '$id' "
    });
    if (select_res.statusCode == 200 ) {
      var resUser = jsonDecode(select_res.body);
      var friendsdb = resUser['data'][0]['friends'];
      if (friendsdb == null){
        friendsdb = {};
        return friendsdb;
      }
      return jsonDecode(friendsdb);
    }
  } on Exception catch (e) {
    print("에러발생 : ${e}");
    return false;
    //Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
  }
}
requesting_friend(String id) async {
  try {
    var original_friends = await getfriend_fromdb(id);
    original_friends[user_data['user_id']] = '-1';
    var update_res = await http.post(Uri.parse(API.update), body: {
      'update_sql': "update user_table set friends = '${jsonEncode(original_friends)}' where user_id = '$id'",
    });

    if (update_res.statusCode == 200 ) {
      var resMission = jsonDecode(update_res.body);
      if (resMission['success'] == true) {
        print("성공~~~");
      } else {
        print("에러발생");
      }
    }
  } on Exception catch (e) {
    print("에러발생");
    Fluttertoast.showToast(msg: "정산을 신청하는 도중 문제가 발생했습니다.");
  }
}
add_friend_fromdb(String id) async {
  try {
    var original_friends = await getfriend_fromdb(user_data['user_id']);
    original_friends[id] = '0';
    var select_res = await http.post(Uri.parse(API.update), body: {
      'update_sql': "update user_table set friends = '${jsonEncode(original_friends)}' where user_id = '${user_data['user_id']}'"
    });
    if (select_res.statusCode == 200 ) {
      var resUser = jsonDecode(select_res.body);
      if (resUser['success'] == true) {
        Fluttertoast.showToast(msg: "친구 요청이 완료되었습니다 !");
      }
      else {
        Fluttertoast.showToast(msg: "시도 중 오류가 발견되었습니다");
      }
    }
  } on Exception catch (e) {
    print("에러발생 : ${e}");
    //Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
  }
}




class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 20.h, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10.w,),

                  SizedBox(
                    height: 80.h,
                    width: 260.w,
                    child : TextFormField(
                      controller: checkCtrl,
                      decoration: InputDecoration(
                          hintText: "추가하고 싶은 친구의 닉네임을 입력하세요",
                          hintStyle: TextStyle(fontFamily: 'korean',fontSize: 11.sp )
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w,),

                  IconButton(
                      icon: Icon(Icons.search),color: Colors.black,
                    onPressed: () async {
                      await check_exist_user(checkCtrl.text.trim().split('@')[0], checkCtrl.text.trim().split('@')[1]);
                      setState(() {
                      });
                    }
                  ),

                ],
              ),



              Container(
                width: 300.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: searched ? [

                    SizedBox(
                      width: 160.w,
                      height: 25.h,
                      child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.contain,

                        child: Text(checkCtrl.text.trim().split('@')[0],
                            style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
                      ),
                    ),


                    SizedBox(width: 12.w,),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        primary: Colors.indigo[600],
                        onPrimary: Colors.white,
                        minimumSize: Size(20.w, 28.h),
                        textStyle: TextStyle(fontSize: 18.sp),
                      ),

                      onPressed: () {
                        add_friend_fromdb(checkCtrl.text.trim().split('@')[1]);
                        requesting_friend(checkCtrl.text.trim().split('@')[1]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("친구 요청",style: TextStyle(fontFamily: 'korean', fontSize: 10.sp) ),
                        ],
                      ),
                    ),


                  ] : [],
                ),
              ),

              SizedBox(height: 160.h,),

              Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [

                    Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 15.h, 10.w, 10.h),
                      child: Column(
                        children: [
                          Text("친구 요청 확인",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, fontSize: 15.sp) ),

                          SizedBox(height: 15.h,),

                          Container(
                            width : 280.w,
                            height: 170.h,

                            child: Scrollbar(
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

                                  child: Column(
                                    children: [


                                      Container(
                                        width: 260.w,
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey[50],
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(

                                          children: [
                                            
                                            SizedBox(
                                              width: 165.w,
                                              height: 24.h,
                                              child: FittedBox(
                                                alignment: Alignment.center,
                                                fit: BoxFit.contain,
                                                child: Text("djkgjkdjgkjk",
                                                    style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
                                              ),
                                            ),

                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                primary: Colors.indigo[600],
                                                onPrimary: Colors.white,
                                                minimumSize: Size(20.w, 28.h),
                                                textStyle: TextStyle(fontSize: 18.sp),
                                              ),

                                              onPressed: () { },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("요청 수락",style: TextStyle(fontFamily: 'korean', fontSize: 10.sp) ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.h,),

                                      Container(
                                        width: 260.w,
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey[50],
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      SizedBox(height: 10.h,),




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


    );
  }
}

class CheckFriend extends StatelessWidget {
  const CheckFriend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [


                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FriendMissionCheckPage()),
                      );
                    },
                    child: Container(
                      width: 150.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 4.w,),
                          CircleAvatar(
                            radius: 25.h,
                            backgroundColor: Colors.grey,
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
                                    child: Text("kdjkgjkjdk",
                                        style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
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
                                        Icon(Icons.control_point_duplicate, size: 14.w,color: AppColor.happyblue,),
                                        SizedBox(width: 3.w,),
                                        Text("5.0",
                                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,color: AppColor.happyblue, ) ),
                                      ],
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          ),
                          SizedBox(width: 4.w,),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 150.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 4.w,),
                          CircleAvatar(
                            radius: 25.h,
                            backgroundColor: Colors.grey,
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
                                    child: Text("kdjkgjkjdk",
                                        style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, ) ),
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
                                        Icon(Icons.control_point_duplicate, size: 14.w,color: AppColor.happyblue,),
                                        SizedBox(width: 3.w,),
                                        Text("5.0",
                                            style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', fontWeight: FontWeight.bold,color: AppColor.happyblue, ) ),
                                      ],
                                    ),
                                  ),
                                ),


                              ],
                            ),
                          ),
                          SizedBox(width: 4.w,),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),


    );
  }
}