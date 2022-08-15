class ChangePasswordRequest {
  String? password;

  ChangePasswordRequest({this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    return data;
  }
}
