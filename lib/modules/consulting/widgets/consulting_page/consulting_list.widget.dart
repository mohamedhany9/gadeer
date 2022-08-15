import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/account_status.widget.dart';
import 'package:gadeer/component/consulting_item.widget.dart';
import 'package:gadeer/data/model/consulting.model.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'empty_list.widget.dart';

class ConsultingListWidget extends StatelessWidget {
  final List<ConsultingModel?> consults;

  final String? status = Get.find<AccountBloc>().state.user!.status;

  ConsultingListWidget(this.consults);
  final AccountType accountType = Get.find<AccountBloc>().state.accountType!;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          repeat: ImageRepeat.repeat,
          image: AssetImage(
            Constants.background1,
          ),
        ),
      ),
      height: size.height * .6,
      child: status != "approved"
          ? Center(child: AccountStatusWidget())
          : consults.isEmpty
              ? EmptyListWidget("لا يوجد استشارات توافق بحثك")
              : RefreshIndicator(
                  onRefresh: () async {
                    print("refresh");
                    await Get.find<ConsultingBloc>().getAllConsultantings();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: consults.length,
                    itemBuilder: (_, index) =>
                        ConsultingItemWidget(consults[index]!),
                    separatorBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ),
                ),
    );
  }
}
