import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:daycus/screen/specificMissionPage/MissionParticipatePage.dart';
import 'package:daycus/core/app_text.dart';



TextStyle _hintStyleGray = TextStyle(color: Colors.grey, fontSize: 17);
TextStyle _hintStyleBlack = TextStyle(color: Colors.grey, fontSize: 17);

TextStyle _hintStyle = _hintStyleGray;

class SpecificMissionPage extends StatefulWidget {
  SpecificMissionPage({
    Key? key,
    required this.topimage,
    required this.progress,
    required this.title,
    required this.duration,
    required this.totaluser,
    required this.certifi_user,
    required this.downimage,
    required this.content,
    required this.rules,
    required this.mission_id,
    this.onTap,

  }) : super(key: key);

  final String mission_id;
  final String topimage;
  final String progress;
  final String title;
  final String duration;
  final int totaluser;
  final int certifi_user;
  final String downimage;
  final String content;
  final String rules;
  final onTap;

  @override
  State<SpecificMissionPage> createState() => _SpecificMissionPageState();
}

class _SpecificMissionPageState extends State<SpecificMissionPage> {
  var f = NumberFormat('###,###,###,###');

  @override
  dispose() async {
    super.dispose();
    _basicMoney = 10000;
    _basicText = "${_basicMoney*(_rewardPercent+100)/100} 원";
    _rewardCalculResert = _basicText;
  }

  @override
  Widget build(BuildContext context) {

    List rules_list = widget.rules.split("\\n");
    int rules_list_cnt = rules_list.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: null),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              child: Column(
                children: [
                  Container(
                    width: 412.w,
                    height: 280.h,
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      image: DecorationImage(
                          image: AssetImage('assets/image/specificmissionpage/${widget.topimage}.png') ,
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Image.asset('assets/image/specificmissionpage/${widget.progress}.png' ),
                  SizedBox(height: 10.h,),

                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 8.w,),
                        Text(widget.title,style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h,),

                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 8.w,),
                        // 모집기간 > 미션기간
                        Text("미션기간",style: TextStyle(color: Colors. grey, fontSize: 15.sp, fontFamily: 'korean') ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5.h,),

                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 8.w,),
                        Text(widget.duration,style: TextStyle(fontSize: 18.sp, fontFamily: 'korean') ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15.h,),

            Container(
              width: 412.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppColor.grey2,
              ),
            ),

            Container(
              width: 300.w,
              height: 22.h,
              margin: EdgeInsets.only(top: 15.h, left: 24.w),
              decoration: BoxDecoration(
                color: AppColor.happyblue,
                borderRadius: BorderRadius.circular(5),
              ),
            ),

            SizedBox(height: 4.h,),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Row(
                    children: [
                      SizedBox(width: 24.w,),
                      Text("${f.format(widget.totaluser)}명",style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      Text(' 참여중',style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean',) ),
                    ],
                  ),

                  Row(
                    children: [
                      Text("${f.format(widget.certifi_user)}명",style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      Text(' 인증',style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean',) ),
                      SizedBox(width: 24.w,),
                    ],
                  ),

                ],
              ),
            ),

            SizedBox(height: 15.h,),

            Container(
              width: 412.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppColor.grey2,
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(28.w, 20.h, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text('예상 리워드',style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h,),
                  Text('자신이 걸 리워드를 입력하세요',style: TextStyle(fontSize: 15.sp, fontFamily: 'korean') ),
                  SizedBox(height: 15.h,),

                ],
              ),
            ),




            // 예상 리워드
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 항상 '원'이 떴으면 좋겠는데
                Row(
                  children: [
                    SizedBox(width: 25.w,),

                    SizedBox(
                      width: 150.w, height: 30.h,
                      // '미션 참여 금액' 아래의 텍스트 박스
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          setState(() {
                            _rewardCalculResert = _rewardCalcul(text, _rewardPercent);
                            if (_rewardCalculResert != _basicText){
                              _hintStyle = _hintStyleBlack;}
                            else { _hintStyle = _hintStyleGray;}
                          });
                        },
                        textAlignVertical: TextAlignVertical.bottom, textAlign: TextAlign.center,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            // 이거 왜 회색으로 안바뀔까요 ㅜㅜ
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          hintText: "$_basicMoney 원", hintStyle: _hintStyle,
                        ),
                      ),
                    ),
                  ],
                ),


                Icon(Icons.arrow_forward_sharp, color: Colors.black,),

                Row(
                  children: [
                    Container(
                      width: 150.w, height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1.w, color: Colors.grey),
                      ),
                      child: Text(_rewardCalculResert, style: _hintStyle, textAlign: TextAlign.center,),
                    ),
                    SizedBox(width: 25.w,),
                  ],
                )


              ],
            ),





            SizedBox(height: 15.h,),

            Container(
              width: 412.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppColor.grey2,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(26.w, 20.h, 26.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    child: Row(
                      children: [
                        Text('미션 내용',style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h,),
                  Text('${widget.content}',style: TextStyle(fontSize: 15.sp, fontFamily: 'korean') ),
                ],
              ),
            ),

            SizedBox(height: 15.h,),

            Container(
              child: Column(
                children: [
                  Container(
                    width: 412.w,
                    height: 280.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/image/specificmissionpage/${widget.downimage}.png') ,
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15.h,),

            Container(
              width: 412.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppColor.grey2,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(28.w, 20.h, 28.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('미션 참여방법',style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  SizedBox(height: 20.h,),
                  // 역슬레쉬 n 적용
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: rules_list_cnt,

                    itemBuilder: (_, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              widget.rules.split("\\n")[index],
                              style: TextStyle(fontSize: 16.sp, fontFamily: 'korean',) ),
                          
                          // 맨 마지막 SizedBox는 빼기
                          if (index < rules_list_cnt-1)
                            SizedBox(height: 5.h,),
                        ],
                      );
                    },

                  ),

                ],
              ),
            ),

            SizedBox(height: 30.h,),




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
              child:TextButton(onPressed: (){
                if (widget.progress == "donebutton"){
                  Fluttertoast.showToast(msg: "미션 모집기간이 아닙니다.");
                }
                else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MissionParticipatePage(
                        topimage: 'missionparticipate_image',
                        //average reward도 데이터베이스에서 끌고오기
                        mission_id: widget.mission_id,
                        title: widget.title, duration: widget.duration, totaluser: widget.totaluser, avgreward: 3000)),
                  );
                }
              }, child: Text('미션 참여하기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),
    );
  }
}



//Spacer()


// 리워드 계산기에 대한 변수 및 함수
double _rewardPercent = 10;
double _basicMoney = 10000;
String _basicText = "${_basicMoney*(_rewardPercent+100)/100} 원";
String _rewardCalculResert = _basicText;

_rewardCalcul(String? money, double percent){
  if (money==null){
    return _basicText;}
  else{
    try{
      double money_int = double.parse(money);
      // 소숫점 몇쨋자리 이런 기준이 필요함.
      return "${money_int*(percent+100)/100}원";
    }catch(e){
      print(e);
      return _basicText;
    }
  }
}
