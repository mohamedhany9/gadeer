import 'package:equatable/equatable.dart';
import 'package:gadeer/data/model/user.model.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';

class AccountState extends Equatable {
  final UserModel? user;
  final AccountType? accountType;

  AccountState({
    this.user,
    this.accountType,
  });

  AccountState copyWith({
    UserModel? user,
    AccountType? accountType,
  }) {
    return AccountState(
      accountType: accountType ?? this.accountType,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        user,
        accountType,
      ];
}
