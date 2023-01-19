import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/Friend/FriendsMissonCheck.dart';


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



class AddFriend extends StatelessWidget {
  const AddFriend({Key? key}) : super(key: key);

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
                      //controller: ,
                      decoration: InputDecoration(
                          hintText: "추가하고 싶은 친구의 닉네임을 입력하세요",
                          hintStyle: TextStyle(fontFamily: 'korean',fontSize: 11.sp )
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w,),

                  IconButton(
                      icon: Icon(Icons.search),color: Colors.black,
                    onPressed: () { }
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
                  children: [


                    SizedBox(
                      width: 160.w,
                      height: 25.h,
                      child: FittedBox(
                        alignment: Alignment.center,
                        fit: BoxFit.contain,

                        child: Text("kdjkfjkjk",
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

                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("친구 요청",style: TextStyle(fontFamily: 'korean', fontSize: 10.sp) ),
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