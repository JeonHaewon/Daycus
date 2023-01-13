class Userr{
  Userr(
      this.user_id,
      this.user_email,
      this.user_password,

      this.terms_service,
      this.terms_privacy,
      this.terms_market,
      );
  final int user_id;
  final String user_email;
  final String user_password;

  final bool terms_service;
  final bool terms_privacy;
  final bool terms_market;


  // factory User.fromJson(Map<String, dynamic> json) => User(
  //   int.parse(json['user_id']),
  //   json['user_name'],
  //   json['user_email'],
  //   json['user_password'],
  // );

  Map<String, dynamic> toJson() => {
    // 초기 이름은 이메일 앞에 땐거.
    'user_name' : user_email.split("@")[0],
    'user_id' : user_id.toString(),
    'user_email' : user_email,
    'user_password' : user_password,

    'terms_service' : (terms_service ? 1 : 0).toString(),
    'terms_privacy' : (terms_privacy ? 1 : 0).toString(),
    'terms_market' : (terms_market ? 1 : 0).toString(),
  };

}