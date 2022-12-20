import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/widget/missionfeedbutton.dart';



class MissionFeed extends StatelessWidget {
  const MissionFeed({Key? key}) : super(key: key);

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
        title: Text('미션피드',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [


            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 350.w,
                    height:350.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Padding(
                          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("2022. 10",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                              SizedBox(height: 12.h,),

                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    MissionFeedButton(title :"일찍 일어나기", duration:"10.01 ~ 10.10",image: "feedimage" ,percent: 90, reward: 1200, onTap: (){},),
                                    MissionFeedButton(title :"일찍 일어나기", duration:"10.01 ~ 10.10",image: "feedimage" ,percent: 90, reward: 1200, onTap: (){},),
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

            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 350.w,
                    height:600.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Padding(
                          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("2022. 09",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                              SizedBox(height: 12.h,),

                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    MissionFeedButton(title :"일찍 일어나기", duration:"10.01 ~ 10.10",image: "feedimage" ,percent: 90, reward: 1200, onTap: (){},),
                                    MissionFeedButton(title :"일찍 일어나기", duration:"10.01 ~ 10.10",image: "feedimage" ,percent: 90, reward: 1200, onTap: (){},),
                                  ],
                                ),
                              ),

                              SizedBox(height: 12.h,),

                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    MissionFeedButton(title :"일찍 일어나기", duration:"10.01 ~ 10.10",image: "feedimage" ,percent: 90, reward: 1200, onTap: (){},),
                                    Container(
                                      width: 150.w,
                                      height: 195.h,
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
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 20.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 350.w,
                    height:340.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Padding(
                          padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("2022. 08",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                              SizedBox(height: 12.h,),

                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    MissionFeedButton(title :"일찍 일어나기", duration:"10.01 ~ 10.10",image: "feedimage" ,percent: 90, reward: 1200, onTap: (){},),
                                    MissionFeedButton(title :"일찍 일어나기", duration:"10.01 ~ 10.10",image: "feedimage" ,percent: 90, reward: 1200, onTap: (){},),
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


            SizedBox(height: 20.h,),








          ],
        ),
      ),
    );
  }
}