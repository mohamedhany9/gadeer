mixin BaseResponse<T> {
  int? status;
  String? message;
  Map<String, dynamic>? errors;
  List<T>? data;

  fromJson(Map<String, dynamic> json, {T builder(Map<String, dynamic> item)?}) {
    status = json['status'];
    message = json['message'];
    errors = json['errors'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((item) {
        data?.add(builder!(item));
      });
    }
  }
}
