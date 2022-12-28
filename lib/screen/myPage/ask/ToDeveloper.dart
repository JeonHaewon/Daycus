import 'dart:io';

import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/core/app_text.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';



class ToDeveloper extends StatefulWidget {
  ToDeveloper({Key? key}) : super(key: key);

  @override
  State<ToDeveloper> createState() => _ToDeveloperState();
}

class _ToDeveloperState extends State<ToDeveloper> {
  File? errorImage = null;

  @override
  Widget build(BuildContext context) {

    String adminEmail = 'haim1121.dgist@gmail.com';

    final TextEditingController supportCtrl = TextEditingController();
    TextStyle _hintStyle = TextStyle(fontSize: 15.sp, color: Colors.grey);

    void _sendEmail(texting) async {
      final Email email = Email(
        body: texting,
        subject: '[DayCus 앱 사용 중 문제가 생겨 문의드립니다]',
        recipients: [adminEmail],
        cc: [],
        bcc: [],
        attachmentPaths: [],
        isHTML: false,
      );

      try {
        await FlutterEmailSender.send(email);
        Fluttertoast.showToast(msg: "메일 전송이 완료되었습니다 !");
      } catch (error) {
        String title = "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\n${adminEmail}";
        String message = "";
        Fluttertoast.showToast(msg: title);
      }
    }

    Widget toDeveloperBottomSheet() {
      return Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton.icon(
                    icon: Icon(Icons.email, size: 30.sp, color: Colors.black,),
                    onPressed: () async {
                      _sendEmail(supportCtrl.text.trim());
                      Navigator.pop(context);
                    },
                    label: Text('메일 문의', style: TextStyle(fontSize: 17.sp, color: Colors.black),),
                  ),
                  TextButton.icon(
                    icon: Icon(Icons.info_rounded, size: 30.sp, color: Colors.black,),
                    onPressed: () async {
                      if (supportCtrl.text.trim()!='') {
                        // 'yy/MM/dd - HH:mm:ss'
                        String now = await NowTime("yyyy-MM-dd HH:mm:ss");
                        print(now);
                        print(last_error.replaceAll("'", ""));
                        update_request(
                            "INSERT INTO to_developer (content, error_message, user_email, datetime) VALUES ('${supportCtrl.text.trim()}', '${last_error.replaceAll("'", "`")}', '${user_data['user_email']}', '${now}');",
                            toDeveloperSuccess);
                        Navigator.pop(context);
                        
                        // 적은 내용이 없을 때
                      } else{
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: "문의 내용을 입력해주세요");
                      }
                    },
                    label: Text('일반 문의', style: TextStyle(fontSize: 17.sp, color: Colors.black),),
                  )
                ],
              )
            ],
          )
      );
    }



    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text('개발자에게 문의하기',
            style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 25.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  TextField(
                    controller: supportCtrl,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "어떤 문제가 발생했나요?",
                      hintStyle: _hintStyle,
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),

                  SizedBox(height: 30.h,),


                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 30.h,
                      width: 100.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          textStyle: TextStyle(fontSize: 12.sp),
                        ),

                        onPressed: () {
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("이미지 첨부",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h,),

                  if (errorImage==null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: (){

                        },
                        child: Container(
                          padding: EdgeInsets.all(15.sp),
                          width: double.infinity,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(bottom: BorderSide(color: Colors.grey, width: 2.sp)),
                          ),
                          child: Text("선택된 이미지가 없습니다. \n( * 메일 문의 시 이미지 첨부가 취소됩니다 )",
                            style: _hintStyle,
                        ),
                      ),
                    ),),




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
              child:TextButton(onPressed: () {
                showModalBottomSheet(context: context, builder: ((builder) => toDeveloperBottomSheet()));
              }, child: Text('문의하기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),
    );
  }
}