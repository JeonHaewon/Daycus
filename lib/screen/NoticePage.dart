import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class NoticePage extends StatelessWidget {
  const NoticePage({Key? key}) : super(key: key);

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
        title: Text('알림',
            style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [



            SizedBox(height: 10.h,),

            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (_, index) {
                  return Column(
                    children: [

                      Notice(profileimage: "d", freindName: "퇴근퇴근", check: false, content: "하루 물 3잔 마시기 미션에 초대하셨습니다", onTap: NoticePage()),
                      Notice(profileimage: "d", freindName: "퇴근퇴근", check: false, content: "친구요청을 보냈습니다", onTap: NoticePage()),

                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 10.h,),





          ],
        ),






      ),


    );
  }
}



class Notice extends StatelessWidget {
  Notice({
    Key? key,
    required this.profileimage,
    required this.freindName,
    required this.content,
    required this.check,
    this.onTap,
  }) : super(key: key);

  final String profileimage;
  final String freindName;
  final String content;
  final bool check;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => onTap),
        );
      },
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              CircleAvatar(
                radius: 16.w,
                backgroundImage : profileimage!=null
                  ? AssetImage("assets/image/non_profile.png",)
                  : AssetImage("assets/image/non_profile.png"),
              ),

              SizedBox(width: 6.w,),

              Container(
                width: 290.w,
                //height: 10.h,
                child: Text("${freindName} 님이 ${content}",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',)),
              ),

              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                    color: check==false ? Colors.red : AppColor.background,
                    shape: BoxShape.circle
                ),
              ),

            ],
          ),
        ),
      ),

    );
  }
}





// InkWell(
//   onTap: () {
//
//   },
//   child: Container(
//     width: double.infinity,
//     child: Padding(
//       padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 10.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//
//
//
//           CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png",), radius: 16.w,),
//
//           SizedBox(width: 6.w,),
//
//           Container(
//             width: 290.w,
//             //height: 10.h,
//             child: Text("퇴근퇴근 님이 하루 물 3잔 마시기 미션에 초대하셨습니다",style: TextStyle(fontSize: 12.sp, fontFamily: 'korean',)),
//           ),
//
//           Container(
//             width: 8.w,
//             height: 8.h,
//             decoration: BoxDecoration(
//               color: Colors.red,
//               shape: BoxShape.circle
//
//             ),
//           ),
//
//         ],
//       ),
//     ),
//   ),
//
// ),
