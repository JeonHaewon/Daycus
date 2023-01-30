import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MissionModify extends StatefulWidget {
  const MissionModify({Key? key}) : super(key: key);

  @override
  State<MissionModify> createState() => _MissionModifyState();
}

class _MissionModifyState extends State<MissionModify> {


  int all_mission_cnt = all_missions==null ? 0 : all_missions.length;
  int index = 0;

  final TextEditingController missionContentCtrl = TextEditingController();
  final TextEditingController missionRuleCtrl = TextEditingController();
  final TextEditingController missionNoticeCtrl = TextEditingController();


  _setText(){
    missionRuleCtrl.text = all_missions[index]['rules'];
    missionContentCtrl.text = all_missions[index]['content'];
    missionNoticeCtrl.text = all_missions[index]['notice'] ?? "";
  }

  @override
  void initState() {
    super.initState();
    index = all_mission_cnt-1;
    _setText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("미션 수정 페이지"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        if (index==0){
                          Fluttertoast.showToast(msg: "처음입니다");
                        }else {
                          index -= 1;
                          _setText();
                        }
                      });

                    }, child: Text("이전")),

                SizedBox(width: 20,),

                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        if (all_mission_cnt-1 == index){
                          Fluttertoast.showToast(msg: "마지막입니다");
                        }else {
                          index += 1;
                          _setText();
                        }
                      });
                    }, child: Text("다음")),
              ],
            ),

            Container(
                color: Colors.grey[200],
                child: Text("index : ${index}")),

            SizedBox(height: 10,),

            Container(
              color: Colors.grey[200],
                child: Text("제목 : ${all_missions[index]['title']}")),

            SizedBox(height: 10,),

            Container(
                color: Colors.grey[200],
                child: Text("기간 : ${all_missions[index]['start_date']} ~ ${all_missions[index]['end_date']}")),

            SizedBox(height: 10,),

            Container(
              margin: EdgeInsets.all(20),
              color: Colors.grey[200],
                child: Text("미션 내용 : ${all_missions[index]['content']}")),


            Container(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                controller: missionContentCtrl,
              ),
            ),

            SizedBox(height: 10,),

            Container(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                maxLines: 5,
                controller: missionRuleCtrl,
              ),
            ),

            Container(
                margin: EdgeInsets.all(20),
              color: Colors.grey[200],
                child: Text("미션 안내 : ${all_missions[index]['rules']}")),

            SizedBox(height: 10,),

            // Container(
            //     margin: EdgeInsets.all(20),
            //     color: Colors.grey[200],
            //     child: Text("미션 내용 : ${all_missions[index]['content']}")),



            Container(
                margin: EdgeInsets.all(20),
                color: Colors.grey[200],
                child: Text("미션 notice : ${all_missions[index]['notice']}")),

            Container(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                maxLines: 5,
                controller: missionNoticeCtrl,
              ),
            ),

            SizedBox(height: 10,),


            ElevatedButton(
                onPressed: (){
                  update_request(
                      "UPDATE missions SET content = '${missionContentCtrl.text.trim()}', notice = '${missionNoticeCtrl.text.trim()}', rules = '${missionRuleCtrl.text.trim()}' WHERE (mission_id = '${all_missions[index]['mission_id']}');",
                      "미션 정보를 수정하였습니다");
                }, child: Text("업데이트")),




          ],
        ),
      ),
    );
  }
}
