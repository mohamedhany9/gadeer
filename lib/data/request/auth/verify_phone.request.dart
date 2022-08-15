class VerifyPhoneRequest {
  String? phone;
  String? code;

  VerifyPhoneRequest({this.phone, this.code});

  Map<String, String?> toMap() {
    final Map<String, String?> data = new Map<String, String?>();
    data['phone'] = this.phone;
    data['code'] = this.code;
    return data;
  }
}
