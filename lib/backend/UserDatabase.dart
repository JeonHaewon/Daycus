var user_data = null;
var all_missions = null;
int missions_cnt = 0;

// 카테고리 바꿀 때는 아주 주의가 필요함.
// 미션 번호만 저장 (더 효율적인 방법이 있다면 바꾸는 것도 좋은 생각)
var missions_health = null;
var missions_study = null;
var missions_exer = null;
var missions_life = null;
var missions_hobby = null;

// 아래가 계속 안돼서 그냥 다섯개의 변수로 만들었다. 왜 안되는지 알아봐야겠다.
//Map<String, List<dynamic>> missions_category = {};

var do_mission = null;