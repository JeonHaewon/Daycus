// 위치 면경 시 큰일날 수 있음. 주의

import 'dart:io';
import 'package:flutter/material.dart';

// var : 한번 자료형이 결정되면 바뀌지 않으나, 처음에는 어떤 자료형이든 넣을 수 있다
var user_data = null;
var all_missions = null;
int missions_cnt = 0;
var minused_reward;
// 카테고리 바꿀 때는 아주 주의가 필요함.
// 미션 번호만 저장 (더 효율적인 방법이 있다면 바꾸는 것도 좋은 생각)

var leveling = null;

// 아래가 계속 안돼서 그냥 다섯개의 변수로 만들었다. 왜 안되는지 알아봐야겠다.
//Map<String, List<dynamic>> missions_category = {};

var do_mission = null;
var done_mission = null;

double lv_percent = 0;
double lv_start = 1;
double lv_end = 2;

// 마지막 에러를 잡기 위한 변수
String last_error = "최근에 잡힌 에러가 없음";

// -- 최적화 필요
// 다운로드 한 이미지 사진
Image? downloadProfileImage;
// 선택한 이미지 사진
File? profileImage;
String? profileImageReNamed;
int profileDegree = 0;

List? rankingList = null;

var topRankingList = null;



Map<int, dynamic> topRankingProfile = {
  0 : null,
  1 : null,
  3 : null,
};