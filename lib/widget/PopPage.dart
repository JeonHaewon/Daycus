import 'package:flutter/material.dart';

//late ScrollController _scrollController = ScrollController();
SizedBox _sizedBox = SizedBox(height: 10,);

Future<dynamic> PopPage(BuildContext context, Widget content,
    String check, String cancel) {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<TextEditingController> ctrls =
  [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];

  const _hintStyle = TextStyle(color: Colors.grey);

  return showDialog(
    context: context,
    builder: (BuildContext btx){
      return AlertDialog(
        scrollable: true,
        content: content,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 취소 버튼
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                    // 사진 취소(삭제) 필요
                  },
                  child: Text(cancel, )),

              TextButton(
                  onPressed: () {
                    // 사진 저장 후 인증으로 인정!!
                  },
                  child: Text(check, )),
            ],
          ),
        ],
      );
    },
  );


}