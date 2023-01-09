import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../../../backend/Api.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/UserDatabase.dart';

final TextEditingController current_password = TextEditingController();
final TextEditingController want_password = TextEditingController();
final TextEditingController want_real_password = TextEditingController();
var cur;
var want;
var want_real;
var md5v_cur;
var md5v_want;
var cur_pass;

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

update_information_password() async {
  try{
    var update_res = await http.post(Uri.parse(API.update), body: {
      'update_sql': "UPDATE DayCus.user_table SET user_password = '${generateMd5(want)}' WHERE (user_email = '${user_data['user_email']}')",
    });

    if (update_res.statusCode == 200) {
      print("출력 : ${update_res.body}");
      var resLogin = jsonDecode(update_res.body);
      if (resLogin['success'] == true) {
        user_data['user_password'] = generateMd5(want);
        print("성공적으로 반영되었습니다");
        Fluttertoast.showToast(msg: "성공적으로 반영되었습니다");

      } else {
        // 이름을 바꿀 수 없는 상황?
      }
    }
  } catch (e) {
    print(e.toString());
    Fluttertoast.showToast(msg: e.toString());
  }
}

class PasswordSetting extends StatefulWidget {
  PasswordSetting({Key? key}) : super(key: key);

  @override
  State<PasswordSetting> createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSetting> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    current_password.clear();
    want_real_password.clear();
    want_password.clear();
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
        title: Text('비밀번호 설정',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              Padding(
                padding: EdgeInsets.fromLTRB(30.w, 30.h, 30.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    TextFormField(
                      decoration: InputDecoration(
                        //filled: true,
                        labelText: '현재 비밀번호 입력',
                      ),
                      controller: current_password,
                      obscureText: true,
                      onChanged: (current_password){
                        cur = current_password.trim();
                      },
                    ),

                    SizedBox(height: 20.h,),

                    TextFormField(
                      decoration: InputDecoration(
                        //filled: true,
                        labelText: '새로운 비밀번호 입력',
                      ),
                      controller: want_password,
                      obscureText: true,
                      onChanged: (want_password){
                        want = want_password.trim();
                      },
                    ),

                    SizedBox(height: 20.h,),

                    TextFormField(
                      decoration: InputDecoration(
                        //filled: true,
                        labelText: '새로운 비밀번호 재입력',
                      ),
                      controller: want_real_password,
                      obscureText: true,
                      onChanged: (want_real_password){
                        want_real = want_real_password.trim();
                      },
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColor.happyblue,
        child: Row(
          children: [
            SizedBox(
              height: 70.h,
              width: 412.w,
              child: TextButton(onPressed: () {
                String cur_pass = user_data['user_password'];
                if (cur_pass == generateMd5(cur)){
                  if (want == want_real) {
                    update_information_password();
                    Fluttertoast.showToast(msg: "성공적으로 변경되었습니다!");
                  }
                  else {
                    Fluttertoast.showToast(msg: "새로운 비밀번호 입력이 일치하지 않습니다.");
                  }
                }else{
                  Fluttertoast.showToast(msg: "현재 비밀번호와 틀린 비밀번호입니다!");
                }
              }, child: Text('완료',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),

    );
  }
}

