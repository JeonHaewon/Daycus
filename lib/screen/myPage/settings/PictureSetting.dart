import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/myPage/settings/NoticeSetting.dart';

class PictureSetting extends StatefulWidget {
  const PictureSetting({Key? key}) : super(key: key);

  @override
  State<PictureSetting> createState() => _PictureSettingState();
}

List<bool> _isChecked = [true];

class _PictureSettingState extends State<PictureSetting> {
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
        title: Text('사진 설정',
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
                    title: "사진 자동 저장",
                    value: isChecked[0],
                    onTap: (){
                    },
                    onChanged: (value){
                      setState(() {
                        isChecked[0] = value;
                      });
                    },
                  ),

                  Container(
                    height: 1.h,color: Colors.grey[400], margin: EdgeInsets.all(5),
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