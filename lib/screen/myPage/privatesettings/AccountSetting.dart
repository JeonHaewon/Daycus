import 'dart:convert';

import 'package:daycus/core/app_text.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../backend/Api.dart';

var current_date_var = null;

class AccountSetting extends StatefulWidget {
  AccountSetting({Key? key}) : super(key: key);



  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {

  String selected_date = user_data['user_birth'] ?? nullBirthdayString;

  TextStyle _hintTextStyle = TextStyle(color: Colors.grey,fontSize: 16.sp, fontWeight: FontWeight.w400);

  update_information_name() async {
    try{
      var update_res = await http.post(Uri.parse(API.update), body: {
      'update_sql': "UPDATE DayCus.user_table SET user_name = '${nameCtrl.text.trim()}' WHERE (user_email = '${user_data['user_email']}')",
      });

      if (update_res.statusCode == 200) {
      print("출력 : ${update_res.body}");
      var resLogin = jsonDecode(update_res.body);
      if (resLogin['success'] == true) {
        user_data['user_name'] = nameCtrl.text;
      print("이름 변경이 성공적으로 반영되었습니다");
      //Fluttertoast.showToast(msg: "성공적으로 반영되었습니다");

        return true;


      } else {
        return false;
      // 이름을 바꿀 수 없는 상황?
      }
      }
    } catch (e) {
    print(e.toString());
    //Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }
  update_information_birth() async {
    try{
      var update_res = await http.post(Uri.parse(API.update), body: {
        'update_sql': "UPDATE DayCus.user_table SET user_birth = '${selected_date}' WHERE (user_email = '${user_data['user_email']}')",
      });

      if (update_res.statusCode == 200) {
        print("출력 : ${update_res.body}");
        var resLogin = jsonDecode(update_res.body);
        if (resLogin['success'] == true) {
          user_data['user_birth'] = selected_date;
          print("생일 수정이 성공적으로 반영되었습니다");
          //Fluttertoast.showToast(msg: "성공적으로 반영되었습니다");
          return true;
        } else {
          //Fluttertoast.showToast(msg: "다시 시도해주세요");
          // 생년월일을 바꿀 수 없는 상황?
          return false;
        }
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void success_upload(){
    Fluttertoast.showToast(msg: "성공적으로 반영되었습니다");

    // 사용자 정보 지우기, dispose하면 에러뜸.
    setState(() {
      nameCtrl.clear();
      birthCtrl.clear();
    } );

    // 설정 다 하고 나가기
    Navigator.pop(context);

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
                  SizedBox(
                    width: 340.w,
                    child: TextFormField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: '이름 : ${user_data['user_name']}',
                        hintText: '수정할 이름을 입력하세요',
                        labelStyle: _hintTextStyle,
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
                  ),



                  SizedBox(height: 20.h,),
                  Stack(
                    alignment: Alignment.topLeft,
                    children: [

                      TextButton(
                          onPressed: () async {
                            String tmp = await _pickDateDialog(context);
                            setState(() {
                              selected_date = tmp;
                            });
                          },
                          child: Container(
                            width: 600.w, height: 65.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 1.w, color: Colors.grey),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //SizedBox(height: 19.h,),
                                Text("   $selected_date",
                                    style: TextStyle(color: Colors.black54, fontSize: 16.5.sp, fontFamily: 'korean', )
                                   ),
                              ],
                            ),
                          )),

                      Positioned(
                        left: 18,
                        child: Container(
                          width: 60.w, height: 28.h,
                          decoration: BoxDecoration(
                              color: AppColor.background),
                          child: Text("생년월일",style: TextStyle(color: Colors.grey,fontSize: 14.sp, fontWeight: FontWeight.w400)
                            , textAlign: TextAlign.center, ),
                        ),
                      ),

                    ],
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
                  onPressed: () async {
                    bool is_change_birth = (user_data['user_birth'] != selected_date);
                    bool is_change_name = (nameCtrl.text.trim().length > 0);

                    bool sucess = false;

                    print("state : $is_change_name, $is_change_birth");

                    // 변경사항이 없을 때
                    if (is_change_name==false && is_change_birth==false){
                      Fluttertoast.showToast(msg: "변경사항이 없습니다.");
                    }
                    // 변경 사항이 있는 경우
                    else {
                      if (is_change_birth){
                        sucess = await update_information_birth();}

                      if (is_change_name){
                        sucess = await update_information_name();}

                      // true로 살아남으면 성공했다는 메세지가 뜸.
                      if (sucess) {
                        success_upload();

                      } else {
                        Fluttertoast.showToast(msg: "다시 시도해주세요");
                      }
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

_pickDateDialog(BuildContext context) async {
  final initialDate = user_data['user_birth']==null
    // 하임 1221 : 원래 설정한 생일이 있으면 그게 제일 먼저 뜸
      ? DateTime.now() : DateTime.parse(user_data['user_birth']);
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(DateTime.now().year - 50),
    lastDate: DateTime(DateTime.now().year + 3),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColor.happyblue,
          ),
        ),
        child: child!,
      );
    },
  );

  if (pickedDate == null) {
    if (current_date_var==null) {
      return nullBirthdayString;
    }else {
      return current_date_var;
    }
  }

    current_date_var = DateFormat('yyyy-MM-dd').format(pickedDate);
    return current_date_var;
  }







