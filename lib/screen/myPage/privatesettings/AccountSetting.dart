import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../backend/Api.dart';


class AccountSetting extends StatefulWidget {
  AccountSetting({Key? key}) : super(key: key);

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {

  update_information() async {
    try{
      var update_res = await http.post(Uri.parse(API.update), body: {
      'update_sql': "UPDATE DayCus.user_table SET user_name = '${nameCtrl.text.trim()}' WHERE (user_email = '${user_data['user_email']}')",
      });

      if (update_res.statusCode == 200) {
      print("출력 : ${update_res.body}");
      var resLogin = jsonDecode(update_res.body);
      if (resLogin['success'] == true) {
        user_data['user_name'] = nameCtrl.text;
      print("성공적으로 반영되었습니다");
      Fluttertoast.showToast(msg: "성공적으로 반영되었습니다");

      // 사용자 정보 지우기
      setState(() {
      nameCtrl.clear();
      birthCtrl.clear();
      } );

      } else {
      // 이름을 바꿀 수 없는 상황?
      }
      }
    } catch (e) {
    print(e.toString());
    Fluttertoast.showToast(msg: e.toString());
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController birthCtrl = TextEditingController();

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
        title: Text('계정 설정',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 25.h, left: 30.w, right: 30.w),
        child: Column(
          children: [

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Icon(Icons.account_circle_rounded, size: 150,),
                TextButton(onPressed: (){},
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.grey),
                    child: Icon(Icons.camera_alt, size: 20, color: Colors.black,),
                    //margin: EdgeInsets.all(15),
                    padding: EdgeInsets.all(3),
                  ),)
              ],
            ),

            SizedBox(height: 10.h,),

            Text("${user_data['user_name']} 님",style: TextStyle(fontSize: 20.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

            SizedBox(height: 20.h,),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: '이름 : ${user_data['user_name']}',
                      hintText: '수정할 이름을 입력하세요',
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1.w, color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1.w, color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),







                  // SizedBox(height: 20.h,),


                  // TextField(
                  //   decoration: InputDecoration(
                  //     labelText: '이메일',
                  //     hintText: 'email',
                  //     labelStyle: TextStyle(color: Colors.grey),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //       borderSide: BorderSide(width: 1.w, color: Colors.grey),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //       borderSide: BorderSide(width: 1.w, color: Colors.grey),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //     ),
                  //   ),
                  //   keyboardType: TextInputType.emailAddress,
                  // ),

                  SizedBox(height: 20.h,),


                  // 생년월일 입력 라이브러리
                  // https://pub.dev/packages/flutter_holo_date_picker
                  TextFormField(
                    controller: birthCtrl,
                    decoration: InputDecoration(
                      labelText: '생년월일',
                      hintText: '생년월일을 입력해주세요',
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1.w, color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1.w, color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ],
              )

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
                // 이거 생일 있을때랑 이름 있을때랑 각각 구분해서 잘 넣기.
                // 팝업 띄우기, 규칙 만들기 (중복허용?)
                  onPressed: (){
                    if (nameCtrl.text.trim().length > 0){
                      update_information();
                    } else {
                      Fluttertoast.showToast(msg: "변경사항이 없습니다");
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