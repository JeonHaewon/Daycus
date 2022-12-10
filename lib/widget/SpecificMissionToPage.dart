import 'package:daycus/screen/specificMissionPage/MissionCheckStatusPage.dart';
import 'package:flutter/material.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/screen/specificMissionPage/SpecificMissionPage.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/widget/missionbutton.dart';

class SpecificMissionToPage extends StatelessWidget {
  const SpecificMissionToPage({
    Key? key,
    required this.i,
  }) : super(key: key);

  final int i;

  @override
  Widget build(BuildContext context) {
    return MissionButton(
               title: all_missions[i]['title'],
               totalUser: int.parse(all_missions[i]['now_user']),
               image: 'missionbackground',

               // next 없음
               onTap: all_missions[i]['now_user_do'] != null ?

                MissionCheckStatusPage(
                   do_mission_data: do_mission[all_missions[i]['now_user_do']],
                    mission_data: all_missions[i])

             : SpecificMissionPage(mission_id: all_missions[i]['mission_id'],
                 topimage: all_missions[i]['image'] ?? 'topimage1',
                 progress:all_missions[i]['start_date']==null ? (all_missions[i]['next_start_date']==null ? "donebutton" : "comeonbutton") : "ingbutton",
                 title : all_missions[i]['title'],
                 duration: all_missions[i]['start_date']==null ? (all_missions[i]['next_start_date']==null ? comingSoonString : '${all_missions[i]['next_start_date']} ~ ${all_missions[i]['next_end_date']}') : '${all_missions[i]['start_date']} ~ ${all_missions[i]['end_date']}',
                 totaluser: int.parse(all_missions[i]['total_user']), certifi_user: int.parse(all_missions[i]['certifi_user']), downimage: 'downimage1',
                 content: all_missions[i]['content'],
                 rules: all_missions[i]['rules'],
             ),
    );


  }
}