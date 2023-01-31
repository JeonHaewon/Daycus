import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/core/constant.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:daycus/screen/specificMissionPage/MissionParticipatePage.dart';
import 'package:daycus/core/app_text.dart';
import 'package:flutter_svg/flutter_svg.dart';



TextStyle _hintStyleGray = TextStyle(color: Colors.grey, fontSize: 15.sp);
TextStyle _hintStyleBlack = TextStyle(color: Colors.black, fontSize: 15.sp);

TextStyle _hintStyle = _hintStyleGray;

class SpecificMissionPage extends StatefulWidget {
  SpecificMissionPage({
    Key? key,
    required this.mission_data,

    // 아래 변수들이 위의 mission_data로 받아올 수 있는 것들이므로, 최적화가 필요함.
    required this.startDate,
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
    required this.rewardPercent,
    this.onTap,
    this.buttonTitle : true,

  }) : super(key: key);

  final mission_data;
  final String? startDate;
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
  final bool buttonTitle;
  final String rewardPercent;
  final onTap;


  @override
  State<SpecificMissionPage> createState() => _SpecificMissionPageState();
}

double _basicMoney = init_reward;
String _basicText = "";
double rewardPercent = 100;
String _rewardCalculResert = _basicText;
String progress = "defaultbutton";

class _SpecificMissionPageState extends State<SpecificMissionPage> {
  var f = NumberFormat('###,###,###,###');

