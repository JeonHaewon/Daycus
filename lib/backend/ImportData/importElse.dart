

import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';

// 랭킹 리스트를 불러오는 것.
import_ranking() async {
  // 지금 내 랭킹
  int userRanking = int.parse(user_data['Ranking']);
  // 지금 내 랭킹에서 -2 부터 +2까지
  rankingList = await select_request(
      "select user_name, reward, Ranking, user_id From user_table WHERE (${userRanking-2}<=Ranking) AND (Ranking<=${userRanking+2}) ORDER BY Ranking;",
      null,
      true);
}