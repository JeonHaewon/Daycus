import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:daycus/backend/UserDatabase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../backend/Api.dart';
import 'dart:convert';
class NoticeSetting extends StatefulWidget {
  const NoticeSetting({Key? key}) : super(key: key);

  @override
  State<NoticeSetting> createState() => _NoticeSettingState();
}

class _NoticeSettingState extends State<NoticeSetting> {


  @override
  Widget build(BuildContext context) {

    update_terms_market(value) async {
      try{
        var check = value == true ? 1 : 0;
        var update_res = await http.post(Uri.parse(API.update), body: {
          'update_sql': "UPDATE DayCus.user_table SET terms_market = '${check.toString()}' WHERE (user_email = '${user_data['user_email']}')",
        });

        if (update_res.statusCode == 200) {
          print("출력 : ${update_res.body}");
          var resLogin = jsonDecode(update_res.body);
          if (resLogin['success'] == true) {
            user_data['terms_market'] = value.toString();
            return true;
          } else {
            return false;
          }
        }
      } catch (e) {
        print(e.toString());
        //Fluttertoast.showToast(msg: e.toString());
        return false;
      }
    }

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('알림 설정',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [


                  SettingEachButtonCheck(
                    title: "미션 ",
                    subtitle: "(신규 미션 안내, 관심 미션 안내 등)",
                    value: isChecked[0],
                    onTap: (){
                    },
                    onChanged: (value){
                      setState(() {
                        isChecked[0] = value;
                        isModified = value;
                      });
                    },//
                  ),

                  Container(
                    height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                  ),

                  SettingEachButtonCheck(
                    title: "인증 ",
                    subtitle: "(인증 기한 안내, 인증 알림 안내 등)",
                    value: isChecked[1],
                    onTap: (){
                    },
                    onChanged: (value){
                      setState(() {
                        isChecked[1] = value;
                      });
                    },
                  ),

                  Container(
                    height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
                  ),


                  // SettingEachButtonCheck(
                  //   title: "광고 ",
                  //   subtitle: "(금주의 미션 안내 등)",
                  //   value: isChecked[2],
                  //   onTap: (){
                  //   },
                  //   onChanged: (value){
                  //     setState(() {
                  //       isChecked[2] = value;
                  //     });
                  //   },
                  // ),
                  //
                  // Container(
                  //   height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
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
              child:TextButton(
                  onPressed: () async {
                    bool? success = await update_terms_market(isModified);
                    if (success == true){
                      Fluttertoast.showToast(msg: "알림 설정이 수정되었습니다.");
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(msg: "다시 시도해주세요.");
                    }
                  },
                  child: Text('수정하기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),
    );
  }
}



var isModified;

var thing = int.parse(user_data['terms_market']);
casting(){
  if (thing==1){
    return true;
  }
  else{return false;}
}

List<bool> isChecked = [casting(), true];

// 각 버튼
class SettingEachButtonCheck extends StatelessWidget {
  SettingEachButtonCheck({
    Key? key,
    required this.title,
    required this.value,
    this.onTap,
    this.onChanged,
    this.subtitle = "",



  }) : super(key: key);

  final String title;
  final bool value;
  final String subtitle;
  final onTap;
  final onChanged;

  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black,
                ),),
              Text(subtitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.black,
                ),)

            ],
          ),

          Switch(
            // 디자인 조정 해야함.
            activeColor: AppColor.happyblue,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
