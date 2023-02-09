import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Disk extends StatefulWidget {
  const Disk({Key? key}) : super(key: key);

  @override
  State<Disk> createState() => _DiskState();
}

late AnimationController animationCtrl;

class _DiskState extends State<Disk> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    print("init");

    super.initState();
    animationCtrl = AnimationController(duration: Duration(seconds: 15), vsync: this)
      ..repeat();

    animationCtrl.stop();
  }

  @override
  void dispose() {
    animationCtrl.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {

    //Color blue = Color(0xff8a8dee);
    List<Color> colorList = [
      Color(0xffafb2fd),
      Color(0xff7074E9),
      Color(0xff595eee),
      Color(0xff474bd7),
      // Color(0xff2F34DB),
    ];

    return Stack(
      alignment: Alignment.center,
      children: [
        RotationTransition(
          alignment: Alignment.center,
          turns: animationCtrl,
          child: Container(
            padding: EdgeInsets.all(37.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                // stops: [0.0, 0.15, 0.28, 0.4, 0.65, 0.8, 0.9, 1],
                colors: [
                  colorList[0], colorList[1], colorList[2],
                  colorList[2], colorList[1], colorList[0],
                  colorList[0], colorList[1], colorList[2],
                  colorList[2], colorList[1], colorList[0],
                  colorList[1], colorList[1], colorList[0],
                ],
              ),
            ),
            child: CircleAvatar(
              radius: 32.sp,
              backgroundColor: Color(0xff474AA1),
              //child: Icon(Icons.record_voice_over_outlined, color: Colors.grey[100], size: 30,),
              //backgroundImage: AssetImage("assets/image/character2.png"),
            ),
          ),
        ),

        CircleAvatar(
          radius: 24.sp,
          backgroundColor: Colors.white,
          child: Icon(Icons.record_voice_over_outlined, color: Colors.grey[300], size: 25.sp,),
          //backgroundImage: AssetImage("assets/image/character2.png"),
        ),
      ],
    );
  }
} // Color(0xff474AA1)
