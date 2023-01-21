

import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';

import_ranking() async {
  int userRanking = int.parse(user_data['Ranking']);
  rankingList = await select_request(
      "select user_name, reward, Ranking, user_id From user_table WHERE (${userRanking-2}<=Ranking) AND (Ranking<=${userRanking+2}) ORDER BY Ranking;",
      null,
      true);
}