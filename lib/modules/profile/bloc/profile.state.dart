import 'package:equatable/equatable.dart';
import 'package:gadeer/data/model/profile.model.dart';

class ProfileState extends Equatable {
  final ProfileModel? profile;
  ProfileState({this.profile});

  ProfileState copyWith({ProfileModel? profile}) => ProfileState(
        profile: profile ?? this.profile,
      );
  @override
  List<Object?> get props => [profile];
}
