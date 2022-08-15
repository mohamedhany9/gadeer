import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/call.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_page/empty_list.widget.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'add_offline_time.widget.dart';

class OfflineTimesTab extends StatelessWidget {
  OfflineTimesTab({Key? key}) : super(key: key);
  final ConsultingBloc consultingBloc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: consultingBloc.state.current?.calls?.isNotEmpty == true
                  ? ListView.separated(
                      separatorBuilder: (c, i) {
                        return Divider();
                      },
                      padding: EdgeInsets.zero,
                      itemCount:
                          consultingBloc.state.current?.calls?.length ?? 0,
                      itemBuilder: (c, i) {
                        return _OfflineTimeItem(
                            consultingBloc.state.current!.calls![i]);
                      })
                  : EmptyListWidget("لا يوجد اوقات  للاستشاره")),
          SizedBox(
            height: 8,
          ),
          if (consultingBloc.state.current?.status == "in progress" &&
              Get.find<AccountBloc>().state.accountType ==
                  AccountType.consultant)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomButton("اضافه وقت للاستشاره", () {
                Get.to(
                  AddOfflineTimeWidget(null),
                );
              }),
            ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

//tiny widgets

class _OfflineTimeItem extends StatelessWidget {
  const _OfflineTimeItem(this.callModel, {Key? key}) : super(key: key);
  final CallModel callModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (callModel.user?.id == Get.find<AccountBloc>().state.user?.id) {
          Get.to(AddOfflineTimeWidget(callModel));
        }
      },
      child: Container(
        color: Colors.white,
        //margin: EdgeInsets.symmetric(vertical: 3),
        child: ListTile(
          tileColor: Colors.white,
          leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(callModel.user?.photo ?? "")),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(callModel.user?.name ?? ""),
              if (callModel.user?.id == Get.find<AccountBloc>().state.user?.id)
                InkWell(
                    onTap: () async {
                      Notifications.confirmDialog(
                          title: "حذف وقت الاستشاره",
                          content: "هل انت متأكد من رغبتك بعمل الحذف",
                          confirmText: "تأكيد",
                          cancelText: "الغاء",
                          onConfirm: () {
                            _deleteTime();
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Icon(
                        Icons.cancel,
                        size: 20,
                        color: Colors.red,
                      ),
                    )),
            ],
          ),
          subtitle: AutoSizeText(
            "وسيله الاستشاره ${callModel.typeText} في ${callModel.date} لمده  ${Duration(seconds: callModel.duration ?? 0).inMinutes} دقيقه",
            style: TextStyles.hint,
            maxLines: 1,
            minFontSize: 11,
            maxFontSize: 14,
          ),
        ),
      ),
    );
  }

  Future _deleteTime() async {
    Notifications.showLoading();
    await Get.find<ConsultingService>()
        .deleteOfflineTime(Get.find<ConsultingBloc>().state.current?.id ?? 0,
            callModel.id ?? 0)
        .then((value) async {
      Notifications.hideLoading();

      if (value.status == 1) {
        Get.find<ConsultingBloc>().updateSyncConsulting(value.consulting);
      } else {
        Notifications.error("فشل العملية");
      }
    }).catchError((e) {
      Notifications.hideLoading();

      print(e.toString());
      Notifications.error(Constants.netError);
    });
  }
}
