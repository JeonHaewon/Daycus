import 'package:daycus/backend/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';




class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  static final storage = FlutterSecureStorage();


  @override
  void initState() {
    super.initState();
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    // 페이지 빌드 후에 비동기로 콜백함수를 호출 : 처음에 위젯을 하나 생성후에 애니메이션을 재생
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoginAsyncMethod(storage, context, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset("assets/image/logo_happyCircuit.png", width: 260.w,),
          ),

          Center(
            child: Column(
              children: [
                SizedBox(height: 720.h,),
                Text("로딩이 지속될 경우\n앱을 완전히 껐다가 켜주세요"),
                SizedBox(height: 20.h,),
                SizedBox(
                  width: 30.w, height: 30.h,
                  child: CircularProgressIndicator(), ),
              ],
            ),

          ),

        ],
      ),
    );
  }
}
