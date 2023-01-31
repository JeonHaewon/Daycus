// import 'dart:async';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_audio_streaming/flutter_audio_streaming.dart';
//
// class StreamingExample extends StatefulWidget {
//   const StreamingExample({Key? key}) : super(key: key);
//
//   @override
//   _StreamingExampleState createState() => _StreamingExampleState();
// }
//
// class _StreamingExampleState extends State<StreamingExample>
//     with WidgetsBindingObserver {
//   StreamingController controller = StreamingController();
//
//   //rtmp://global-live.mux.com:5222/app/fe05b077-2faa-0058-8d81-3a8a3ff02876
//   //rtmp://live.bdata.link/LiveApp/732489839033615006342724
//   TextEditingController _textFieldController = TextEditingController(
//       text: "rtmp://live.bdata.link/LiveApp/732489839033615006342724");
//   bool isVisible = true;
//   Timer? _timer;
//   int seconds = 0;
//   int minutes = 0;
//   int hours = 0;
//
//   String get textDateStream =>
//       "${_min(hours)} : ${_min(minutes)} : ${_min(seconds)}";
//
//   bool get isStreaming => controller.value.isStreaming ?? false;
//
//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }
//
//   @override
//   void dispose() async {
//     _timer?.cancel();
//     _timer = null;
//     WidgetsBinding.instance!.removeObserver(this);
//     super.dispose();
//     if (isStreaming) await controller.stop();
//     controller.dispose();
//   }
//
//   @override
//   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//     // App state changed before we got the chance to initialize.
//     // if (controller == null || !controller.value.isInitialized) {
//     //   return;
//     // }
//     // if (state == AppLifecycleState.paused) {
//     //   isVisible = false;
//     //   if (isStreaming) {
//     //     await pauseStreaming();
//     //   }
//     // } else if (state == AppLifecycleState.resumed) {
//     //   isVisible = true;
//     //   if (controller != null) {
//     //     if (isStreaming) {
//     //       await resumeStreaming();
//     //     }
//     //   }
//     // }
//   }
//
//   void initialize() async {
//     controller.addListener(() async {
//       if (controller.value.hasError) {
//         showInSnackBar('Camera error ${controller.value.errorDescription}');
//         await stopStreaming();
//       } else
//         try {
//           if (controller.value.event == null) return;
//           final Map<dynamic, dynamic> event =
//           controller.value.event as Map<dynamic, dynamic>;
//           print('Event: $event');
//           final String eventType = event['eventType'] as String;
//           switch (eventType) {
//             case StreamingController.ERROR:
//               break;
//             case StreamingController.RTMP_STOPPED:
//               break;
//             case StreamingController.RTMP_RETRY:
//               if (isVisible && isStreaming) {
//                 await stopStreaming();
//               }
//               break;
//           }
//         } catch (e) {
//           print('initialize: $e');
//         }
//     });
//     await controller.initialize();
//     controller.prepare();
//   }
//
//   Future<String> startStreaming() async {
//     if (!controller.value.isInitialized!) {
//       showInSnackBar('Error: is not Initialized.');
//       return '';
//     }
//     if (isStreaming) return '';
//     // Open up a dialog for the url
//     String url = await _getUrl();
//     try {
//       await controller.start(url);
//       hours = 0;
//       minutes = 0;
//       seconds = 0;
//       _timer = new Timer.periodic(
//         Duration(seconds: 1),
//             (Timer timer) => setState(
//               () {
//             seconds = seconds + 1;
//             if (seconds > 59) {
//               minutes += 1;
//               seconds = 0;
//               if (minutes > 59) {
//                 hours += 1;
//                 minutes = 0;
//               }
//             }
//           },
//         ),
//       );
//     } on AudioStreamingException catch (e) {
//       _showException("startStreaming", e);
//       return '';
//     }
//     return url;
//   }
//
//   Future<String> _getUrl() async {
//     // Open up a dialog for the url
//     String result = _textFieldController.text;
//
//     return await showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Url to Stream to'),
//             content: TextField(
//               controller: _textFieldController,
//               decoration: InputDecoration(hintText: "Url to Stream to"),
//               onChanged: (String str) => result = str,
//             ),
//             actions: <Widget>[
//               new TextButton(
//                 child: new Text(
//                     MaterialLocalizations.of(context).cancelButtonLabel),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               TextButton(
//                 child: Text(MaterialLocalizations.of(context).okButtonLabel),
//                 onPressed: () {
//                   Navigator.pop(context, result);
//                 },
//               )
//             ],
//           );
//         });
//   }
//
//   Future<void> stopStreaming() async {
//     if (!controller.value.isInitialized!) {
//       return;
//     }
//     if (!isStreaming) {
//       return;
//     }
//     try {
//       await controller.stop();
//       _timer?.cancel();
//       _timer = null;
//       setState(() {});
//     } on AudioStreamingException catch (e) {
//       _showException("stopStreaming", e);
//       return null;
//     }
//   }
//
//   void _showException(String at, AudioStreamingException e) {
//     log("AudioStreaming: Error at $at \n${e.code}\n${e.description}");
//     showInSnackBar('$at Error: ${e.code}\n${e.description}');
//   }
//
//   String _min(int _) {
//     if (_ < 10) return "0$_";
//     return _.toString();
//   }
//
//   void showInSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(message),
//       duration: const Duration(seconds: 1),
//       action: SnackBarAction(
//         label: 'OK',
//         onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
//       ),
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Audio streaming example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               textDateStream,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
//             ),
//             const SizedBox(
//               height: 32,
//             ),
//             ElevatedButton(
//                 onPressed: isStreaming ? stopStreaming : startStreaming,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(isStreaming
//                         ? Icons.stop_circle_outlined
//                         : Icons.play_circle_outline_outlined),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     Text(
//                       isStreaming ? "Stop" : "Start" + "Stream",
//                       style:
//                       TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     )
//                   ],
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
// }