import 'dart:math';

import 'package:daycus/backend/ImportData/imageDownload.dart';
import 'package:daycus/backend/UpdateRequest.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImportRanking extends StatefulWidget {
  const ImportRanking({Key? key}) : super(key: key);

  @override
  State<ImportRanking> createState() => _ImportRankingState();
}



class _ImportRankingState extends State<ImportRanking> {

  @override
  void initState() {
    super.initState();
    _initImportTest();

  }

  _initImportTest() async {
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(


        children: [

          (topRankingProfile[0]==null)
              ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png",), radius: 13.sp,)
              : Transform.rotate(angle: topRankingProfile[0][1]* pi/180, child: CircleAvatar( backgroundColor : Colors.grey[200],  backgroundImage: topRankingProfile[0][0]!.image, radius: 20.sp), ),

          (topRankingProfile[1]==null)
              ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png",), radius: 13.sp,)
              : Transform.rotate(angle: topRankingProfile[1][1]* pi/180, child: CircleAvatar( backgroundColor : Colors.grey[200],  backgroundImage: topRankingProfile[1][0]!.image, radius: 20.sp), ),

          (topRankingProfile[2]==null)
              ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png",), radius: 13.sp,)
              : Transform.rotate(angle: topRankingProfile[2][1]* pi/180, child: CircleAvatar( backgroundColor : Colors.grey[200],  backgroundImage: topRankingProfile[2][0]!.image, radius: 20.sp), ),

          // (topRankingProfile[3]==null)
          //     ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png",), radius: 13.sp,)
          //     : Transform.rotate(angle: topRankingProfile[2][1]* pi/180, child: CircleAvatar( backgroundColor : Colors.grey[200],  backgroundImage: topRankingProfile[2][0]!.image, radius: 20.sp), ),


          TextButton(
              onPressed: () async {
                topRankingList = await select_request(
                    "select user_name, reward, Ranking, user_id, profile From user_table WHERE (1<=Ranking) AND (Ranking<=4) ORDER BY Ranking limit 3;",
                    null,
                    false);
                print(topRankingList);


                setState(() async {
                  topRankingProfile[0] = await image_download_root(
                      "image_application/user_profile", topRankingList[0]['profile']);
                  topRankingProfile[1] = await image_download_root(
                      "image_application/user_profile", topRankingList[1]['profile']);
                  topRankingProfile[2] = await image_download_root(
                      "image_application/user_profile", topRankingList[2]['profile']);
                  // topRankingProfile[3] = await image_download_root(
                  //     "image_application/user_profile", topRankingList[3]['profile']);
                });

                setState(() {

                });

              }, child: Text("123등 불러오기")),

        ],
      ),
    );
  }
}
