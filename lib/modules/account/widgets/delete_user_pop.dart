import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/custom_text_field.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/data/request/account/change_password.request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/helper/validator.dart';
import 'package:gadeer/modules/account/service/account_service.dart';
import 'package:get/get.dart';

class DeleteUserPob extends StatefulWidget {
  @override
  _DeleteUserPobState createState() => _DeleteUserPobState();
}

class _DeleteUserPobState extends State<DeleteUserPob> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  bool showPassword = false;
  bool autoValidate = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "حذف الحساب",
                style: TextStyles.title,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24,
              ),
              _ActionsRow(
                isLoading: isLoading,
                onConfirm: () {
                  _onConfirm();
                },
              )
            ],
          ),
        ));
  }

  void _onConfirm() async {

    setState(() {});
      isLoading = true;
      setState(() {});
      await Get.find<AccountService>()
          .deleteaccount()
          .then((value) {
        if (value.status == 0) {
          Notifications.error(value.message);
        } else {
          Get.back();
          Notifications.success(value.message);
          Get.toNamed(Routes.login);
        }
      }).catchError((e) {
        Notifications.error(Constants.netError);
      });
      isLoading = false;
      setState(() {});

  }
}

//tiny widgets

class _ActionsRow extends StatelessWidget {
  const _ActionsRow(
      {Key? key, required this.isLoading, required this.onConfirm})
      : super(key: key);
  final bool isLoading;
  final Function onConfirm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : CustomButton("تأكيد", () async {
              onConfirm();
            })),
        SizedBox(
          width: 20,
        ),
        Flexible(
            child: CustomButton(
              "الغاء",
                  () {
                Get.back();
              },
              color: Colors.red,
            )),
      ],
    );
  }
}
