import 'package:daycus/backend/login/login.dart';
import 'package:flutter/material.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';
import 'labelPage/LabelingMission.dart';


class LabelPage extends StatefulWidget {
  const LabelPage({Key? key}) : super(key: key);

  static final storage = FlutterSecureStorage();

  @override
  State<LabelPage> createState() => _LabelPageState();
}

class _LabelPageState extends State<LabelPage> {

  var i;

  void initState() {
    i = Random().nextInt(all_missions.length);
  }

  @override
  Widget build(BuildContext context) {

    // Future<void> refresh() async {
    //   await afterLogin();
    //   setState(() { });
    // };

    //int extraindex = -2;
    return LabelingMission(
      content: all_missions[i]['content'],
      label_category: all_missions[i]['label_category'],
      folder: all_missions[i]['image_locate'],
      title: all_missions[i]['title'],
      rule: all_missions[i]['rules'],
    );
  }
}

