import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';
import 'package:intl/intl.dart';


class MissionCheckStatusPage extends StatelessWidget {
  MissionCheckStatusPage({
    Key? key,
    required this.title,
    required this.duration,
    required this.totaluser,
    required this.certifiuser,

    this.onTap,
  }) : super(key: key);
  
  final String title;
  final String duration;
  final int totaluser;
  final int certifiuser;
  final onTap;

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
            
            
            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(title,style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  SizedBox(height: 25.h,),
                  Text("미션기간",style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', color: Colors.grey) ),
                  SizedBox(height: 5.h,),
                  Text(duration,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean') ),
                  SizedBox(height: 15.h,),


                  Container(
                    width: 500.w,
                    height: 175.h,
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

                        Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("인증 현황",style: TextStyle( color: AppColor.happyblue, fontSize: 14.sp, fontFamily: 'korean') ),
                              SizedBox(height: 5.h,),
                              Text("좋은 습관 만들기까지 16일",style: TextStyle(  fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                              SizedBox(height: 12.h,),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){showAlertDialog(context);},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('1',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('2',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('3',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('4',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('5',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('6',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
                                        child: Text('X',style: TextStyle(color: Colors.red, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
                                        child: Text('X',style: TextStyle(color: Colors.red, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                ],
                              ),


                              SizedBox(height: 6.h,),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('7',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('8',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('9',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('10',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('11',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
                                        child: Text('12',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
                                        child: Text('13',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: 35.h,
                                    width: 35.w,
                                    child:TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
                                        child: Text('14',style: TextStyle(color: Colors.white, fontSize: 15.sp, fontFamily: 'korean', ) ) ),
                                  ),

                                ],
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),



                  SizedBox(height: 20.h,),


                  Text("전체 결과",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  SizedBox(height: 8.h,),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("참여인원",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean') ),
                      Text("${f.format(totaluser)} 명",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                    ],
                  ),
                  
                  SizedBox(height: 5.h,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("인증 횟수",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean') ),
                      Text("${f.format(certifiuser)} 회",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                    ],
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
              child:TextButton(onPressed: (){}, child: Text('오늘 미션 인증하기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),

    );
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context, // user must tap button!
      builder: (BuildContext context) {
        return BackdropFilter(
          child: AlertDialog(
            title: Text("내가 인증한 사진",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
            content: InkWell(
              onTap: (){Navigator.of(context).pop();},
              child:Image.asset('assets/image/specificmissionpage/downimage1.png', fit: BoxFit.fill),
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







}









