class API{
  static const hostConnect = "http://43.200.192.77/api_members";
  // local
  //static const hostConnect = "http://10.8.49.61/api_members";
  static const hostConnectUser = "$hostConnect/user";

  static const signup = "$hostConnect/user/signup.php";
  static const login = "$hostConnect/user/login.php";
  static const validateEmail = "$hostConnect/user/validate_email.php";

  static const update = "$hostConnect/user/update.php";
  static const select = "$hostConnect/mission/mission_select.php";

  static const missionImport = "$hostConnect/mission/all_mission_import.php";
  static const imageUpload = "$hostConnect/mission/image_upload.php";
  static const justImageUpload = "$hostConnect/mission/image_just_uploaded.php";
  static const justAudioUpload = "$hostConnect/mission/audio_just_uploaded.php";
  static const imageDownload = "$hostConnect/image_download/image_download2.php";
  static const imageDownloadRoot = "$hostConnect/image_download/image_download_root.php";

  static const sendEmail = "$hostConnect/user/send_email.php";

  //static const imageDownloadLocal = "http://10.8.1.148/api_members/image_download.php";

  //static const sendEmail = "http://10.8.1.148/api_members/email.php";
}