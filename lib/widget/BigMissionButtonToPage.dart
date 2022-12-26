import 'package:daycus/screen/specificMissionPage/MissionCheckStatusPage.dart';
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
      image: data[i]['thumbnail'] ?? 'mission1.png',
      certifiUser:int.parse(data[i]['certifi_user']),
      duration:int.parse(data[i]['term']),

      // 이거 category별로 했을 때에는 이렇게 하면 안됨.
      // 그러므로 최적화 시 동작을 다시 생각해봐야할듯.
      // 카테고리
      onTap: data[i]['now_user_do'] != null ?

      MissionCheckStatusPage(
        mission_index: i,
          do_mission_data: do_mission[data[i]['now_user_do']],
          mission_data: data[i]) :

      SpecificMissionPage(
        mission_id: data[i]['mission_id'],
        topimage: data[i]['thumbnail'] ?? 'topimage1.png',
        progress: data[i]['start_date']==null ? (data[i]['next_start_date']==null ? "willbutton" : "comeonbutton") : "ingbutton",
        title : data[i]['title'],
        duration: data[i]['start_date']==null ? (data[i]['next_start_date']==null ? comingSoonString : '${data[i]['next_start_date']} ~ ${data[i]['next_end_date']}') : '${data[i]['start_date']} ~ ${data[i]['end_date']}',
        totaluser: int.parse(data[i]['total_user']), certifi_user: int.parse(data[i]['certifi_user']), downimage: 'downimage1',
        content: data[i]['content'],
        rules: data[i]['rules'],
        rewardPercent: data[i]['reward_percent'],
      ),

    );
  }
}
