import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MissionAddPage extends StatefulWidget {
  @override
  State<MissionAddPage> createState() => _MissionAddPage();

}

class _MissionAddPage extends State<MissionAddPage> {

  //final TextEditingController AddMissionCtrl = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController customMissionCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    customMissionCtrl.clear();
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
        title: Text('미션 추가',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 0),
              child: Column(
                children: [
                  Text("추가하고 싶은 \"나만의 미션\"이 있나요 ?", style: TextStyle(fontSize: 15.sp, fontFamily: 'korean',fontWeight: FontWeight.bold),),

                  SizedBox(height: 20.h,),


                  Container(
                    width: 400.w,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("여러분의 갓생을 위해 참여하고 싶은 미션이 있다면 아래에 적어주세요! 빠른 시간 내에 여러분의 의견을 반영하여 미션을 추가하겠습니다 :)\n",
                                  style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',) ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12.h,),


                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: customMissionCtrl,
                      maxLines: 6,
                      validator: (String? value){
                        if (value!.isEmpty) {
                          return '내용을 입력해주세요.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "추가하고 싶은 새로운 미션이 있나요?\n설명이 구체적일수록 좋습니다 !",
                        hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                        fillColor: Colors.white,
                        filled: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColor.happyblue),//<-- SEE HERE
                        ),
                      ),
                      cursorColor: AppColor.happyblue,
                    ),
                  ),


                  //SizedBox(height: 20.h,),

                  // ElevatedButton.icon(
                  //   onPressed: () { },
                  //   style: ElevatedButton.styleFrom(
                  //     primary: AppColor.happyblue,
                  //     onPrimary: Colors.white,
                  //     minimumSize: Size(120.w, 40.h),
                  //     textStyle: TextStyle(fontWeight: FontWeight.bold),
                  //   ),
                  //   icon: Icon(Icons.add, size: 18, color: Colors.white,),
                  //   label: Text("신청하기"),
                  // ),

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
              child: TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // 금주의 추천 미션 신청 완료
                      DateTime today = await NowTime(null);
                      bool success = await update_request(
                      "INSERT INTO to_developer (content, error_message, user_email, datetime, error_image) VALUES ('${customMissionCtrl.text.trim().replaceAll("'", "`")}', '추천 미션', '${user_data['user_email']}', '${today.toString().substring(0,23)}', null);",
                      null);
                      if (success){
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "미션 신청이 완료되었습니다.\n좋은 의견 감사합니다 :)");
                      }
                  }
                },
                child: Text('신청하기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) )
              ),
            ),
          ],
        ),
      ),


    );
  }
}