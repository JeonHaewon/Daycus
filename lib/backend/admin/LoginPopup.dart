import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../screen/LoginPageCustom.dart';
import '../login/login.dart';


class LoginPopup extends StatelessWidget {
  LoginPopup({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [

          
          TextButton(
            onPressed: (){
              showDialog(
                barrierDismissible: false,
                context: context, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    // 하임 : 내가 인증한 사진 > n일째 인증 사진으로 변경
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("중복 로그인 확인",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("기존에 로그인된 계정입니다.\n다른 기기에서 로그아웃하시겠습니까?",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean',) ),
                      ],
                    ),

                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                                Fluttertoast.showToast(msg: "다른 계정으로 로그인해주세요");
                              },
                              child: Text("취소", style: TextStyle(color: Colors.grey[600]),)
                          ),

                          TextButton(
                              onPressed: (){

                              }, //다른 기기에서 로그아웃하고 로그인
                              child: Text("확인", style: TextStyle(color: Colors.indigo),)
                          ),

                        ],
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              );
            },
            child: Text("중복 로그인을 하는 기기")
          ),

          TextButton(
              onPressed: (){
                showLoginAlertDialog_two(context);
              },
              child: Text("중복 로그인을 당하는 기기")
          ),


        ],
      ),
    );
  }
}


// void showLoginAlertDialog(BuildContext context) async {
//   return showDialog(
//     barrierDismissible: false,
//     context: context, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//           // 하임 : 내가 인증한 사진 > n일째 인증 사진으로 변경
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("중복 로그인 확인",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),
//
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("기존에 로그인된 계정입니다.\n다른 기기에서 로그아웃하시겠습니까?",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean',) ),
//             ],
//           ),
//
//         actions: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//
//               TextButton(
//                 onPressed: (){
//                   Navigator.pop(context);
//                   Fluttertoast.showToast(msg: "다른 계정으로 로그인해주세요");
//                 },
//                 child: Text("취소", style: TextStyle(color: Colors.grey[600]),)
//               ),
//
//               TextButton(
//                   onPressed: (){
//
//                   }, //다른 기기에서 로그아웃하고 로그인
//                   child: Text("확인", style: TextStyle(color: Colors.indigo),)
//               ),
//
//             ],
//           ),
//         ],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//       );
//     },
//   );
// }



void showLoginAlertDialog_two(BuildContext context) async {
  String result = await showDialog(
    barrierDismissible: false,
    context: context, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // 하임 : 내가 인증한 사진 > n일째 인증 사진으로 변경
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("중복 로그인 확인",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean', fontWeight: FontWeight.bold) ),

          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("다른 기기에서 로그인하여 로그아웃 되었습니다. 본인이 아니라면 재로그인 후 비밀번호를 변경해주세요.",style: TextStyle(fontSize: 16.sp, fontFamily: 'korean',) ),
          ],
        ),

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              
              TextButton(
                  onPressed: () async {
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_) => LoginPageCustom()), (
                            route) => false);
                    // 로그아웃처리한다.
                    await logout(true);
                  }, //로그인페이지로
                  child: Text("확인", style: TextStyle(color: Colors.indigo),)
              ),

            ],
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      );
    },
  );
}