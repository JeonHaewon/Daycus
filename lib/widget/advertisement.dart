import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';


var admobBannerId = 'ca-app-pub-3339242274230109/7848999030';


class Advertisement extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: AdmobBanner(
                  adUnitId: admobBannerId,
                  adSize: AdmobBannerSize.BANNER,
                  onBannerCreated:
                      (AdmobBannerController controller){},
                )
            )
          ],
        )
    );
  }
}
