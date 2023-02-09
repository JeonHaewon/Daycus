import 'dart:math';

import 'package:daycus/backend/ImportData/doMissionImport.dart';
import 'package:daycus/backend/ImportData/importMissions.dart';
import 'package:daycus/backend/NowTime.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/admin/LoginPopup.dart';
import 'package:daycus/core/app_bottom.dart';
import 'package:daycus/screen/CheckConnection.dart';
import 'package:daycus/screen/LoginPageCustom.dart';
import 'package:daycus/screen/ReConnection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/Api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screen/Friend/FriendPage.dart';
import '../../screen/LoadingPage.dart';
import '../../screen/myPage/privatesettings/PrivateSettings.dart';
import '../../screen/specificMissionPage/MissionCheckStatusPage.dart';
import '../../widget/PopPage.dart';
import 'KeepLogin.dart';
import 'dart:convert';
import 'package:daycus/backend/UserDatabase.dart';
import '../../screen/temHomePage.dart';
import 'package:daycus/backend/ImportData/importElse.dart';

userLogin(String email, String password, bool reload, {bool auto = false}) async{
  try {
    print("1");
    var user_res = await http.post(
        Uri.parse(API.login),
        body: {
          'user_email' : email,
          'user_password' : password,
        });

    if (user_res.statusCode == 200) {
      print("출력 : ${user_res.body}");

      var resLogin = jsonDecode(user_res.body);
      if (resLogin['success'] == true) {
        //print("로그인에 성공하였습니다.");
        user_data = resLogin['userData'];

        if (user_data['register_date']==null){
          update_request(
              "UPDATE user_table SET register_date = '${DateTime.now()}' where user_email = '${user_data['user_email']}'",null
          );
          user_data['register_date'] = DateTime.now().toString();
        }
        print("${user_data['register_date']}");

        // 첫 로그인 시에만 인사해줌 - 앱을 나갔다 들어올때도 아래가 실행됨.
        if (reload==false && user_data['user_state']!='withdrawing'){
          DateTime today = await NowTime(null);
          print("today : ${today.toString().substring(0,10)}");

          if (user_data['last_login']!=null){
            if(user_data['last_login'].substring(0,10) != today.toString().substring(0,10)){
              // 추가 로그인 일수 플러스
              update_request(
                  "UPDATE user_table SET attendance = attendance + 1 where user_email = '${user_data['user_email']}'", null);
              user_data['attendance'] = (int.parse(user_data['attendance'])+1).toString();
              print("오늘 처음으로 출석하셨네요 !");
            }
          }

          // 마지막 로그인 업데이트
          update_request(
              "UPDATE user_table SET last_login='${today.toString().substring(0,22)}' where user_email = '${user_data['user_email']}'", null);


          Fluttertoast.showToast(msg: "안녕하세요, ${resLogin['userData']['user_name']}님 !");
          controller.currentBottomNavItemIndex.value = AppScreen.home;
        }


        return true;

      } else {
        if (reload){
          Fluttertoast.showToast(msg: "오류가 발생했습니다. 로그아웃 후 다시 로그인해주세요.");
        }
        else {
          // 계정이 없다는 멘트도 띄워야할듯?
          Fluttertoast.showToast(msg: "이메일 또는 비밀번호가 올바르지 않습니다.");
        }

        print("이메일 또는 비밀번호가 올바르지 않습니다.");

        return false;
      }
    }
  }
  catch (e) {
    print(e.toString());
    //Fluttertoast.showToast(msg: e.toString());

    return null;

  }
}

keepLogin (name, email, password, storage) async {
  // 로그인 유지
  // - 데이터 직렬화
  var login_infor = jsonEncode(
      KeepLogin("${name}",
          '${email}',
          '${password}'));

  // - 비밀 저장공간에 저장
  await storage.write(
    key: 'login',
    value: login_infor,
  );
}


afterLogin() async {

  level_update();

  // 검토 필요
  import_ranking();

  // done_mission 대입하기
  done_mission = await select_request(
      "select do_id, mission_id, mission_start, bet_reward, percent from Done_mission where user_email='${user_data['user_email']}' order by mission_start desc;",
      null,
      false);
  print("done_mission : ${done_mission}");

  // top ranking 불러오기
  topRankingList = await select_request(
      "select user_name, reward, Ranking, user_id, profile From user_table WHERE (1<=Ranking) AND (Ranking<=3) ORDER BY Ranking limit 3;",
      null,
      false);

  print("로그인에 성공하였습니다.");

  // 미션 불러오기
  await missionImport();
  // 카테고리별 미션 불러오기
  //await importMissionByCategory();
  // 하고있는 미션 불러오기
  await doMissionImport();

  missions_cnt = all_missions?.length;
  //print("미션 개수 : $missions_cnt");

  doMissionSave();
  // 백그라운드 실행
  // if (do_mission != null) {
  //   doMissionSave();
  // }

}

