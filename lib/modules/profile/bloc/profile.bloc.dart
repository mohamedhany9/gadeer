import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/response/profile/profile.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/profile/bloc/profile.state.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:get/get.dart';

class ProfileBloc extends Cubit<ProfileState> {
  final ProfileService _profileService = Get.find();
  ProfileBloc() : super(ProfileState()) {
    initProfile();
  }

  initProfile() async {
    late ProfileResponse response;
    await _profileService.getProfile().then((res) {
      response = res;
      Get.find<HomeController>().updateIsCompleted(res.profile);
    }).catchError((e) {
      Notifications.error(Constants.netError);
    });

    emit(state.copyWith(profile: response.profile));
  }

  updateProfile(ProfileModel? profileModel) async {
    emit(state.copyWith(profile: profileModel));
    Get.find<HomeController>().updateIsCompleted(profileModel);
  }
}
