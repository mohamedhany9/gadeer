import 'dart:async';

import 'package:gadeer/data/model/assosiation_section.dart';
import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/model/consulting.model.dart';
import 'package:gadeer/data/model/consulting_details_model.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/model/naitionality_model.dart';
import 'package:gadeer/data/model/parnet_model.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/response/home/home.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/home/service/home.service.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:gadeer/data/service/data.service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HomeService homeService = Get.find();
  final AccountBloc accountBloc = Get.find();
  HomeResponse? homeResponse;
  bool isVerified = true;
  bool hourPriceNotSet = false;
  final DataService _dataService = Get.find();

  //presestant data
  List<CityModel> areas = [];
  List<CityModel> cities = [];
  List<PartnersModel> partner = [];
  List<int> hourPrices = [];
  List<NationalityModel> nationality = [];
  List<AssosiationSection> sections = [];
  List<CategoryModel> categories = [];

  Future getHome() async {
    await Get.find<HomeService>().getHome().then((value) {
      homeResponse = value;
      update();
    }).catchError((e) {
      Notifications.error(Constants.netError);
    });
  }

  Future getDependencies() async {
    areas = (await _dataService.getAreas()).data ?? [];
    partner = (await _dataService.getPartners()).data ?? [];
    nationality = (await _dataService.getNationality()).data ?? [];
    cities = (await _dataService.getCities(
                areaId: Get.find<AccountBloc>().state.user?.area?.id ?? 1))
            .data ??
        [];
    sections = (await _dataService.getSections()).data ?? [];
    categories = (await _dataService.getCategories()).data ?? [];
    hourPrices = (await _dataService.getHourPrices()).prices;
  }

  Future verifyEmail() async {
    isVerified = true;
    update();
  }

  void updateIsCompleted(ProfileModel? profileModel) {
    bool isComplete = false;
    isVerified = accountBloc.state.user?.emailVerifiedAt != null;
    if (accountBloc.state.accountType == AccountType.association) {
      if (profileModel?.sections?.isNotEmpty == true) {
        isComplete = true;
      }
    } else {
      if (profileModel?.categories?.isNotEmpty == true &&
          profileModel?.educations?.isNotEmpty == true &&
          profileModel?.workExperiences?.isNotEmpty == true) {
        isComplete = true;
      }
      if (profileModel?.price == null) {
        hourPriceNotSet = true;
      } else {
        hourPriceNotSet = false;
      }
    }
    homeResponse?.isCompleted = isComplete;
    print("hourprice $hourPriceNotSet");
    update();
  }

  updateConsulting(ConsultingModel consultingModel) {
    homeResponse?.inProgressConsultings?.forEach((element) {
      if (element.id == consultingModel.id) {
        consultingModel = element;
        update();
      }
    });
  }
}
