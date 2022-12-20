import 'package:ntp/ntp.dart';
import 'package:intl/intl.dart';

NowTime() async {

    try {
      DateTime currentTime = await NTP.now();
      // 스마트폰 시간이 어떻든 한국시간만을 가져오고 싶다
      //현재 시간대: Korea/Seoul로 설정됨
      currentTime = currentTime.toUtc().add(Duration(hours: 9));
      String formatDate = DateFormat('yy/MM/dd - HH:mm:ss').format(currentTime);

      return formatDate;
    } on Exception catch (e) {
      print(e);
      return null;
    }

}