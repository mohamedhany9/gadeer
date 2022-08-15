class SendResetRequest {
  String? phone;
  SendResetRequest({this.phone});

  Map<String, String?> toMap() {
    final Map<String, String?> data = new Map<String, String?>();
    data['phone'] = this.phone;
    return data;
  }
}
