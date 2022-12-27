import 'package:ntp/ntp.dart';
import 'package:intl/intl.dart';

// 하임 1220 : Future이 맞는지 모르겠다
NowTime(String? formatString) async {
    try {
      DateTime currentTime = await NTP.now();
      // 스마트폰 시간이 어떻든 한국시간만을 가져오고 싶다
      //현재 시간대: Korea/Seoul로 설정됨
      currentTime = currentTime.toUtc().add(Duration(hours: 9));

      // 하임 1220 : format이 정해져 있다면
      if (formatString != null) {
        String formatDate = DateFormat(formatString).format(currentTime);
        return formatDate;
      }
      // format을 정해주지 않은 null 상태라면
      else {
        return currentTime;
      }


    } on Exception catch (e) {
      print(e);
      return null;
    }

}

// 'yy/MM/dd - HH:mm:ss'


