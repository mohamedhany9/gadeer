class ProfileWorkRequest {
  final String? title;
  final String? description;
  final String? place;
  final String? from;
  final String? to;

  ProfileWorkRequest({
    this.title,
    this.description,
    this.place,
    this.from,
    this.to,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['place'] = this.place;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}
