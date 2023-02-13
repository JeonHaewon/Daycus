import 'package:daycus/backend/UpdateRequest.dart';
import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:daycus/screen/myPage/settings/NoticeSetting.dart';

import '../../../backend/UserDatabase.dart';

class PublicSetting extends StatefulWidget {
  const PublicSetting({Key? key}) : super(key: key);

  @override
  State<PublicSetting> createState() => _PublicSettingState();
}

List<bool> _isChecked = [true];

class _PublicSettingState extends State<PublicSetting> {

  void dispose() {
    super.dispose();
    update_request("update user_table set Nickname_public = '${_isChecked[0] ? 1 : 0}' where user_email = '${user_data['user_email']}'", null);
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
        title: Text('공개범위',
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
                    title: "닉네임 공개",
                    subtitle: "(주간 랭킹에서 닉네임이 공개됩니다)",
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