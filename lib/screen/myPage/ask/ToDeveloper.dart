import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';




class ToDeveloper extends StatelessWidget {
  const ToDeveloper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void _sendEmail() async {
      final Email email = Email(
        body: '',
        subject: '[DayCus 앱 사용 중 문제가 생겨 문의드립니다.]',
        recipients: ['haim11217@naver.com', 'haim1121.dgist@gmail.com'],
        cc: [],
        bcc: [],
        attachmentPaths: [],
        isHTML: false,
      );

      try {
        await FlutterEmailSender.send(email);
        Fluttertoast.showToast(msg: "메일 전송이 완료되었습니다 !");
      } catch (error) {
        String title = "기본 메일 앱을 사용할 수 없기 때문에 앱에서 바로 문의를 전송하기 어려운 상황입니다.\n\n아래 이메일로 연락주시면 친절하게 답변해드릴게요 :)\n\nonionfamily.official@gmail.com";
        String message = "";
        Fluttertoast.showToast(msg: title);
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
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "Enter a message",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),

                  SizedBox(height: 8.h,),


                  SizedBox(
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



                  SizedBox(height: 20.h,),

                  InkWell(
                    onTap: () {
                      _sendEmail();
                    },
                    child: Container(
                      width: 250.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: AppColor.happyblue,
                      ),

                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("문의하기",style: TextStyle(fontFamily: 'korean', fontWeight: FontWeight.bold, color: Colors.white) ),
                          ],
                        ),

                      ),
                    ),
                  ),




                ],
              ),
            ),






          ],
        ),
      ),
    );
  }
}