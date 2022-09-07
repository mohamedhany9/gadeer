import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/data/model/user.model.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_state.dart';
import 'package:gadeer/modules/account/service/account_service.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class AccountBloc extends Cubit<AccountState> {
  final AccountService _accountService = Get.find();
  AccountBloc() : super(AccountState());

  initAccount(UserModel? userModel) {
    emit(state.copyWith(
        user: userModel,
        accountType: userModel?.membershipType == "consultant"
            ? AccountType.consultant : userModel?.membershipType == "association"
            ? AccountType.association : AccountType.user));
  }

  updateAccount(UserModel userModel) async {
    emit(state.copyWith(user: userModel));
    Get.find<HomeController>().update();
  }

  changeAvatar(File image) async {
    UserModel userModel = UserModel(
        firstName: state.user?.firstName,
        lastName: state.user?.lastName,
        gender: state.user?.gender,
        email: state.user?.email,
        emailVerifiedAt: state.user?.emailVerifiedAt,
        isActive: state.user?.isActive,
        number: state.user?.number,
        status: state.user?.status,
        membershipType: state.user?.membershipType,
        phone: state.user?.phone,
        section: state.user?.section,
        photo: state.user?.photo,
        id: state.user?.id,
        jobTitle: state.user?.jobTitle,
        area: state.user?.area,
        consultingSeconds: state.user?.consultingSeconds,
        establishDate: state.user?.establishDate,
        meetingSeconds: state.user?.meetingSeconds,
        city: state.user?.city,
        fullName: state.user?.fullName,
        rate: state.user?.rate,
        timeLines: state.user?.timeLines,
        idNumber: state.user?.idNumber);
    Notifications.showLoading();
    await _accountService.changeAvatar(image).then((res) {
      Notifications.hideLoading();
      if (res.status == 0) {
        Notifications.error("خطأ في تحديث الصورة الشخصية");
      } else {
        Notifications.success("تم تحديث الصورة الشخصية بنجاح");

        userModel.photo = res.profile?.photo;
      }
    }).catchError((e) {
      print(e.toString());
      Notifications.hideLoading();

      Notifications.error(Constants.netError);
    });

    emit(state.copyWith(user: userModel));
  }

  updateAccountAsync() async {
    await Get.find<AccountService>().getAccount().then((value) {
      if (value.user != null) {
        emit(state.copyWith(user: value.user));
        Get.find<HomeController>().update();
      }
    });
  }
}
