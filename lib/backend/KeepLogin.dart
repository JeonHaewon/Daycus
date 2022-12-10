class KeepLogin {
  final String userName;
  final String user_email;
  final String password;


  KeepLogin(this.userName, this.user_email, this.password);

  KeepLogin.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        user_email = json['user_email'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
    'userName': userName,
    'user_email': user_email,
    'password': password,

  };
}