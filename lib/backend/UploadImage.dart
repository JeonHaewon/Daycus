import 'package:daycus/backend/Api.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/widget/certifyTool/record/audio_player.dart';
import 'package:daycus/widget/certifyTool/record/recordWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

File? image;
String? imageReNamed;

// 사진을 찍을 수 있도록
Future getImage(String todayString, source) async {
  final ImagePicker picker = ImagePicker();
  // 갤러리 열기 : 성공
  //var pickedFile = await picker.pickImage(source: ImageSource.gallery);
  var pickedFile = await picker.getImage(source: source);

  print('Original path: ${pickedFile!.path}');

  String image_path = pickedFile!.path;
  String dir = path.dirname(pickedFile!.path);

  // jpg나 png파일만 업로드 가능.
  if (image_path.endsWith(".jpg")){
    imageReNamed = todayString+".jpg";
    String newPath = path.join(dir, imageReNamed);
    print('NewPath: ${newPath}');
    image = await File(pickedFile.path).copy(newPath);
    //

  } else if (image_path.endsWith(".png")){
    imageReNamed = todayString+".jpg";
    String newPath = path.join(dir, imageReNamed);
    print('NewPath: ${newPath}');
    image = await File(pickedFile.path).copy(newPath);
  }

  return image;
}

// 사진 업로드
Future uploadImage
    (String pictureName, String folderName, String source, String? do_id, int? todayBlockCnt) async {

  //이미지 업로드
  try{
    bool success = false;
    var uri = Uri.parse(API.imageUpload);
    var request = http.MultipartRequest('POST', uri);
    request.fields['image_folder'] = folderName;
    request.fields['source'] = source;
    var pic = await http.MultipartFile.fromPath("image", image!.path);
    print("이미지 업로드 runtime type : ${image!.path.runtimeType}");
    request.files.add(pic);
    var response = await request.send();

    final result = await response.stream.bytesToString();

    // 이미지 업로드에 대한 테스트
    if (response.statusCode == 200 &&
        jsonDecode(result)['connection'] == true) {
      success = true;
      print("이미지가 업로드 되었습니다.");
      if ((do_id == null && todayBlockCnt == null)) {
        return true;
      }
    } else {
      print(result);
      print("image not upload");
      if ((do_id != null && todayBlockCnt != null)) {
        return false;
      }
    }

    if (do_id != null && todayBlockCnt != null) {
      // do_mission에 기록
      var update_res = await http.post(Uri.parse(API.update), body: {
        'update_sql':
            "UPDATE DayCus.do_mission SET d${todayBlockCnt} = '${imageReNamed}' WHERE (do_id = '${do_id}')",
      });

      // do_mission 반영에 대한 테스트
      if (update_res.statusCode == 200) {
        print("출력 : ${update_res.body}");
        var res_update = jsonDecode(update_res.body);
        if (res_update['success'] == true && success == true) {
          print("이미지 정보가 데이터 베이스에 저장되었습니다.");
          //Fluttertoast.showToast(msg: "성공적으로 반영되었습니다");
          return true;
        } else {
          print("이미지 정보가 데이터 베이스 저장에 실패했습니다.");
          print("message : ${res_update['success']}");
          return false;
        }
      }
    }
  }
  on Exception catch (e) {
    last_error = "image uploaded error : $e";
    Fluttertoast.showToast(msg: "다시 시도해주세요");
    return false;
  }

}




// 사진 업로드
Future justUploadImage
    (String pictureName, String folderName, ) async {
  //이미지 업로드
  try {
    var uri = Uri.parse(API.justImageUpload);
    var request = http.MultipartRequest('POST', uri);
    request.fields['image_folder'] = folderName;

    var pic = await http.MultipartFile.fromPath("image", image!.path);
    request.files.add(pic);
    var response = await request.send();

    final result = await response.stream.bytesToString();

    // 이미지 업로드에 대한 테스트
    if (response.statusCode == 200 && jsonDecode(result)['connection']==true) {
      print("프로필 사진이 업로드 되었습니다.");
      return true;


    } else {
      print(result);
      print("이미지 업로드에 실패하였습니다.");
      return false;

    }
  } on Exception catch (e) {
    last_error = "image uploaded error : $e";
    Fluttertoast.showToast(msg: "다시 시도해주세요");
    return false;
  }


}


