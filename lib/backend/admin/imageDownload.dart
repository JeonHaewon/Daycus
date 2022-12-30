import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:daycus/backend/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;


Image? downloadImage = null;


class ImageDownload extends StatefulWidget {
  const ImageDownload({Key? key}) : super(key: key);

  @override
  State<ImageDownload> createState() => _ImageDownloadState();
}

class _ImageDownloadState extends State<ImageDownload> {


  @override
  Widget build(BuildContext context) {

    update_information_name() async {
      try{
        var update_res = await http.post(Uri.parse(API.imageDownload),
            body: {
              "folder" : "water_glass",
              "imageName" : "1_20221227_131632_20_108.jpg",
            });

        // print(Image.network("http://10.8.1.148/api_members/image_uploaded/1.jpg").runtimeType);
        // print(Image.network("http://10.8.1.148/api_members/image_download.php").runtimeType);

        if (update_res.statusCode == 200) {
          print(true);
          //print(update_res.body);
          //print(update_res.body);
          print(update_res.body);
          var res = jsonDecode(update_res.body);

          //print(res);
          Uint8List bytes = Base64Decoder().convert(res['image']);
          //print(res['size'].runtimeType);
          print("${res['size'].toStringAsFixed(2)} kb");
          print(bytes.isEmpty);

          setState(() {
            if (bytes.isEmpty){
              downloadImage = null;
            } else{
              downloadImage = Image.memory(bytes);
            }

          });
          return true;

        } else {
          print(update_res.body);
          return false;
          // 이름을 바꿀 수 없는 상황?
        }
      }
      catch (e) {
        print(e.toString());
        //Fluttertoast.showToast(msg: e.toString());
        return false;
      }
    }


    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            color: Colors.blue, width: 150.w, height: 140.w,
            child: Image.network("http://10.8.1.148/api_members/image_uploaded/1.jpg"),),

          Container(
            color: Colors.blue, width: 150.w, height: 140.w,
            child: Image.network("http://10.8.1.148/api_members/image_download.php"),),

          TextButton(
              onPressed: (){
                update_information_name();
              },
              child: Text("버튼"),
          ),

          Container(
            width: 150.w, height: 150.w,
            child: downloadImage==null ? Text("이미지가 없습니다") : downloadImage,
          ),
        ],
      ),
    );
  }
}