logout(bool reload) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // 유저 정보 삭제 - 어플 내
  if (!reload){
    update_request("update user_table set login_ing = 3 where user_email = '${user_data['user_email']}'", null);
    prefs.remove('${user_data['user_email']}_logincode');
  }
  user_data = null;
  all_missions = null;
  do_mission = null;

  await PrivateSettings.storage.delete(key: 'login');
}




// keep login - 유저 정보 들고오기
LoginAsyncMethod(storage, BuildContext context, bool reload) async {
  //Fluttertoast.showToast(msg: "LoginAsyncMethod");

  String connection = await checkConnectionStatus(context);
  if (connection=="ConnectivityResult.none"){
    Navigator.push(context, MaterialPageRoute(builder: (_) => ReConnection()));
  }
  else {
    //Fluttertoast.showToast(msg: "LoginAsyncMethod - else");
    dynamic userInfo = '';

    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    try {
      userInfo = await storage.read(key: 'login');
      print(userInfo);
    }catch (e){
    //Fluttertoast.showToast(msg: "error : ${e}");
    }

    //Fluttertoast.showToast(msg: "context ${context} && reload ${reload}");

    // 자동로그인이 필요한 경우, reload 시
    if ((userInfo != null && user_data == null) || reload) {
      //Fluttertoast.showToast(msg: "자동로그인이 필요한 경우");
      var userDecode = jsonDecode(userInfo);

      print(userDecode);

      await userLogin(
          userDecode['user_email'], userDecode['password'], reload, auto: true);
      //userLogin(userInfo['userName'], userInfo['password'], userInfo['user_email']);
      var dbcode = await get_logincode_db(user_data['user_email']);
      var pfcode = await get_logincode_pf();
      var invitationss = await select_request("select invitation from user_table where user_email = '${user_data['user_email']}'", null, true);
      var invitations = invitationss[0]['invitation'] ?? "{}";
      var invitation = jsonDecode(invitations);

      if (dbcode != pfcode){
        showLoginAlertDialog_two(context);
        return;
      }

      if (invitation.isNotEmpty){
        for (var item in invitation.keys) {
          PopPage(
            "미션에 초대되었습니다!",
            context,
            Column(
              children: [
                Text("'${item}님이 미션에 초대하셨습니다! 자세한 미션을 확인해보시겠습니까?")
              ],
            ),
            "미션 초대 받기!",
            "취소",
            // 확인을 눌렀을 때
                () async {
              invitation.remove(item);
              await update_request("update user_table set invitation = '${jsonEncode(invitation)}' where user_email = '${user_data['user_email']}'", null);
              Navigator.pop(context);
              // 하임님 요거 all_missions[index] 에서 mission_id랑 Index가 안맞아서 mission 상세 페이지로 이동이 안되요 ㅠㅠ
              // return MissionCheckStatusPage(
              //   mission_index: _index,
              //   mission_data: all_missions[_index],
              //   do_mission_data: do_mission[index],
              // ),
                },
            // 취소를 눌렀을 때
            null,
          );
        }
      }

      // 느린걸 좀 고쳐야겠다. 이걸 그 콜백함수 써서 구현하면? : 안되더라
      await afterLogin();

      // 다 닫고 ㄱㄱ

      if (context != null && reload == false) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => TemHomePage()), (
                route) => false);

        // 홈페이지가 기본 !
        controller.currentBottomNavItemIndex.value = AppScreen.home;

      }
    }
     // 자동로그인이 필요하지 않은 경우
    else if (userInfo != null && user_data != null) {
      //Fluttertoast.showToast(msg: "자동로그인이 필요하지 않은 경우");
      // 다 닫고 ㄱㄱ
      if (context!=null && reload==false) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => TemHomePage()), (route) => false);
      }
    }
    else {
      if (context!=null && reload==false) {
        //Fluttertoast.showToast(msg: "로그인이 필요한 경우");
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginPageCustom()), (
                route) => false);
      }
      print('로그인이 필요합니다');
    }
  }
}

// 현재 레벨에서 다음 레벨까지 필요한 리워드를 받아옴
level_update() async {
  if (leveling==null){
    leveling = await select_request("SELECT * from leveling", null, true);
    print("leveling : ${leveling}");
  }

  int user_lv = int.parse(user_data['user_lv']);
  double user_reward = double.parse(user_data['reward']);

  lv_start = double.parse(leveling[user_lv-1]['reward']);
  lv_end = double.parse(leveling[user_lv]['reward']);

  lv_percent = (user_reward - lv_start)/(lv_end-lv_start);
  //print("lv_percent : $lv_percent");
  if(lv_percent<0){lv_percent=0;}
  if(lv_percent>1){lv_percent=1;}

  // 레벨 변경
  // if (user_reward >= lv_end){
  //   update_request(
  //       "UPDATE user_table SET user_lv = user_lv + 14 where user_email = '${user_data['user_email']}'",
  //       "레벨업 !! ${user_lv}레벨이 되었습니다.");
  // }
  //
  // if (user_reward < lv_start){
  //   update_request(
  //       "UPDATE user_table SET user_lv = user_lv + 14 where user_email = '${user_data['user_email']}'",
  //       "리워드를 사용하여  ${user_lv}레벨이 되었습니다.");
  // }
}