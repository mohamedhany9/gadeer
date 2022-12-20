import 'package:flutter/material.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:gadeer/modules/account/widgets/account_grid.dart';
import 'package:gadeer/component/account_header.widget.dart';
import 'package:gadeer/modules/account/widgets/call_us.widget.dart';
import 'package:gadeer/modules/account/widgets/delete_user.dart';
import 'package:get/get.dart';

import 'bloc/account_bloc.dart';

final HiveService _hiveService = Get.find();

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AccountHeaderWidget(),
          SizedBox(
            height: 8,
          ),
          Get.find<AccountBloc>().state.user?.number != null ?Text("رقم العضوية : ${Get.find<AccountBloc>().state.user?.number}") : Container(),
          AccountGrid(),
          CallUsWidget(),
          DeleteUserWidget()
        ],
      ),
    );
  }
}
