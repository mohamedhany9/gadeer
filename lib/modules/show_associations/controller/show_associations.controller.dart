import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:gadeer/modules/home/service/home.service.dart';
import 'package:get/get.dart';

class ShowAssociationsController extends GetxController {
  final consultingService = Get.find<ConsultingService>();
  final homeService = Get.find<HomeService>();

  List<ProfileModel>? assosiations = [];

  Future getAssosiations() async {
    if (assosiations?.isNotEmpty == true) {
      return;
    }
    Notifications.showLoading();
    assosiations = (await homeService.getUsers()).data;
    Notifications.hideLoading();
    update();
  }
}
