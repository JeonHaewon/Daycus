import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class MissionButton extends StatelessWidget {
  MissionButton({
    Key? key,
    required this.title,
    required this.currentUser,
    required this.image,
    required this.duration,
    this.onTap,
}) : super(key: key);

  final String title;
  final int currentUser;
  final String image;
  final String duration;
  final onTap;

  var f = NumberFormat('###,###,###,###');

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => onTap),
        );
      },
      child:Stack(
        children: [
          Container(
            width: 170.w,
            //height: 100.h,
            decoration: BoxDecoration(
              //color: Colors.white60,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: AssetImage('assets/image/thumbnail/$image') ,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.25), BlendMode.srcATop),
                  fit: BoxFit.cover
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, bottom: 10.h, top: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  //Text(title,style: TextStyle(color: Colors.white,fontSize: 15.sp, fontFamily: 'korean',fontWeight: FontWeight.bold)),


                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   width: 150.w,
                  //   height: 20.h,
                  //   child: FittedBox(
                  //     fit: BoxFit.scaleDown,
                  //     child:Text(title,style: TextStyle(color: Colors.white,fontSize: 15.sp, fontFamily: 'korean',fontWeight: FontWeight.bold)),
                  //   ),
                  // ),


                  Container(
                      width: 150.w,
                      //height: 20.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                text: TextSpan(
                                    text:
                                    title, style: TextStyle(color: Colors.white,fontSize: 14.5.sp, fontFamily: 'korean',fontWeight: FontWeight.bold)),
                              )),
                        ],
                      )
                  ),


                  Container(
                    child: Row(
                      children: [
                        Text(f.format(currentUser),style: TextStyle(color: Colors.white,fontSize: 11.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
                        Text("명 참여중",style: TextStyle(color: Colors.white,fontSize: 11.sp, fontFamily: 'korean',fontWeight: FontWeight.bold) ),
                      ],
                    ),
                  ),


                  Container(
                    padding: EdgeInsets.only(top: 33.h, right: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(duration, style: TextStyle(fontSize: 11.sp, fontFamily: 'korean',color: Colors.white) ),
                      ],
                    ),
                  ),


                ],
              ),
            ),

          ),




        ],
      ),
    );
  }
}