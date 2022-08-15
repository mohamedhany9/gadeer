import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/custom_text_field.dart';
import 'package:gadeer/data/request/account/change_password.request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/helper/validator.dart';
import 'package:gadeer/modules/account/service/account_service.dart';
import 'package:get/get.dart';

class ChangePasswordPob extends StatefulWidget {
  @override
  _ChangePasswordPobState createState() => _ChangePasswordPobState();
}

class _ChangePasswordPobState extends State<ChangePasswordPob> {
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
                "تغيير كلمه المرور",
                style: TextStyles.title,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24,
              ),
              buildTextField(
                autoValidate: autoValidate,
                cont: password,
                isPassword: !showPassword,
                label: "كلمه المرور الجديده",
                validator: Validator.password,
                suffix: IconButton(
                    icon: FaIcon(
                      !showPassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    }),
              ),
              SizedBox(
                height: 24,
              ),
              buildTextField(
                autoValidate: autoValidate,
                cont: confirm,
                isPassword: !showPassword,
                label: "تأكيد كلمه المرور",
                validator: (String? e) {
                  if (e != password.text) {
                    return "يجب ان تتطابق كلمتي المرور";
                  }
                  return null;
                },
                suffix: IconButton(
                    icon: FaIcon(
                      !showPassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    }),
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
    autoValidate = true;

    setState(() {});
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      await Get.find<AccountService>()
          .changePassword(ChangePasswordRequest(password: password.text))
          .then((value) {
        if (value.status == 0) {
          Notifications.error(value.message);
        } else {
          Get.back();
          Notifications.success(value.message);
        }
      }).catchError((e) {
        Notifications.error(Constants.netError);
      });
      isLoading = false;
      setState(() {});
    }
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
