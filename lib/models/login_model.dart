class LoginModel {
  String email;
  String password;

  LoginModel({this.email, this.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email != null ? email.trim() : '',
      'password': password != null ? password.trim() : '',
    };
    return map;
  }
}
