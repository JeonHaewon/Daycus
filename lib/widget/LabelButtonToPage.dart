import 'package:daycus/screen/labelPage/LabelingMission.dart';
import 'package:flutter/material.dart';
import 'package:daycus/widget/labelbutton.dart';

class LabelButtonToPage extends StatelessWidget {
  const LabelButtonToPage({
    Key? key,
    required this.i,
    required this.data,
  }) : super(key: key);

  final int i;
  final data;

  @override
  Widget build(BuildContext context) {
    // 이거 total User에서 total image로 바뀌어야할듯?
    return LabelButton(
        image: data[i]['image'] ?? 'mission1',
        title: data[i]['title'],
        // 하임 : duration 날짜 없을 경우 : ~주동안 > 진행예정으로 변경.
        duration: data[i]['start_date']==null ?
              "진행 예정" :
              '${data[i]['start_date'].toString().substring(5,)} ~ ${data[i]['end_date'].toString().substring(5,)}',
        totalUser: int.parse(data[i]['total_user']),
        myparticipation: 0,
      onTap: LabelingMission(title: data[i]['title'],
        rule: data[i]['rules'],),
    );
  }
}