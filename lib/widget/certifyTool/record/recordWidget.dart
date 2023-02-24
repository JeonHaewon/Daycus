import 'dart:async';

// import 'package:example/Disk.dart';
// import 'package:example/app_color.dart';
import 'package:daycus/widget/certifyTool/record/Disk.dart';
import 'package:daycus/widget/certifyTool/record/audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// import 'package:example/audio_player.dart';

// void main() => runApp(const MyApp());

// 녹음 화면
class AudioRecorder extends StatefulWidget {
  final void Function(String path) onStop;

  const AudioRecorder({
    Key? key,
    required this.onStop,
  }) : super(key: key);


  @override
  State<AudioRecorder> createState() => _AudioRecorderState();
}

int _recordDuration = 0;

class _AudioRecorderState extends State<AudioRecorder> {

  Widget recordButton = Stack(
    alignment: Alignment.center,
    children: [
      CircleAvatar(radius: 15.sp, backgroundColor: Colors.grey[200],),
      CircleAvatar(radius: 10.5.sp, backgroundColor: Colors.red,),
    ],
  );

  Timer? _timer;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  late AnimationController rotationController;


  @override
  void initState() {

    //rotationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _recordDuration = 0;

    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) => setState(() => _amplitude = amp));

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();
        // final isRecording = await _audioRecorder.isRecording();

        await _audioRecorder.start();
        _recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();

    final path = await _audioRecorder.stop();

    if (path != null) {
      widget.onStop(path);
    }
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  double _barWidth = 200;
  double _barMax = 160;

  @override
  Widget build(BuildContext context) {

    return Container(
      // color: Colors.grey,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 5.w),
              buildTimer(),
              SizedBox(width: 10.w),
              _buildRecordStopControl(),
              SizedBox(width: 5.w),
              _buildPauseResumeControl(),
              //SizedBox(width: 10.w),
              //SizedBox(width: 10.w),
            ],
          ),

          SizedBox(height: 15.h,),

          // 밑에 회색 바, 위에 파랑 바
          if (_amplitude != null) ...[
            // Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     CircleAvatar(radius: 40, backgroundColor: Colors.grey[200],),
            //     CircleAvatar(radius: (160-(_amplitude?.current ?? 0.0)*(-1))*37/160, backgroundColor: Colors.red,),
            //
            //   ],
            // ),
            //
              Align(
                alignment: Alignment.center,
                child: Stack(
                  //alignment: Alignment.center,
                  children: [
                    Container(width: _barWidth*0.7, color: Colors.grey[200], height: 20,),

                    ((_barMax-(_amplitude?.current ?? 0.0)*(-1))>0 && (_barMax-(_amplitude?.current ?? 0.0)*(-1))<=_barMax) ?
                    Container(width: ((_barMax-(_amplitude?.current ?? 0.0)*(-1))*_barWidth/_barMax)*0.7,
                      decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: [
                            Color(0xff2F34DB),
                            Color(0xff7074E9),
                            //Color(0xff63648B),
                          ],
                        ),
                      ),height: 20,)
                        :
                        // 소리 값이 아예 없을때
                    Container(
                      padding: EdgeInsets.only(top: 2.h),
                      alignment: Alignment.center,
                        child: Text("녹음 준비중 ..", style: TextStyle(color: Colors.red,//Color(0xff2F34DB),
                            fontSize: 14.sp, fontFamily: "korean"), textAlign: TextAlign.center,)),

                  ],
                ),
              )

            // const SizedBox(height: 40),
            // Text('Current: ${_amplitude?.current ?? 0.0}'),
            // Text('Max: ${_amplitude?.max ?? 0.0}'),
          ],

        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Widget icon;
    //late Color color;

    if (_recordState != RecordState.stop) {
      icon = Icon(Icons.stop, color: Colors.black, size: 30.sp);
      //color = Colors.red.withOpacity(0.1);
    } else {
      //final theme = Theme.of(context);
      icon = recordButton;
      //color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        // color: Color(0x6e7074e9),
        child: InkWell(
          child: icon,
          onTap: () {
            (_recordState != RecordState.stop) ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (_recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }

    late Widget icon;
    //late Color color;

    if (_recordState == RecordState.record) {
      icon = Icon(Icons.pause, color: Colors.black, size: 30.sp, );
      //color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = recordButton; //const Icon(Icons.play_arrow, color: Colors.black, size: 30);
      //color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        // color: Color(0x6e7074e9),
        child: InkWell(
          child: SizedBox(child: icon),
          onTap: () {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  // Widget _buildText() {
  //
  //   return buildTimer();
  //
  //   // if (_recordState != RecordState.stop) {
  //   //   return _buildTimer();
  //   // }
  //   //
  //   // return const Text("Waiting to record");
  // }


  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}


// -- 아래가 본체
String temTimer = "00 : 00";
String? FilePath = null;

class RecordWidget extends StatefulWidget {
  const RecordWidget({Key? key}) : super(key: key);

  @override
  State<RecordWidget> createState() => _RecordWidgetState();
}

// class _RecordWidgetState extends State<RecordWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
//
//
// class RecordWidget extends StatefulWidget {
//   RecordWidget({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<RecordWidget> RecordWidgetState() => _RecordWidgetState();
// }


class _RecordWidgetState extends State<RecordWidget> {
  bool showPlayer = false;
  String? audioPath;


  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  // Recorded file path: /data/user/0/com.example.example/cache/audio3402000448567787435.m4a

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.grey,
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      height: 180.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // CD
          Disk(),

          Container(
            //color: Colors.grey,
            //padding: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(top: 30.h, bottom: 20.h, left: 20.w),
            width:190.w, height: 150.h,
            child: showPlayer
            // 재생하는 위젯
                ? AudioPlayer(
              timer: "${_formatNumber(_recordDuration ~/ 60)} : ${_formatNumber(_recordDuration % 60)}",
              source: audioPath!,
              onDelete: () {
                setState(() => showPlayer = false);
              },
            )
            // 녹음하는 위젯
                : AudioRecorder(
              onStop: (path) {
                if (kDebugMode) print('Recorded file path: $path');
                FilePath = path;
                temTimer = "${_formatNumber(_recordDuration ~/ 60)} : ${_formatNumber(_recordDuration % 60)}";
                _recordDuration = 0;

                setState(() {
                  audioPath = path;
                  showPlayer = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle timerStyle = TextStyle(fontFamily: 'korean', fontSize: 25.sp);

Text buildTimer() {
  final String minutes = _formatNumber(_recordDuration ~/ 60);
  final String seconds = _formatNumber(_recordDuration % 60);

  return Text(
    // Text("00:00:28",style:),
    '$minutes : $seconds',
    style:timerStyle,
  );
}

String _formatNumber(int number) {
  String numberStr = number.toString();
  if (number < 10) {
    numberStr = '0$numberStr';
  }

  return numberStr;
}




// import 'dart:io';
//
// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:example/chat_bubble.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Audio Waveforms',
//       debugShowCheckedModeBanner: false,
//       home: Home(),
//     );
//   }
// }
//
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   late final RecorderController recorderController;
//
//   String? path;
//   String? musicFile;
//   bool isRecording = false;
//   bool isRecordingCompleted = false;
//   bool isLoading = true;
//   late Directory appDirectory;
//
//   @override
//   void initState() {
//     super.initState();
//     _getDir();
//     _initialiseControllers();
//   }
//
//   void _getDir() async {
//     appDirectory = await getApplicationDocumentsDirectory();
//     path = "${appDirectory.path}/recording.m4a";
//     isLoading = false;
//     setState(() {});
//   }
//
//   void _initialiseControllers() {
//     // useLegacyNormalization: true
//     recorderController = RecorderController()
//       ..androidEncoder = AndroidEncoder.aac
//       ..androidOutputFormat = AndroidOutputFormat.mpeg4
//       ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
//       ..sampleRate = 44100;
//   }
//
//   void _pickFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       musicFile = result.files.single.path;
//       setState(() {});
//     } else {
//       debugPrint("File not picked");
//     }
//   }
//
//   @override
//   void dispose() {
//     recorderController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF252331),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF252331),
//         elevation: 1,
//         centerTitle: true,
//         shadowColor: Colors.grey,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/images/logo.png',
//               scale: 1.5,
//             ),
//             const SizedBox(width: 10),
//             const Text('Simform'),
//           ],
//         ),
//       ),
//       body: isLoading
//           ? const Center(
//         child: CircularProgressIndicator(),
//       )
//           : SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 4,
//                 itemBuilder: (_, index) {
//                   return WaveBubble(
//                     index: index + 1,
//                     isSender: index.isOdd,
//                     width: MediaQuery.of(context).size.width / 2,
//                     appDirectory: appDirectory,
//                   );
//                 },
//               ),
//             ),
//             if (isRecordingCompleted)
//               WaveBubble(
//                 path: path,
//                 isSender: true,
//                 appDirectory: appDirectory,
//               ),
//             if (musicFile != null)
//               WaveBubble(
//                 path: musicFile,
//                 isSender: true,
//                 appDirectory: appDirectory,
//               ),
//             SafeArea(
//               child: Row(
//                 children: [
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 200),
//                     child: isRecording
//                         ? AudioWaveforms(
//                       enableGesture: true,
//                       size: Size(
//                           MediaQuery.of(context).size.width / 2,
//                           50),
//                       recorderController: recorderController,
//                       waveStyle: const WaveStyle(
//                         waveColor: Colors.white,
//                         extendWaveform: true,
//                         showMiddleLine: false,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12.0),
//                         color: const Color(0xFF1E1B26),
//                       ),
//                       padding: const EdgeInsets.only(left: 18),
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 15),
//                     )
//                         : Container(
//                       width:
//                       MediaQuery.of(context).size.width / 1.7,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF1E1B26),
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       padding: const EdgeInsets.only(left: 18),
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 15),
//                       child: TextField(
//                         readOnly: true,
//                         decoration: InputDecoration(
//                           hintText: "Type Something...",
//                           hintStyle: const TextStyle(
//                               color: Colors.white54),
//                           contentPadding:
//                           const EdgeInsets.only(top: 16),
//                           border: InputBorder.none,
//                           suffixIcon: IconButton(
//                             onPressed: _pickFile,
//                             icon: Icon(Icons.adaptive.share),
//                             color: Colors.white54,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: _refreshWave,
//                     icon: Icon(
//                       isRecording ? Icons.refresh : Icons.send,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   IconButton(
//                     onPressed: _startOrStopRecording,
//                     icon: Icon(isRecording ? Icons.stop : Icons.mic),
//                     color: Colors.white,
//                     iconSize: 28,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _startOrStopRecording() async {
//     try {
//       if (isRecording) {
//         recorderController.reset();
//
//         final path = await recorderController.stop(false);
//
//         if (path != null) {
//           isRecordingCompleted = true;
//           debugPrint(path);
//           debugPrint("Recorded file size: ${File(path).lengthSync()}");
//         }
//       } else {
//         await recorderController.record(path: path!);
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     } finally {
//       setState(() {
//         isRecording = !isRecording;
//       });
//     }
//   }
//
//   void _refreshWave() {
//     if (isRecording) recorderController.refresh();
//   }
// }