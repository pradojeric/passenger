class RegisterModel {
  String firstName;
  String lastName;
  String userName;
  String contact;
  String address;
  String email;
  String password;
  String confirmedPassword;
  double points;

  RegisterModel({
    this.firstName,
    this.lastName,
    this.confirmedPassword,
    this.points,
    this.userName,
    this.contact,
    this.address,
    this.email,
    this.password,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      firstName: json['first_name'],
      lastName: json['last_name'],
      userName: json['user_name'],
      contact: json['contact'],
      address: json['address'],
      points: json['points'] != null ? json['points'].toDouble() : 0,
      email: json['email'],
      password: json['password'],
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'name': userName != null ? userName.trim() : '',
      'contact': contact.trim(),
      'address': address.trim(),
      'email': email != null ? email.trim() : '',
      'password': password != null ? password.trim() : '',
      'password_confirmation': confirmedPassword != null ? confirmedPassword.trim() : '',
    };
    return map;
  }
}
