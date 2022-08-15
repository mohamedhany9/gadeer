import 'package:intl/intl.dart';

class AddOfflineTimeRequest {
  int? seconds;
  DateTime? date;
  String? type;
  String? other;

  AddOfflineTimeRequest(
      {required this.seconds,
      required this.date,
      required this.type,
      this.other});

  Map<String, dynamic> toJson() {
    DateFormat dt = DateFormat("yyyy-MM-dd");

    return {
      "duration": seconds,
      "date": date,
      "type": (other == null || other?.isEmpty == true) ? type : other,
      if (date != null) "date": dt.format(date ?? DateTime.now())
    };
  }
}
