import 'package:flutter/material.dart';
import 'package:gadeer/modules/account/widgets/account_grid.dart';
import 'package:gadeer/component/account_header.widget.dart';
import 'package:gadeer/modules/account/widgets/call_us.widget.dart';
import 'package:get/get.dart';

import 'bloc/account_bloc.dart';

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
          Text("رقم العضويه : ${Get.find<AccountBloc>().state.user?.number}"),
          AccountGrid(),
          CallUsWidget()
        ],
      ),
    );
  }
}
