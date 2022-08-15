import 'package:equatable/equatable.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/model/user.model.dart';

class AppState extends Equatable {
  final bool? isLogin;
  final int? currentPage;
  final String? accessToken;
  final bool? byLink;
  final MeetingModel? meetingModel;
  AppState(
      {this.currentPage,
      this.isLogin,
      this.accessToken,
      this.byLink,
      this.meetingModel});

  AppState copyWith({
    bool? isLogin,
    int? currentPage,
    String? accessToken,
    bool? byLink,
    MeetingModel? meetingModel,
  }) =>
      AppState(
        isLogin: isLogin ?? this.isLogin,
        currentPage: currentPage ?? this.currentPage,
        accessToken: accessToken ?? this.accessToken,
        byLink: byLink ?? this.byLink,
        meetingModel: meetingModel ?? this.meetingModel,
      );

  @override
  List<Object?> get props =>
      [isLogin, currentPage, accessToken, byLink, meetingModel];
}
