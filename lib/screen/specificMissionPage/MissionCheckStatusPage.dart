import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';
import 'package:intl/intl.dart';


class MissionCheckStatusPage extends StatelessWidget {
  MissionCheckStatusPage({
    Key? key,
    required this.do_mission_data,
    required this.mission_data,
    this.onTap,
  }) : super(key: key);
  final onTap;
  final do_mission_data;
  final mission_data;

  var f = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {

    String title = mission_data['title'];
    String duration = '${mission_data['start_date']} ~ ${mission_data['end_date']}';
    int totaluser = int.parse(mission_data['total_user']);
    int certifiuser = int.parse(mission_data['certifi_user']);

    // 크기 안맞아서 변경
    // height 35.h > 35.w, sp 15.sp > 14.sp
    double _height = 35.w;
    double _sp = 14.sp;
    double _width = 35.w;

    double _betweenWidth = 9.w;
    int _oneWeek = 7;

    print(do_mission_data);

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
                              Text("좋은 습관 만들기까지 16일",style: TextStyle(  fontSize: 16.w, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                              SizedBox(height: 10.w,),

                              Container(
                                height: _height * 2 + _betweenWidth,
                                width: _width * _oneWeek + _betweenWidth * _oneWeek + 30.w,
                                child: ListView.builder(
                                  itemCount: 2,
                                  itemBuilder: (_, index_i){
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
                                                  itemBuilder: (_,index_j) {
                                                    return Row(
                                                      children: [
                                                        SizedBox(
                                                          height: _height,
                                                          width: _width,
                                                          child: do_mission_data['${index_j+1}']==null
                                                              ? YetMissionBlock(i: index_i, j: index_j, sp: _sp) : DoneMissionBlock(i: index_j, j: index_j, sp: _sp)
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


                              /*
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  // build list, row로 구현 !
                                  // null일 경우 회식, 사진이 있을 경우 파란색.



                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){showAlertDialog(context);},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('1',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('2',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('3',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('4',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('5',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('6',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
                                        child: Text('X',style: TextStyle(color: Colors.red, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
                                        child: Text('X',style: TextStyle(color: Colors.red, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                ],
                              ),



                              SizedBox(height: 6.h,),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('7',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('8',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('9',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('10',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
                                        child: Text('11',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
                                        child: Text('12',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: (){},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
                                        child: Text('13',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                  SizedBox(
                                    height: _height,
                                    width: _width,
                                    child:TextButton(
                                        onPressed: () {},
                                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
                                        child: Text('14',style: TextStyle(color: Colors.white, fontSize: _sp, fontFamily: 'korean', ) ) ),
                                  ),

                                ],
                              ),*/

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),






                  SizedBox(height: 40.h,),


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
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.pink[50])),
        child: Text('X',style: TextStyle(color: Colors.red, fontSize: sp, fontFamily: 'korean', ) )
    );
  }
}

class DoneMissionBlock extends StatelessWidget {
  DoneMissionBlock({
    Key? key,
    required this.i,
    required this.j,
    required this.sp,
  }) : super(key: key);

  final int i;
  final int j;
  final double sp;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){showAlertDialog(context);},
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
        child: Text(((i+1)*(j+1)).toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
    );
  }
}

class YetMissionBlock extends StatelessWidget {
  const YetMissionBlock({
    Key? key,
    required this.i,
    required this.j,
    required this.sp,
  }) : super(key: key);

  final int i;
  final int j;
  final double sp;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){},
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey[400])),
        child: Text(((i+1)*(j+1)).toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) ) );
  }
}












