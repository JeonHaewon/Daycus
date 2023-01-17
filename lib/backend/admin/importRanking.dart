import 'package:daycus/backend/ImportData/imageDownload.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';

class ImportRanking extends StatefulWidget {
  const ImportRanking({Key? key}) : super(key: key);

  @override
  State<ImportRanking> createState() => _ImportRankingState();
}



class _ImportRankingState extends State<ImportRanking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextButton(
              onPressed: () async {
                topRankingList = await select_request(
                    "select user_name, reward, Ranking, user_id, profile From user_table WHERE (1<=Ranking) AND (Ranking<=3) ORDER BY Ranking limit 3;",
                    null,
                    true);
                print(topRankingList);

                // image_download(folder, imageName);

              }, child: Text("123등 불러오기")),

        ],
      ),
    );
  }
}
