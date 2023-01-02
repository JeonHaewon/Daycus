import 'package:daycus/core/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//late ScrollController _scrollController = ScrollController();
SizedBox _sizedBox = SizedBox(height: 10,);

Future<dynamic> PopPage(String? title, BuildContext context, Widget content,
    String check, String? cancel, onPressed) {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<TextEditingController> ctrls =
  [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];

  const _hintStyle = TextStyle(color: Colors.grey);

  return showDialog(
    context: context,
    builder: (BuildContext btx){
      return AlertDialog(
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title!=null)
              Text(title, style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),),

            if (title!=null)
              SizedBox(height: 15.sp,),

            content,
          ],),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 취소 버튼
              if (cancel!=null)
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                      // 사진 취소(삭제) 필요
                    },
                    child: Text(cancel, style: TextStyle(color: Colors.indigo),)),

              TextButton(
                  onPressed: onPressed,
                  child: Text("${check}  ", style: TextStyle(color: AppColor.happyblue),)),
            ],
          ),
        ],
      );
    },
  );


}