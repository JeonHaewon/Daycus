import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/login/login.dart';
import 'package:daycus/core/app_text.dart';
import 'package:daycus/core/constant.dart';
import 'package:daycus/screen/temHomePage.dart';
import 'package:daycus/widget/PopPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

mission_complete(int todayBlockCnt, do_mission_data,
    int toCertify, BuildContext context, String user_email, int mission_result) {
  // 14일이 지났을 때

    // 정산 변수 초기화
    // 0 row 복사 1 삭제 2 리워드 환급
    List<bool> success = [false, false, false];
    double returnReward = 0;
    String popTitle = "";
    String popContent = "";
    double bet_reward = double.parse((do_mission_data['bet_reward']).toString());



    // 최대 100%
    if (mission_result > toCertify) {
      mission_result = toCertify;
    }

    // 미션 성공
    if (mission_result >= toCertify) {
      popTitle = "미션 성공 !!";
      // 리워드를 걸지 않았을 때
      if (do_mission_data['bet_reward'] == '0') {
        // 원래 가진 리워드에 14를 추가함
        // int > string > double
        returnReward = double.parse((mission_reward).toString());
      }
      // 리워드를 걸었을 때
      else {
        // 원래 가진 리워드에 14+(건 리워드)*150/100를 추가함
        returnReward = mission_reward + bet_reward * 150 / 100;
      }

      popContent = missionSuccessString +
          "\n${returnReward.toStringAsFixed(1)} ${rewardName}가 지급됩니다";
    }

    // 미션 실패
    else {
      popTitle = "미션 실패";
      // 리워드를 걸지 않았을 때
      if (do_mission_data['bet_reward'] == '0') {
        popContent = missionFailString;
        success[2] = true;
      }
      // 리워드를 걸었을 때
      else {
        // 원래 가진 리워드에 (한 퍼센트)*14+(건 리워드)/2를 추가함
        returnReward =
            (mission_result / toCertify) * mission_week + (bet_reward / 2);
        popContent = missionSuccessAndBetString +
            "\n${((mission_result / toCertify) * 100).toStringAsFixed(
                1)}% 달성하여 ${returnReward.toStringAsFixed(
                1)}포인트가 지급됩니다.\n다른 미션에 도전해보세요!";
      }
    }

    print("여기까지 됨");

    // 이후 공통 - pop 페이지 띄우기
    PopPage(popTitle, context, Text(popContent),
        "확인", "돌아가기", () async {
          // do_mission > Done_mission row 이동 - 공통 작업
          success[0] = await update_request(
              "INSERT INTO Done_mission  select * from (select * from do_mission where (do_id = '${do_mission_data['do_id']}')) dating",
              null);
          if (success[0]) {
            success[1] = await update_request(
                "DELETE FROM do_mission where (do_id = '${do_mission_data['do_id']}')",
                null);
            if (success[1]) {
              // 환급 리워드가 있다면, 리워드 업데이트
              if (returnReward > 0) {
                success[2] = await update_request(
                    "UPDATE user_table SET reward = reward + ${returnReward
                        .toStringAsFixed(
                        1)} where user_email = '${user_email}'",
                    null);
              }
            }
          }

          // 모든 프로세스 종료 시 나갈 수 있음.
          if (success[0] && success[1] && success[2]) {

            // 데이터를 다 업데이트 한 후에 페이지를 다시 불러옴
            await afterLogin();

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => TemHomePage()),
                    (route) => false);

            // toast 얼마나 환급받았는지
            if (returnReward > 0) {
              Fluttertoast.showToast(msg: "${returnReward.toStringAsFixed(
                  1)} ${rewardName}가 환급되었습니다");
            }
            // 환급받을 리워드가 없을 시
            else {
              Fluttertoast.showToast(msg: missionFailToastString);
            }
          }
        });
}