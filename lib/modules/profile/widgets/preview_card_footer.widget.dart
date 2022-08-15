import 'package:flutter/material.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:get/get.dart';

class PreviewCardFooter extends StatelessWidget {
  const PreviewCardFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          Image.asset(
            Constants.logoWhite,
            height: 30,
          ),
          Spacer(),
          Text(
            "رقم العضويه: ",
            style: TextStyle(fontSize: 10, color: Colors.white),
          ),
          Text(
            Get.find<AccountBloc>().state.user?.number.toString() ?? "",
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
