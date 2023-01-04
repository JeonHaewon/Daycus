import 'package:daycus/backend/ImportData/doMissionImport.dart';
import 'package:daycus/backend/ImportData/importMissions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:daycus/backend/Api.dart';
import 'KeepLogin.dart';
import 'dart:convert';
import 'package:daycus/backend/UserDatabase.dart';
import '../../screen/temHomePage.dart';


userLogin(String email, String password, bool reload) async{
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
        // 나중에 멘트 "~님 환영합니다" 이런걸로 바꾸기 (또는 논의해서 바꾸기)
        //print("로그인에 성공하였습니다.");
        user_data = resLogin['userData'];
        print("{$user_data}");

        // 첫 로그인 시에만 인사해줌
        if (reload==false){
          Fluttertoast.showToast(msg: "안녕하세요, ${resLogin['userData']['user_name']}님 !");
        }


        return true;

      } else {
        // 계정이 없다는 멘트도 띄워야할듯?
        Fluttertoast.showToast(msg: "이메일 또는 비밀번호가 올바르지 않습니다.");
        print("이메일 또는 비밀번호가 올바르지 않습니다.");

        return false;
      }
    }
  }
  catch (e) {
    print(e.toString());
    Fluttertoast.showToast(msg: e.toString());

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
  print("로그인에 성공하였습니다.");

  // 미션 불러오기
  await missionImport();
  // 카테고리별 미션 불러오기
  await importMissionByCategory();
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

// keep login - 유저 정보 들고오기
LoginAsyncMethod(storage, BuildContext? context, bool reload) async {

  dynamic userInfo = '';

  // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
  // 데이터가 없을때는 null을 반환
  userInfo = await storage.read(key:'login');
  print(userInfo);

  // 자동로그인이 필요한 경우, reload 시
  if ((userInfo!=null && user_data==null) || reload) {
    var userDecode = jsonDecode(userInfo);

    print(userDecode);
    await userLogin(userDecode['user_email'], userDecode['password'], reload);
    //userLogin(userInfo['userName'], userInfo['password'], userInfo['user_email']);

    // 느린걸 좀 고쳐야겠다. 이걸 그 콜백함수 써서 구현하면? : 안되더라
    await afterLogin();
    // 다 닫고 ㄱㄱ

    if (context!=null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => TemHomePage()), (route) => false);

      // 홈페이지가 기본 !
      controller.currentBottomNavItemIndex.value = 2;
    }
  } // 자동로그인이 필요하지 않은 경우
  else if (userInfo!=null && user_data!=null) {
    // 다 닫고 ㄱㄱ
    if (context!=null) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => TemHomePage()), (route) => false);
    }
  }
  else {
    print('로그인이 필요합니다');
  }
}