import 'dart:io';

import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UploadImage.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/widget/popWidget/bottomPopWidget.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';



class ToDeveloper extends StatefulWidget {
  ToDeveloper({Key? key}) : super(key: key);

  @override
  State<ToDeveloper> createState() => _ToDeveloperState();
}

class _ToDeveloperState extends State<ToDeveloper> {

  final TextEditingController supportCtrl = TextEditingController();
  File? errorImage = null;
  String? errorImageName = null;
  String? sorce = null;

  @override
  Widget build(BuildContext context) {

    to_developer() async {
      String todayString = await NowTime('yyyyMMddHHmmss');
      errorImageName = "${todayString.substring(0,8)}_${todayString.substring(8,14)}_${user_data['user_id']}";
      File? image = null;

      showModalBottomSheet(context: context, builder: ((builder) => bottomPopWidget(
          context,

          // 카메라
          () async {
            Navigator.pop(context);
            image = await getImage(errorImageName!, ImageSource.camera);
            sorce = "camera";
            setState(() {
              errorImage = image;
            });
          },

          // 갤러리
          () async {
            Navigator.pop(context);
            image = await getImage(errorImageName!, ImageSource.gallery);
            sorce = "gallery";
            setState(() {
              errorImage = image;
            });
          },
          "카메라", "갤러리",
          Icons.camera_alt, Icons.photo)));
    }


    TextStyle _hintStyle = TextStyle(fontSize: 15.sp, color: Colors.grey);

    general_to_developer() async {
      if (supportCtrl.text.trim()!='') {
        //Navigator.pop(context);
        bool success1 = false; bool success2 = false;

        // 사진이 있을 때와 없을 때 sql 문을 조정하기 위한 코드
        if(errorImage==null){errorImageName = null;}
        else{errorImageName = "'" + errorImageName! + "'";}

        // 'yy/MM/dd - HH:mm:ss'
        String now = await NowTime("yyyy-MM-dd HH:mm:ss");
        print(now);
        print(last_error.replaceAll("'", ""));

        if (errorImage!=null) {
          success1 = await uploadImage(errorImageName!, "to_developer", sorce!, null, null);
        } else{success1 = true;
        }

        // 이미지 업로드에 성공할 시
        if (success1){
          success2 = await update_request(
              "INSERT INTO to_developer (content, error_message, user_email, datetime, error_image) VALUES ('${supportCtrl.text.trim()}', '${last_error.replaceAll("'", "`")}', '${user_data['user_email']}', '${now}', ${errorImageName});",
              toDeveloperSuccess);
        }

        // 문의가 완료됨
        if (success1 && success2){
          Navigator.pop(context); // 개발자 페이지 나가기
        } else {
          Fluttertoast.showToast(msg: "다시 시도해주세요");
        }

        // 적은 내용이 없을 때
      } else{
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "문의 내용을 입력해주세요");
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
            style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: EdgeInsets.fromLTRB(30.w, 25.h, 30.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Align(
                  //   child: Text("개발자 이메일 : ${adminEmail}",
                  //       style: TextStyle(fontWeight: FontWeight.bold)),
                  //   alignment: Alignment.centerLeft,
                  // ),



                  //SizedBox(height: 20.h,),

                  // Container(
                  //   width: 400.w,
                  //   height: 83.h,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.grey.withOpacity(0.1),
                  //         spreadRadius: 5,
                  //         blurRadius: 7,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //
                  //       Container(
                  //         padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //
                  //             Text("문의 종류",
                  //                 style: TextStyle(fontWeight: FontWeight.bold)),
                  //             SizedBox(height: 5.h,),
                  //
                  //             Text("• 메일 문의 : 답변을 받아야 하는 문의를 보내주세요",
                  //                 style: TextStyle(fontSize: 10.sp)),
                  //             Text("• 일반 문의 : 답변을 받지 않아도 되는 문의를 보내주세요(오류 신고 등)",
                  //                 style: TextStyle(fontSize: 10.sp)),
                  //
                  //
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),




                  SizedBox(height: 20.h,),

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

                  SizedBox(height: 10.h,),

                  // Text(" * Gmail 어플 이외에는 메일 문의가 어렵습니다 ",
                  //     style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold)),

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
                          to_developer();
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

                  if (errorImage!=null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("선택된 이미지", style: TextStyle(color: Colors.black),),
                    ),

                  if (errorImage!=null)
                    SizedBox(height: 5.h,),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: (){
                        to_developer();
                      },
                      child: Container(
                        padding: EdgeInsets.all(15.sp),
                        width: double.infinity,
                        height: (errorImage==null) ? 80.h : null,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(color: Colors.grey, width: 2.sp)),
                        ),
                        child: (errorImage==null)
                            ? Text("선택된 이미지가 없습니다.", style: _hintStyle,)
                            : Image.file(errorImage!),
                    ),
                  ),),

                  SizedBox(height: 10.h,),

                  // Text(" * 메일 문의 시 이미지 첨부가 취소됩니다 ",
                  //     style: TextStyle(color: Colors.black, fontSize: 12.sp, fontWeight: FontWeight.bold)),

                  SizedBox(height: 30.h,),




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
                general_to_developer();
                //showModalBottomSheet(context: context, builder: ((builder) => toDeveloperBottomSheet));
              }, child: Text('문의하기',style: TextStyle(color: Colors.white, fontSize: 20.sp, fontFamily: 'korean', ) ) ),
            ),
          ],
        ),
      ),
    );
  }
}