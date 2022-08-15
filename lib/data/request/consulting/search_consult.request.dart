class ConsultingSearchRequest {
  String jobTitle = "";
  int area = -1;
  int city = -1;
  List<int?> categories = [];

  ConsultingSearchRequest(
      {this.jobTitle = "",
      this.area = -1,
      this.city = -1,
      this.categories = const []});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jobTitle.isNotEmpty) {
      data['job_title'] = this.jobTitle;
    }
    if (this.area != -1) {
      data['area'] = this.area;
    }
    if (this.city != -1) {
      data['city'] = this.city;
    }
    if (this.categories.isNotEmpty) {
      data['categories'] = this.categories;
    }

    return data;
  }
}
