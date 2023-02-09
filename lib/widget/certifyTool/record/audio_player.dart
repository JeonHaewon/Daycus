import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:daycus/widget/certifyTool/record/Disk.dart';
import 'package:daycus/widget/certifyTool/record/recordWidget.dart';
// import 'package:example/Disk.dart';
// import 'package:example/app_color.dart';
// import 'package:example/chat_bubble.dart';
// import 'package:example/main1.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';



// https://pub.dev/packages/audioplayers/install
// https://pub.dev/packages/record/install
// https://github.com/llfbandit/record/blob/master/record/example/lib/main.dart

class AudioPlayer extends StatefulWidget {
  /// Path from where to play recorded audio
  final String source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;

  const AudioPlayer({
    Key? key,
    required this.source,
    required this.onDelete,
    required this.timer,
  }) : super(key: key);

  final String timer;

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

var CDdgree = 0;

Duration? _position;
Duration? _duration;
String? uploadAudioPath;
final _audioPlayer = ap.AudioPlayer();

class AudioPlayerState extends State<AudioPlayer> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;

  double IconSize = 30.sp;

  init(){
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
          await stop();
          setState(() {});
        });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
          (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
          (duration) => setState(() {
        _duration = duration;
      }),
    );
  }

  @override
  void initState() {
    _getDir();

    init();

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  var appDirectory = null;
  late String path;
  //bool isLoading = false;
  bool isLoading = true;

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory}/${FilePath}";
    uploadAudioPath = "${appDirectory}/${FilePath}";
    isLoading = false;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 30.h,
      //color: Colors.lightBlue,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 5.w),
                Text(temTimer ?? "00 : 00", style:timerStyle,),
                SizedBox(width: 10.w),

                ClipOval(
                  child: Material(
                    // color: Color(0x6e7074e9),
                    child: InkWell(
                      child: (_audioPlayer.state == ap.PlayerState.playing)
                          ? Icon(Icons.pause, color: Colors.black, size: IconSize)
                          : Icon(Icons.play_arrow, color: Colors.black, size: IconSize),
                      onTap: () async {
                        if (_audioPlayer.state == ap.PlayerState.playing) {
                          await pause();
                        } else {
                          await play();
                        }

                        setState(() {
                        });
                      },
                    ),
                  ),
                ),


                //_buildControl(),
                // Stack(
                //   children: [
                //
                //   ],
                // ),
                // SizedBox(width: 15),
              ],
            ),
            // Row(
            //   children: [
            //
            //   ],
            // ),
            SizedBox(height: 15.h),

            Row(
              //mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //_buildControl(),
                _buildSlider(220),

                // TextButton(
                //     onPressed: (){
                //
                //     }, child: child),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Icon(Icons.clear,
                      color: Colors.black, size: 25.sp),
                  onPressed: () {
                    stop().then((value) => widget.onDelete());
                  },
                ),
              ],
            ),

          ]
      ),
    );
  }

  // Widget _buildControl() {
  //   Icon icon;
  //   //Color color;
  //
  //   if (_audioPlayer.state == ap.PlayerState.playing) {
  //     icon = Icon(Icons.pause, color: Colors.black, size: IconSize);
  //     //color = Colors.red.withOpacity(0.1);
  //   } else {
  //     //final theme = Theme.of(context);
  //     icon = Icon(Icons.play_arrow, color: Colors.black, size: IconSize);
  //     //color = theme.primaryColor.withOpacity(0.1);
  //   }
  //
  //   return ClipOval(
  //     child: Material(
  //       color: Color(0x6e7074e9),
  //       child: InkWell(
  //         child:
  //         SizedBox(child: icon),
  //         onTap: () {
  //           if (_audioPlayer.state == ap.PlayerState.playing) {
  //             pause();
  //           } else {
  //             play();
  //           }
  //
  //           setState(() {
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: width,
      child: SliderTheme(
        data: SliderThemeData(
          overlayShape: SliderComponentShape.noOverlay,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.sp),
          trackHeight: 3,

        ),
        child: Slider(
          //divisions: 4,
          //label: "2",
          activeColor: Color(0xff7074E9),
          inactiveColor: Colors.grey[300],
          onChanged: (v) {
            if (duration != null) {

              final position = v * duration.inMilliseconds;
              _audioPlayer.seek(Duration(milliseconds: position.round()));

            }
          },
          value: canSetValue && duration != null && position != null
              ? position.inMilliseconds / duration.inMilliseconds
              : 0.0,
        ),
      ),
    );
  }

  Future<void> play() {
    animationCtrl.repeat();
    setState(() {
    });
    return _audioPlayer.play(
      kIsWeb ? ap.UrlSource(widget.source) : ap.DeviceFileSource(widget.source),
    );
  }

  Future<void> pause() {
    animationCtrl.stop();
    setState(() {
    });
    return _audioPlayer.pause();
  }

  Future<void> stop() {
    animationCtrl.stop();
    setState(() {
      _position = null; _duration = null;
      temTimer = "00 : 00";
    });
    return _audioPlayer.stop();
  }
}