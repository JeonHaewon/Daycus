import 'dart:io';
import 'dart:ui';

import 'package:daycus/backend/Api.dart';
import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/core/app_color.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;


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

File? image;

class _MissionCheckStatusPageState extends State<MissionCheckStatusPage> {

  // 하임 1220 : 미션 시작일로부터 지난 날짜 (초기화)
  int todayBlockCnt = 0;
  String todayString = "";

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
    DateTime now_time = await NowTime(null);
    todayString = DateFormat('yyyyMMdd').format(now_time);
    print("todayString : ${todayString}");
    print(now_time);
    //print("mission_data : ${widget.mission_data}");
    print("20"+widget.mission_data['start_date'].substring(2,10));

      setState(() {
        todayBlockCnt = now_time
            .difference((DateTime.parse("20"+widget.mission_data['start_date'].substring(2,10)))).inDays + 1;
        //print("time_diff : $time_diff");

        print(todayBlockCnt);

      });

  }

  // dart.io로 file 불러왔음. html로 불러야할지도

  final ImagePicker picker = ImagePicker();

  var f = NumberFormat('###,###,###,###');

  // 사진을 찍을 수 있도록
  Future getImage() async {
    // 갤러리 열기 : 성공
    //var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      image = File(pickedFile!.path);
    });
  }

  // 사진 업로드
  Future uploadImage(String pictureName) async {
    //var uri = Uri.parse("http://10.8.1.148/api_members/mission/upload.php");
    var uri = Uri.parse(API.imageUpload);
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = pictureName;
    var pic = await http.MultipartFile.fromPath("image", image!.path);
    request.files.add(pic);
    var response = await request.send();

    final result = await response.stream.bytesToString();
    print("message : $result");

    if (response.statusCode == 200) {
      print("image upload");

    } else {
      print("image not upload");
    }

  }

  @override
  Widget build(BuildContext context) {

    print("build :: ");

    int index_i = -1;
    int index_j = -1;

    String title = widget.mission_data['title'];
    String duration = '${widget.mission_data['start_date']} ~ ${widget.mission_data['end_date']}';
    int totaluser = int.parse(widget.mission_data['total_user']);
    int certifiuser = int.parse(widget.mission_data['certifi_user']);

    // 크기 안맞아서 변경
    // height 35.h > 35.w, sp 15.sp > 12.w
    double _height = 35.w;
    double _sp = 12.w;
    double _width = 35.w;

    double _betweenWidth = 9.w;
    int _oneWeek = 7;

    int i = widget.mission_index;
    int do_i = all_missions[i]['now_user_do'];

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
                              Text("좋은 습관 만들기까지 ${14-todayBlockCnt+1}일",style: TextStyle(  fontSize: 16.w, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
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
                                                    return Row(
                                                      children: [
                                                        SizedBox(
                                                          height: _height,
                                                          width: _width,
                                                          child: widget.do_mission_data['${date}']==null

                                                          // 아직 인증하지 않은 날짜 블럭, date+1 = 오늘 카운트
                                                              ? (todayBlockCnt <= date ?
                                                                  // 날짜가 지나지 않았으면
                                                                  YetMissionBlock(i: index_i, j: index_j, sp: _sp)
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
              child:TextButton(onPressed: () async {
                await getImage();

                setState(() async {
                  // 이름을 오늘 날짜, 미션 번호, domission 코드로 하기
                  // 실제 이미지 이름을 바꿔야합니다.
                  // 폴더를 미션별로 다르게 지정해서 넣어야합니다 (php)
                  // setstate 작동 안합니다 ^^^^^ > re-build 돼야함. 이거 왜 9임??? 숫자이상
                  await uploadImage("${widget.mission_data['mission_id']}_${todayString}_${user_data['user_id']}");
                  do_mission[do_i]["$todayBlockCnt"] = true;
                });
              }, child: Text('오늘 미션 인증하기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
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
        onPressed: (){showAlertDialog(context, image, date);},
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.happyblue)),
        child: Text(((i*7)+(j+1)).toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) )
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
        child: Text(((i*7)+(j+1)).toString(),style: TextStyle(color: Colors.white, fontSize: sp, fontFamily: 'korean', ) ) );
  }
}












