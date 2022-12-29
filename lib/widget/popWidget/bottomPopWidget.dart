
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

IconData icons = Icons.camera_alt;
Widget bottomPopWidget(
    BuildContext context,
    onPressed1, onPressed2,
    String title1, String title2,
    IconData icon1, icon2,
    ) {
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
                icon: Icon(icon1, size: 30.sp, color: Colors.black,),
                onPressed: onPressed1,
                label: Text(title1, style: TextStyle(fontSize: 17.sp, color: Colors.black),),
              ),
              TextButton.icon(
                icon: Icon(icon2, size: 30.sp, color: Colors.black,),
                onPressed: onPressed2,
                label: Text(title2, style: TextStyle(fontSize: 17.sp, color: Colors.black),),
              )
            ],
          )
        ],
      )
  );
}