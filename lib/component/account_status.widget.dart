import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:get/get.dart';

class AccountStatusWidget extends StatelessWidget {
  AccountStatusWidget({Key? key}) : super(key: key);
  final String? status = Get.find<AccountBloc>().state.user!.status;

  @override
  Widget build(BuildContext context) {
    String statusText = "";
    switch (status) {
      case "pending":
        statusText = Constants.pendingText;
        break;

      case "rejected":
        statusText = Constants.regectedText;
        break;

      case "processing":
        statusText = Constants.processing;
        break;

      case "re_apply":
        statusText = Constants.reApply;
        break;
      default:
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        statusText,
        textAlign: TextAlign.center,
        style: TextStyles.hint.copyWith(color: Colors.grey),
      ),
    );
  }
}
