import 'package:equatable/equatable.dart';

enum AccountType { consultant, association, people }

extension ParseToString on AccountType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object?> get props => [];
}

class SelectedAccountTypeEvent extends RegisterEvent {
  final AccountType? type;
  const SelectedAccountTypeEvent({this.type});
  @override
  List<Object?> get props => [type];
}

class SuccessSendVerifyCodeEvent extends RegisterEvent {
  final String? phone;
  const SuccessSendVerifyCodeEvent({this.phone});
  @override
  List<Object?> get props => [phone];
}

class SuccessVerifyPhoneEvent extends RegisterEvent {
  final int? phoneId;
  const SuccessVerifyPhoneEvent({this.phoneId});
  @override
  List<Object?> get props => [phoneId];
}
