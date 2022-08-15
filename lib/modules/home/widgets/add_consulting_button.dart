import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/pages/add_consulting_form.widget.dart';
import 'package:get/get.dart';

class AddConsultingButton extends StatelessWidget {
  final String? status = Get.find<AccountBloc>().state.user!.status;
  final String tag;
  AddConsultingButton(this.tag);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        heroTag: tag,
        tooltip: "اضافه استشاره",
        backgroundColor: status == "approved" ? AppColors.primary : Colors.grey,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          if (status != "approved") {
            Notifications.error(status == "pending"
                ? Constants.pendingText
                : Constants.regectedText);
            return;
          }
          Get.to(AddConsultingFormWidget(null));
        });
  }
}
