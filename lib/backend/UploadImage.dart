import 'package:daycus/backend/Api.dart';
import 'package:daycus/backend/UserDatabase.dart';
import 'package:daycus/widget/certifyTool/record/audio_player.dart';
import 'package:daycus/widget/certifyTool/record/recordWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

File? image;
String? imageReNamed;

// 사진을 얻는 함수
Future getImage(String todayString, source) async {
  
  // 이미지를 얻을 수 있는 라이브러리
  final ImagePicker picker = ImagePicker();
  var pickedFile = await picker.getImage(source: source);

  //print('Original path: ${pickedFile!.path}');

  String image_path = pickedFile!.path; // 캐시파일 내 이미지
  String dir = path.dirname(pickedFile!.path); // 캐시파일 폴더

  // jpg나 png파일만 업로드 가능.
  if (image_path.endsWith(".jpg")){
    // ex ) 53_20230216_155702_29_341
    imageReNamed = todayString+".jpg";
    String newPath = path.join(dir, imageReNamed);
    //print('NewPath: ${newPath}');
    // 새로운 주소로 이미지를 복사
    image = await File(pickedFile.path).copy(newPath);
    // 제언 : 이미지를 삭제하여 트래픽을 줄이는 것이 좋을듯.

  } else if (image_path.endsWith(".png")){
    imageReNamed = todayString+".jpg";
    String newPath = path.join(dir, imageReNamed);
    print('NewPath: ${newPath}');
    image = await File(pickedFile.path).copy(newPath);
  }

  return image;
}

// 사진 업로드 : 미션 인증할때, 개발자에게 문의할때
Future uploadImage
    (String pictureName, String folderName, String source, String? do_id, int? todayBlockCnt) async {

  //이미지 업로드
  try{
    bool success = false;

    var uri = Uri.parse(API.imageUpload);

    // 파일 여러개를 보낸다 - 파일을 전송하는 / .fields : 같이 전송할 정보
    var request = http.MultipartRequest('POST', uri);
    request.fields['image_folder'] = folderName;
    // 갤러리인지 카메라인지
    request.fields['source'] = source;
    
    // 휴대폰 내 주소로 어떤 이미지를 보낼건지 알려주는 코드
    var pic = await http.MultipartFile.fromPath("image", image!.path);
    //print("이미지 업로드 runtime type : ${image!.path.runtimeType}");
    // 그 파일을 실질적으로 업로드
    request.files.add(pic);
    var response = await request.send();

    // 결과를 받음
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

    // 미션을 인증할때
    if (do_id != null && todayBlockCnt != null) {
      // do_mission에 기록
      var update_res = await http.post(Uri.parse(API.update), body: {
        'update_sql':
        "UPDATE DayCus.do_mission SET d${todayBlockCnt} = '${imageReNamed}' WHERE (do_id = '${do_id}')",
      });

      // do_mission 반영에 대한 테스트
      if (update_res.statusCode == 200) {
        //print("출력 : ${update_res.body}");
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
    (String audioName, String folderName, {String? do_id = null, int? todayBlockCnt=null}) async {

  try{
    bool success = false;
    var uri = Uri.parse(API.justAudioUpload);
    var request = http.MultipartRequest('POST', uri);
    request.fields['folder'] = folderName;

    //request.fields['source'] = "audio"; //source;


    // 이름 구해서 넣는거까지 해야함
    print("오디오 데이터 FilePath : ${FilePath}");
    print("오디오 데이터 이름 : ${uploadAudioPath}");

    // 확장자 찾는건데 아래 코드로는 작동이 안되는 것 같다.
    // if (FilePath!.isAudioFileName){
    //  print("맞음");
    // }

    // m4a만 들어감
    if (FilePath!.endsWith(".m4a")){
      //print("확장자 맞음 ");
      // print(FilePath!.split("."));
      String dir = path.dirname(FilePath!);
      //print("파일 이름 : ${dir}");
      String NewPath = path.join(dir, audioName+".m4a");
      //print(NewPath);

      // 새로운 이름으로 파일 복사
      var audio_copy = await File(FilePath!).copy(NewPath);

      var audio = await http.MultipartFile.fromPath("audio", NewPath!, contentType: MediaType("audio", "m4a"));
      //print(audio.runtimeType);
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

    }
     else {
       Fluttertoast.showToast(msg: "m4a 확장자만 업로드 가능합니다.\n개발자에게 문의하세요.");
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