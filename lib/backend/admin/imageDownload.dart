import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:daycus/backend/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:math';


Image? downloadImage = null;
var imageList = null;
int? imageListCnt = null;
int index = 0;
String folder = "water_glass";


class ImageDownload extends StatefulWidget {
  const ImageDownload({Key? key}) : super(key: key);

  @override
  State<ImageDownload> createState() => _ImageDownloadState();
}

class _ImageDownloadState extends State<ImageDownload> {

  int degree = 0;
  final TextEditingController folderCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    void importImageList(String folder) async {
      try {
        var select_res = await http.post(Uri.parse(API.select), body: {
          'update_sql': "SELECT * FROM image_data WHERE image_locate='${folder}'",
        });

        if (select_res.statusCode == 200 ) {
          var resMission = jsonDecode(select_res.body);
           print(resMission);
          if (resMission['success'] == true) {
            //Fluttertoast.showToast(msg: "이메일을 확인해주세요 !");
            imageList = resMission["data"];
            imageListCnt = resMission["data"]==null ? 0 : resMission["data"].length;
            print("imageListCnt : ${imageListCnt}");
          } else {
            Fluttertoast.showToast(msg: "문제가 발생했습니다");
          }

        }
      } on Exception catch (e) {
        print("에러발생 : ${e}");
        //Fluttertoast.showToast(msg: "미션을 신청하는 도중 문제가 발생했습니다.");
      }
    }



    image_download(String folder, String imageName) async {
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

          setState(() {
            if (res['exif']==3){degree = 180;}
            else if (res['exif']==6){degree = 90;}
            else if (res['exif']==8){degree = 270;}
            else{degree = 0;}

            if (bytes.isEmpty){downloadImage = null;
            } else{downloadImage = Image.memory(bytes);}

          });
          return true;

        } else {
          setState(() {
            downloadImage = null;
          });
          print("<error : > ${update_res.body}");
          return false;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   color: Colors.blue, width: 150.w, height: 140.w,
            //   child: Image.network("http://10.8.1.148/api_members/image_uploaded/1.jpg"),),
            
            
            Form(
              key: _formKey,
                child: Column(
                children: [
                  TextFormField(
                    controller: folderCtrl,
                  ),
                  
                  TextButton(onPressed: (){
                    setState(() {
                      folder = folderCtrl.text.trim();
                    });
                    Fluttertoast.showToast(msg: "폴더가 '${folder}'로 변경되었습니다.");
                  }, child: Text("폴더 변경")),
                ],
            )),


            TextButton(
                onPressed: (){
                  //image_download();
                },
                child: Text(" !!!"),
            ),

            TextButton(
              onPressed: (){
                importImageList(folder);
                image_download(folder, imageList[0]['image']);
                setState(() {
                  index = 0;
                });
              },
              child: Text("${folder} 에서 이미지 전체를 불러옵니다"),
            ),

            Row(
              children: [
                TextButton(
                  onPressed: (){
                    if (index == 0){
                      Fluttertoast.showToast(msg: "처음 사진입니다.");
                    } else{
                      index -= 1;
                      print("folder, imageList[index]['image'] : ${folder}, ${imageList[index]['image']}");
                      image_download(folder, imageList[index]['image']);
                      setState(() {});
                    }
                  },
                  child: Text("이전"),
                ),

                TextButton(
                  onPressed: (){
                    if (index+1 == imageListCnt){
                      Fluttertoast.showToast(msg: "마지막 사진입니다.");
                    } else{
                      index += 1;
                      print("folder, imageList[index]['image'] : ${folder}, ${imageList[index]['image']}");
                      image_download(folder, imageList[index]['image']);
                      setState(() {});
                    }
                  },
                  child: Text("다음"),
                ),
              ],
            ),

            Text("folder : ${folder}, index : ${index}, "),

            if(imageList!=null)
              Text("folder : ${imageList[index]['image']}, "),

            Container(
              width: 300.w, height: 600.w,
              child: downloadImage==null ? Text("이미지가 없습니다") : Transform.rotate(angle: degree * pi/180, child: downloadImage,),

            ),
          ],
        ),
      ),
    );
  }
}