  int timeDiffer = 15;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncMethod();
    });
  }




  _asyncMethod() async {

    rewardPercent = double.parse(widget.rewardPercent);
    _basicText = "${init_reward*(rewardPercent)/100+14} ${rewardName}";
    _rewardCalculResert = _basicText;

    String now_time = await NowTime("yyyyMMdd");
    //print("duration ${widget.startDate}");

    // start date null인 경우 -1, 날짜가 지나가면 참가할 수 없음.
     timeDiffer = widget.startDate==null ? 15 : DateTime.parse(now_time)
         .difference((DateTime.parse(widget.startDate!))).inDays + 1;

     print("timeDiffer : ${timeDiffer}");

     // 완료, 모집중, 모집 예정 사진 불러오는 곳. 기본 설정은 "모집 예정"
     setState(() {
       if (widget.startDate==null){
         progress = "willbutton";}
       else if(timeDiffer<0){
         progress = "comeonbutton";}
       else if(timeDiffer>14){
         progress = "donebutton";}
       else{
         progress = "ingbutton";}
     });


  }

  @override
  void dispose() {
    super.dispose();
      _basicMoney = init_reward;
      _basicText = "${_basicMoney*(rewardPercent+100)/100} ${rewardName}";
      _rewardCalculResert = _basicText;
      progress = "defaultbutton";
  }

  @override
  Widget build(BuildContext context) {

    double rewardPercent = double.parse(widget.rewardPercent);

    List rules_list = widget.rules.split("/");
    int rules_list_cnt = rules_list.length;


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        //actions: [IconButton(icon: Icon(Icons.share), onPressed: null),],
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
                          image: AssetImage('assets/image/thumbnail/${widget.topimage}') ,
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

                  SvgPicture.asset('assets/image/specificmissionpage/${progress}.svg' ),
                  SizedBox(height: 10.h,),

                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 8.w,),

                        Container(
                            width: 360.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.clip,
                                      maxLines: 3,
                                      text: TextSpan(
                                          text: widget.title,
                                          style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
                                    )
                                ),
                              ],
                            )
                        ),

                        //Text(widget.title,style: TextStyle(fontSize: 25.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

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


            // Container(
            //   width: 300.w,
            //   height: 22.h,
            //   margin: EdgeInsets.only(top: 15.h, left: 24.w),
            //   decoration: BoxDecoration(
            //     color: AppColor.happyblue,
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            // ),
            //
            // SizedBox(height: 4.h,),
            //
            // Container(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //
            //       Row(
            //         children: [
            //           SizedBox(width: 24.w,),
            //           Text("${f.format(widget.totaluser)}명",style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
            //           Text(' 참여중',style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean',) ),
            //         ],
            //       ),
            //
            //       Row(
            //         children: [
            //           Text("${f.format(widget.certifi_user)}명",style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
            //           Text(' 인증',style: TextStyle(color: Colors. grey,fontSize: 15.sp, fontFamily: 'korean',) ),
            //           SizedBox(width: 24.w,),
            //         ],
            //       ),
            //
            //     ],
            //   ),
            // ),
            //
            // SizedBox(height: 15.h,),
            //
            // Container(
            //   width: 412.w,
            //   height: 8.h,
            //   decoration: BoxDecoration(
            //     color: AppColor.grey2,
            //   ),
            // ),


            Padding(
              padding: EdgeInsets.fromLTRB(28.w, 20.h, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text('예상 ${rewardName}',style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h,),
                  Text('자신이 투자할 ${rewardName}를 입력하세요',style: TextStyle(fontSize: 15.sp, fontFamily: 'korean') ),
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
                        style: TextStyle(fontSize: 15.sp),
                        keyboardType: TextInputType.number,
                        onChanged: (text){
                          setState(() {
                            _rewardCalculResert = _rewardCalcul(text, rewardPercent, _basicText);
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
                          hintText: "$_basicMoney ${rewardName}", hintStyle: _hintStyle,
                        ),
                      ),
                    ),
                  ],
                ),


                Icon(Icons.arrow_forward_sharp, color: Colors.black,),


                Column(

                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 150.w, height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(width: 1.w, color: Colors.grey),
                      ),
                      child: Text(_rewardCalculResert, style: TextStyle(color: Colors.black,fontSize: 15.sp,), textAlign: TextAlign.center,),
                    ),
                  ],
                ),

                SizedBox(width: 25.w,),



              ],
            ),



            Padding(
              padding: EdgeInsets.fromLTRB(228.w, 5.h, 0, 0),
              child: Column(
                children: [
                  Text('※ 투자 ${rewardName}의 150% + 14 (2주) ',style: TextStyle(fontSize: 10.sp, fontFamily: 'korean', color: AppColor.happyblue) ),
                ],
              ),
            ),


            Padding(
              padding: EdgeInsets.fromLTRB(25.w, 10.h, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black), //default
                          children: [
                            TextSpan(text: '※ 한 미션에 투자할 수 있는 최대 ${rewardName}는 ',style: TextStyle(fontSize: 11.sp, fontFamily: 'korean') ),
                            TextSpan(text: '${limit_bet_reward}${rewardName}', style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', color: AppColor.happyblue, ) ),
                            TextSpan(text: ' 입니다',style: TextStyle(fontSize: 11.sp, fontFamily: 'korean') ),
                          ])
                  ),
                  //Text('※ 한 미션에 투자할 수 있는 최대 ${rewardName}는 ${limit_bet_reward}${rewardName}입니다',style: TextStyle(fontSize: 11.sp, fontFamily: 'korean') ),

                  RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black), //default
                          children: [
                            TextSpan(text: '※ 미션 실패시 ',style: TextStyle(fontSize: 11.sp, fontFamily: 'korean') ),
                            TextSpan(text: '(투자한 ${rewardName}/2 + 미션 진행률 x 14) ${rewardName}', style: TextStyle(fontSize: 11.sp, fontFamily: 'korean', color: AppColor.happyblue, ) ),
                            TextSpan(text: '를 반환합니다',style: TextStyle(fontSize: 11.sp, fontFamily: 'korean') ),
                          ])
                  ),

                  //Text('※ 미션 실패시 (투자한 ${rewardName}/2 + 미션 진행률 x 14) ${rewardName}를 반환합니다',style: TextStyle(fontSize: 11.sp, fontFamily: 'korean') ),
                  //Text('※ 미션 성공시 14${rewardName}를 추가로 지급합니다',style: TextStyle(fontSize: 11.sp, fontFamily: 'korean') ),
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

                  //Text('미션 참여방법',style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
                  Text('세부사항',style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (rules_list_cnt > 1)
                              Text('${index+1}.  ', style: TextStyle(fontWeight: FontWeight.bold),),
                              SizedBox(
                                width: 330.w,
                                  child: Text('${rules_list[index]}')),
                            ],
                          ),

                          SizedBox(height: 5.h,),

                          // RichText(
                          //   overflow: TextOverflow.ellipsis,
                          //   maxLines: 1,
                          //   text: TextSpan(
                          //       style: TextStyle(color: Colors.black), //default
                          //       children: [
                          //         if (rules_list_cnt >1)
                          //         TextSpan(text: '${index+1}. '),
                          //         TextSpan(text: '${rules_list[index]}'),
                          //       ])
                          //
                          // ),
                        ],
                      );
                      // return Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //         widget.rules.split("\\n")[index],
                      //         style: TextStyle(fontSize: 16.sp, fontFamily: 'korean',) ),
                      //
                      //     // 맨 마지막 SizedBox는 빼기
                      //     if (index < rules_list_cnt-1)
                      //       SizedBox(height: 5.h,),
                      //   ],
                      // );
                    },

                  ),

                ],
              ),
            ),

            //SizedBox(height: 15.h,),

            // Container(
            //   width: 412.w,
            //   height: 8.h,
            //   decoration: BoxDecoration(
            //     color: AppColor.grey2,
            //   ),
            // ),

            // Padding(
            // padding: EdgeInsets.fromLTRB(28.w, 20.h, 28.w, 0),
            // child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //
            //       // Text('인증 방법',style: TextStyle(fontSize: 18.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
            //
            //       // SizedBox(height: 20.h,),
            //
            //       // Text("1. 미션 종료 후(15일차)에 반드시 '정산하기' 버튼을 눌러주세요!",
            //       //     style: TextStyle(fontSize: 11.5.sp, fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.black) ),
            //       // SizedBox(height: 3.h,),
            //       // Text("15일차에 '정산하기' 버튼을 눌러 포인트를 지급받을 수 있습니다. 단, 14일차에 인증을 하는 경우 인증 이후 바로 정산이 가능합니다.",
            //       //     style: TextStyle(fontSize: 10.sp, fontFamily: 'korean',  color: Colors.grey) ),
            //       // SizedBox(height: 2.h,),
            //       // Text("※ 미션 종료 후 2주 내에 정산을 받지 않을 경우 리워드를 지급받지 못합니다.",
            //       //     style: TextStyle(fontSize: 8.sp, fontFamily: 'korean',  color: Colors.grey) ),
            //
            //
            //       //SizedBox(height: 15.h,),
            //       // Text("1.  주 ${widget.mission_data['frequency']}회, ${widget.mission_data['term']}주간, 총 ${int.parse(widget.mission_data['frequency'])*int.parse(widget.mission_data['term'])}회!",
            //       //     style: TextStyle(color: Colors.black) ),
            //       // SizedBox(height: 3.h,),
            //       // Text("미션 기간 ${widget.mission_data['term']}주 동안 주 ${widget.mission_data['frequency']}일, 하루 1번 인증 사진을 올리셔야 합니다.",
            //       //     style: TextStyle(fontSize: 12.sp,  color: Colors.grey) ),
            //       //
            //       //
            //       // SizedBox(height: 15.h,),
            //       // Text(widget.mission_data['notice']==null
            //       //     ? "2.  미션에 알맞은 사진을 올려주세요!"
            //       //     : "2.  " + (widget.mission_data['notice'].split("\n")[0]).toString(),
            //       //     style: TextStyle( color: Colors.black) ),
            //       // SizedBox(height: 3.h,),
            //       // if (widget.mission_data['notice']!=null)
            //       //   Text("${(widget.mission_data['notice'].split("\n")[1]).toString()}",
            //       //       style: TextStyle(fontSize: 12.sp,  color: Colors.grey) ),
            //       //
            //       // if (widget.mission_data['notice']==null)
            //       //   Text("${widget.mission_data['content']}",
            //       //       style: TextStyle(fontSize: 12.sp,  color: Colors.grey) ),
            //       //
            //       // if (widget.mission_data['certify_tool']=='camera' || widget.mission_data['certify_tool']=='gallery')
            //       //   Column(
            //       //     crossAxisAlignment: CrossAxisAlignment.start,
            //       //     children: [
            //       //       SizedBox(height: 15.h,),
            //       //       Text("3.  미션 인증 시 사람이 나오지 않게 주의해주세요!",
            //       //           style: TextStyle(  color: Colors.black) ),
            //       //       SizedBox(height: 3.h,),
            //       //       Text("개인정보 보호를 위해 본인을 포함하여 특정 인물을 나타낼 수 있는 모습이 사진에 나타나지 않도록 주의해주세요.",
            //       //           style: TextStyle(fontSize: 12.sp, color: Colors.grey) ),
            //       //     ],
            //       //   ),
            //
            //     ],
            //   ),
            // ),


            SizedBox(height: 30.h,),




          ],
        ),
      ),

      bottomNavigationBar: widget.buttonTitle==true ? BottomAppBar(
        color: AppColor.happyblue,
        child: Row(
          children: [
            SizedBox(
              height: 70.h,
              width: 412.w,
              child: TextButton(onPressed: widget.onTap ?? (){
                if (timeDiffer>14){
                  Fluttertoast.showToast(msg: "미션 모집기간이 아닙니다.");
                }
                else if (int.parse(widget.mission_data['frequency'])*int.parse(widget.mission_data['term']) > 15-timeDiffer){
                  Fluttertoast.showToast(msg: cantParticipateString);
                }
                else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MissionParticipatePage(
                        remainDate: 14-timeDiffer,
                        topimage: widget.topimage,
                        //average reward도 데이터베이스에서 끌고오기
                        mission_id: widget.mission_id,
                        title: widget.title, duration: widget.duration, totaluser: widget.totaluser, avgreward: int.parse(widget.mission_data['average']))),
                  );
                }
              }, child: Text("미션 참여하기",
                style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ) : null,
    );
  }
}



//Spacer()


// 리워드 계산기에 대한 변수 및 함수



_rewardCalcul(String? money, double percent, String basicText){
  if (money==null){
    return basicText;}
  else{
    try{
      double money_int = double.parse(money);
      // if (money_int == limit_bet_reward){
      //   return "최대입니다";
      // }
      if (money_int > limit_bet_reward){
        return "${limit_bet_reward} 이상 투자할 수 없습니다";
      }
      // 소숫점 몇쨋자리 이런 기준이 필요함.
      return "${money_int*(percent)/100+14} ${rewardName}";
    }catch(e){
      print(e);
      return basicText;
    }
  }
}
