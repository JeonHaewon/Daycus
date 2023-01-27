import 'package:daycus/backend/UserDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class topRanking extends StatefulWidget {
  const topRanking({Key? key}) : super(key: key);

  @override
  State<topRanking> createState() => _topRankingState();
}

class _topRankingState extends State<topRanking> {
  @override
  Widget build(BuildContext context) {
    // topRanking
    return Container(
        margin: EdgeInsets.fromLTRB(28.w, 5.h, 28.w, 0),
        padding: EdgeInsets.fromLTRB(28.w, 15.h, 28.w, 5.h),
        child: Container(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                topRankingBlock(index: 1),

                topRankingBlock(index: 0),

                topRankingBlock(index: 2),

              ],
            )
        ),
      );
  }
}


class topRankingBlock extends StatelessWidget {
  const topRankingBlock({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {

    int Ranking = int.parse(topRankingList[index]["Ranking"]);

    Widget _medal(int Ranking){
      if (Ranking==1){
        return Image.asset('assets/image/gold_medal.png', height: 18.w,);}
      else if (Ranking==2){
        return Image.asset('assets/image/silver_medal.png', height: 18.w,);}
      else{
        return Image.asset('assets/image/bronze_medal.png', height: 18.w,);}
    }

    Color? _color(int Ranking){
      if (Ranking==1){
        return Colors.yellow[600];}
      else if (Ranking==2){
        return Colors.grey[400];}
      else{
        return Colors.brown[300];}
    }

    double _height(int Ranking){
      if (Ranking==1){
        return 30.h;}
      else if (Ranking==2){
        return 20.h;}
      else{
        return 15.h;}
    }

    return Column(
      children: [
        // (topRankingProfile[0]==null)
        //     ? CircleAvatar( backgroundImage : AssetImage("assets/image/non_profile.png",), radius: 13.sp,)
        //     : Transform.rotate(angle: topRankingProfile[0][1]* pi/180, child: CircleAvatar( backgroundColor : Colors.grey[200],  backgroundImage: topRankingProfile[0][0]!.image, radius: 20.sp), ),
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8.h, 0, 0),
              child: Column(
                children: [
                  Container(
                    width:94.w,
                    //height:55.h,
                    decoration: BoxDecoration(
                      color:Colors.indigo[50],
                      borderRadius: BorderRadius.vertical(
                          top : Radius.circular(5)
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5.w, _height(Ranking)*2/3, 3.w, _height(Ranking)/3),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 17.h,
                            width: 80.w,
                            child: FittedBox(
                              alignment: Alignment.center,
                              fit: BoxFit.contain,

                              child: Text("${topRankingList[index]['user_name']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.sp, )),
                            ),
                          ),
                          SizedBox(height: 2.h,),
                          SizedBox(
                            height: 16.h,
                            width: 80.w,
                            child: FittedBox(
                                alignment: Alignment.center,
                                fit: BoxFit.contain,

                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.control_point_duplicate,size:16.w),
                                    SizedBox(width: 3.w,),
                                    Text("${(double.parse(topRankingList[index]['reward'])).toStringAsFixed(1)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, )),
                                  ],
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width:94.w,
                    height:6.h,
                    decoration: BoxDecoration(
                      color:_color(Ranking),
                    ),
                  ),

                ],

              ),
            ),

            _medal(Ranking),

          ],
        ),
      ],
    );
  }
}

