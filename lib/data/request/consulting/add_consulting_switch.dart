class AddConsultingSwitch{
  int? consultingid;
  String? status;

  AddConsultingSwitch({this.consultingid , this.status});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['consulting_id'] = this.consultingid;
    data['status'] = this.status;

    return data;
  }
}