import 'package:flutter/material.dart';
import 'package:daycus/core/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabelPage extends StatelessWidget {
  const LabelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('미션인증',
            style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: null),
          IconButton(icon: Icon(Icons.notifications), onPressed: null),
          IconButton(icon: Icon(Icons.account_circle), onPressed: null)
        ],
        automaticallyImplyLeading: false,
      ),

      body: Text('dd'),
    );
  }
}