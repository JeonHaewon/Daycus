import 'package:daycus/backend/Api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  //var uri = Uri.parse("http://10.8.1.148/api_members/mission/upload.php");

  //String do_id = widget.do_mission_data['do_id'];

  //이미지 업로드
  bool success = false;
  var uri = Uri.parse(API.imageUpload);
  var request = http.MultipartRequest('POST', uri);
  request.fields['image_folder'] = folderName;
  request.fields['source'] = source;
  var pic = await http.MultipartFile.fromPath("image", image!.path);
  request.files.add(pic);
  var response = await request.send();

  final result = await response.stream.bytesToString();

  // 이미지 업로드에 대한 테스트
  if (response.statusCode == 200 && jsonDecode(result)['connection']==true) {
    success = true;
    print("이미지가 업로드 되었습니다.");
    if ((do_id == null && todayBlockCnt == null)){
      return true;
    }
  } else {
    print(result);
    print("image not upload");
    if ((do_id != null && todayBlockCnt != null)){
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
        // 이름을 바꿀 수 없는 상황?
      }
    }
  }

}