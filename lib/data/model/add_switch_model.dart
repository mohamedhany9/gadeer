class ConsultingSwichModel {
  int? id;
  String? status;


  ConsultingSwichModel(
      {this.id,
        this.status});

  ConsultingSwichModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    id = json['id'];

  }
}