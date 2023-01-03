import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:daycus/backend/Api.dart';
import 'package:flutter/material.dart';

image_download(String folder, String imageName) async {

  int degree = 0;
  Image? downloadImage = null;

  try{
    var update_res = await http.post(Uri.parse(API.imageDownload),
        body: {
          "folder" : folder,
          "imageName" : imageName,
        });

    if (update_res.statusCode == 200) {
      print("이미지를 불러왔습니다 : ");
      var res = jsonDecode(update_res.body);
      Uint8List bytes = Base64Decoder().convert(res['image']);
      print("${res['size1'].toStringAsFixed(2)} kb > ${res['size2'].toStringAsFixed(2)} kb, ${res['exif']}");
      //print(bytes.isEmpty);

      if (res['exif']==3){degree = 180;}
      else if (res['exif']==6){degree = 90;}
      else if (res['exif']==8){degree = 270;}
      else{degree = 0;}

      if (bytes.isEmpty){downloadImage = null;
      } else{
        downloadImage = Image.memory(bytes);
      }

      return [downloadImage, degree];

    } else {
      print("<error : > ${update_res.body}");
      return [null, degree];
    }
  }
  catch (e) {
    print(e.toString());
    //Fluttertoast.showToast(msg: e.toString());
    return [downloadImage, degree];
  }
}