import 'package:equatable/equatable.dart';
import 'package:gadeer/data/model/consulting.model.dart';
import 'package:gadeer/data/model/consulting_details_model.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/response/home/home.response.dart';

class ConsultingState extends Equatable {
  final List<ConsultingModel?>? allConsults;
  final List<ConsultingStatusModel?>? consultingStates;
  final int? initialIndex;
  final ConsultingDetailsModel? current;

  ConsultingState(
      {this.allConsults,
      this.current,
      this.initialIndex,
      this.consultingStates});

  ConsultingState copyWith(
      {List<ConsultingModel?>? allConsults,
      ConsultingDetailsModel? current,
      List<MeetingModel?>? meetings,
      int? initialIndex,
      List<ConsultingStatusModel>? consultingStates}) {
    return ConsultingState(
      initialIndex: initialIndex ?? this.initialIndex,
      allConsults: allConsults ?? this.allConsults,
      current: current ?? this.current,
      consultingStates: consultingStates ?? this.consultingStates,
    );
  }

  @override
  List<Object?> get props =>
      [allConsults, current, consultingStates, initialIndex];
}
