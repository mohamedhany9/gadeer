import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/request/consulting/search_consult.request.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/home/service/home.service.dart';
import 'package:gadeer/data/service/data.service.dart';
import 'package:get/get.dart';

class SearchConsultantsController extends GetxController {
  final consultingService = Get.find<ConsultingService>();
  final DataService dataService = Get.find<DataService>();
  final homeService = Get.find<HomeService>();

  List<ProfileModel>? consultants = [];
  List<CategoryModel>? categories = [];
  CategoryModel? selected;

  Future initData() async {
    if (consultants?.isNotEmpty == true) {
      return;
    }
    Notifications.showLoading();
    categories = Get.find<HomeController>().categories;
    print(categories?.length);
    consultants = (await homeService.getUsers()).data;
    update();
    Notifications.hideLoading();
  }

  Future searchConsultants({String jobTitle = ""}) async {
    Notifications.showLoading();
    await consultingService
        .searchConsulting(ConsultingSearchRequest(
            categories: selected?.id == null ? [] : [selected?.id],
            jobTitle: jobTitle))
        .then((value) {
      Notifications.hideLoading();

      consultants = value.data;
      update();
      if (consultants?.isEmpty == true) {
        Notifications.error("لم نجد خبير يوافق بحثك");
      }
    }).catchError((e) {
      Notifications.hideLoading();

      print(e.toString());
      Notifications.error(Constants.netError);
    });
  }
}
