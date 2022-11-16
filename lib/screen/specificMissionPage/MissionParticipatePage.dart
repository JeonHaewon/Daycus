import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class MissionParticipatePage extends StatelessWidget {
  MissionParticipatePage({
    Key? key,
    required this.topimage,
    required this.title,
    required this.duration,
    required this.totaluser,
    required this.avgreward,

    this.onTap,

  }) : super(key: key);

  final String topimage;
  final String title;
  final String duration;
  final int totaluser;
  final int avgreward;

  final onTap;

  final TextEditingController nameCtrl = TextEditingController();

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
                    height: 335.h,
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

            Padding(
              padding: EdgeInsets.fromLTRB(32.w, 20.h, 32.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Form(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("미션 참여 리워드", style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      Container(
                        height: 50.h,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.bottom,
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            hintText: " 0원",
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  )),

                  SizedBox(height: 15.h,),
                  Text('· 참여금이 높을수록 받는 리워드도 많아져요',style: TextStyle(fontSize: 16.sp, fontFamily: 'korean',) ),
                  SizedBox(height: 5.h,),

                  Text('· 리워드를 걸지 않고도 미션에 참여할 수 있어요',style: TextStyle(fontSize: 16.sp, fontFamily: 'korean',) ),

                ],
              ),
            ),



            SizedBox(height: 15.h,),

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
              child:TextButton(onPressed: (){}, child: Text('미션 시작하기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),
    );
  }
}