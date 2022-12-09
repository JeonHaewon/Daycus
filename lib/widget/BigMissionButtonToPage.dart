import 'package:flutter/material.dart';
import 'package:daycus/widget/bigmissionbutton.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/screen/specificMissionPage/SpecificMissionPage.dart';
import 'package:daycus/core/app_text.dart';

class BigMissionButtonToPage extends StatelessWidget {
  const BigMissionButtonToPage({
    Key? key,
    required this.i,
    required this.data,
  }) : super(key: key);

  final int i;
  final List<dynamic> data;

  @override
  Widget build(BuildContext context) {
    return BigMissionButton(
      title: data[i]['title'],
      totalUser: int.parse(data[i]['total_user']),
      image: data[i]['image'] ?? 'mission1',
      certifiUser:int.parse(data[i]['certifi_user']),
      duration:int.parse(data[i]['term']),

      onTap: SpecificMissionPage(
        mission_id: data[i]['mission_id'],
        topimage: data[i]['image'] ?? 'topimage1',
        progress:data[i]['start_date']==null ? (data[i]['next_start_date']==null ? "donebutton" : "comeonbutton") : "ingbutton",
        title : data[i]['title'],
        duration: data[i]['start_date']==null ? (data[i]['next_start_date']==null ? comingSoonString : '${data[i]['next_start_date']} ~ ${data[i]['next_end_date']}') : '${data[i]['start_date']} ~ ${data[i]['end_date']}',
        totaluser: int.parse(data[i]['total_user']), certifi_user: int.parse(data[i]['certifi_user']), downimage: 'downimage1',
        content: data[i]['content'],
        rules: data[i]['rules'],
      ),

    );
  }
}
