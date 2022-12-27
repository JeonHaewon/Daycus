import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class ToDeveloper extends StatelessWidget {
  const ToDeveloper({Key? key}) : super(key: key);

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