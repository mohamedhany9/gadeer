class LoginRequest {
  String? phone;
  String? password;

  LoginRequest({this.phone, this.password});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['password'] = this.password;
    return data;
  }
}
