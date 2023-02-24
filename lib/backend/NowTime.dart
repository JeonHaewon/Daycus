import 'package:ntp/ntp.dart';
import 'package:intl/intl.dart';

// 시간을 불러오는 함수
NowTime(String? formatString) async {
    try {
      DateTime currentTime = await NTP.now();
      //현재 시간대: Korea/Seoul로 설정됨
      currentTime = currentTime.toUtc().add(Duration(hours: 9));

      // format이 정해져 있다면
      if (formatString != null) {
        String formatDate = DateFormat(formatString).format(currentTime);
        return formatDate;
      }
      // format을 정해주지 않은 null 상태라면
      else {
        // 'yy/MM/dd - HH:mm:ss' ??
        return currentTime;
      }


    } on Exception catch (e) {
      print(e);
      return null;
    }

}