// 오디오 업로드
// Future justUploadAudio
//     (String pictureName, {String folderName = "test"} , sour) async {
//   //이미지 업로드
//   try {
//     var uri = Uri.parse(API.justImageUpload);
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['image_folder'] = folderName;
//
//     var audio = await http.MultipartFile.fromBytes("audio", image!.path);
//     request.files.add(audio);
//     var response = await request.send();
//
//     final result = await response.stream.bytesToString();
//
//     // 이미지 업로드에 대한 테스트
//     if (response.statusCode == 200 && jsonDecode(result)['connection']==true) {
//       print("오디오 데이터가 업로드 되었습니다.");
//       return true;
//
//
//     } else {
//       print(result);
//       print("오디오 데이터 전송에 실패하였습니다.");
//       return false;
//
//     }
//   } on Exception catch (e) {
//     last_error = "audio uploaded error : $e";
//     Fluttertoast.showToast(msg: "다시 시도해주세요");
//     return false;
//   }
//
//
// }

// 오디오 파일 업로드
Future uploadAudio
    (String pictureName, String folderName, {String? do_id = null, int? todayBlockCnt=null}) async {

  try{
    bool success = false;
    var uri = Uri.parse(API.justAudioUpload);
    var request = http.MultipartRequest('POST', uri);
    request.fields['folder'] = folderName;
    //request.fields['source'] = "audio"; //source;

    print("오디오 데이터 FilePath : ${FilePath}");
    print("오디오 데이터 이름 : ${uploadAudioPath}");
    //Map<String, String> headers = {"Authorization" : "daycus", "ClientID" : "daycus"};
    //request.headers.addAll(headers);
    var audio = await http.MultipartFile.fromPath("audio", FilePath!, contentType: MediaType("audio", "m4a"));
    print(audio.runtimeType);
    request.files.add(audio);

    var response = await request.send();
    final result = await response.stream.bytesToString();

    // 이미지 업로드에 대한 테스트
    if (response.statusCode == 200 &&
        jsonDecode(result)['connection'] == true) {
      success = true;
      print("오디오가 업로드 되었습니다.");
      if ((do_id == null && todayBlockCnt == null)) {
        return true;
      }
    } else {
      print(result);
      print("audio not upload");
      if ((do_id != null && todayBlockCnt != null)) {
        return false;
      }
    }

    // if (do_id != null && todayBlockCnt != null) {
    //   // do_mission에 기록
    //   var update_res = await http.post(Uri.parse(API.update), body: {
    //     'update_sql':
    //     "UPDATE DayCus.do_mission SET d${todayBlockCnt} = '${imageReNamed}' WHERE (do_id = '${do_id}')",
    //   });
    //
    //   // do_mission 반영에 대한 테스트
    //   if (update_res.statusCode == 200) {
    //     print("출력 : ${update_res.body}");
    //     var res_update = jsonDecode(update_res.body);
    //     if (res_update['success'] == true && success == true) {
    //       print("이미지 정보가 데이터 베이스에 저장되었습니다.");
    //       //Fluttertoast.showToast(msg: "성공적으로 반영되었습니다");
    //       return true;
    //     } else {
    //       print("이미지 정보가 데이터 베이스 저장에 실패했습니다.");
    //       print("message : ${res_update['success']}");
    //       return false;
    //     }
    //   }
    // }
  }
  on Exception catch (e) {
    last_error = "audio uploaded error : $e";
    Fluttertoast.showToast(msg: "다시 시도해주세요");
    return false;
  }

}