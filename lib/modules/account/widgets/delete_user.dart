import 'package:flutter/material.dart';
import 'package:gadeer/modules/account/widgets/delete_user_pop.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';


import '../../../helper/app.theme.dart';


class DeleteUserWidget extends StatefulWidget {
  const DeleteUserWidget({Key? key}) : super(key: key);

  @override
  State<DeleteUserWidget> createState() => _DeleteUserWidgetState();
}

class _DeleteUserWidgetState extends State<DeleteUserWidget> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 12),
      child: InkWell(
        onTap: () async {
          Get.dialog(Dialog(child: DeleteUserPob()));
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "حذف الحساب",
                style: TextStyles.subTitleBold.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
