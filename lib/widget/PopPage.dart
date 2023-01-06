import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//late ScrollController _scrollController = ScrollController();
SizedBox _sizedBox = SizedBox(height: 10,);

Future<dynamic> PopPage(String? title, BuildContext context, Widget content,
    String check, String? cancel, onPressed, onPressedCancel) {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<TextEditingController> ctrls =
  [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];

  const _hintStyle = TextStyle(color: Colors.grey);

  return showDialog(
    context: context,
    builder: (BuildContext btx){
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(28))),
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 4.h,),

            if (title!=null)
              Text(title, style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),),

            if (title!=null)
              SizedBox(height: 15.sp,),


            Container(
              height: 1.h, color: Colors.grey[200],
            ),

            SizedBox(height: 20.h,),

            content,
          ],),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 취소 버튼, 함수가 없으면 그냥 꺼짐
              if (cancel!=null && onPressedCancel==null)
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text(cancel, style: TextStyle(color: Colors.grey[600]),)),

              // 취소 버튼, 함수가 있을때
              if (cancel!=null && onPressedCancel!=null)
                TextButton(
                    onPressed: onPressedCancel,
                    child: Text(cancel, style: TextStyle(color: Colors.grey[600]),)),

              TextButton(
                  onPressed: onPressed,
                  child: Text("${check}  ", style: TextStyle(color: Colors.indigo),)),
            ],
          ),
        ],
      );
    },
  );


}