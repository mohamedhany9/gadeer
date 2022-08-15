import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/custom_text_field.dart';
import 'package:gadeer/data/request/auth/send_reset_password.request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/helper/validator.dart';
import 'package:gadeer/modules/login/service/login.service.dart';
import 'package:get/get.dart';


class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController phone = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final LoginService _loginSerrvice =Get.find<LoginService>();

  bool autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Container(
          height: 300,
          margin: EdgeInsets.symmetric(horizontal: 32),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            elevation: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "استعاده كلمه المرور",
                      style: TextStyles.subTitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    buildTextField(
                      label: "رقم الجوال",
                      cont: phone,
                      hint: "966453548697",
                      autoValidate: autoValidate,
                      validator: Validator.phone ,
                      suffix: Icon(Icons.phone),
                      type: TextInputType.phone,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: CustomButton("تأكيد", () {
                          autoValidate = true;
                          setState(() {});
                          if (_formKey.currentState!.validate()) {
                            Notifications.showLoading();
                            _loginSerrvice
                                .resetPassword(
                                    request:
                                        SendResetRequest(phone: phone.text))
                                .then((response) {
                              Notifications.hideLoading();
                              if (response.status == 1) {
                                Navigator.pop(context);
                                Notifications.success(response.message);
                              } else {
                                Notifications.error(response.message);
                              }
                            }).catchError((e) {
                              Notifications.hideLoading();
                              Notifications.error(Constants.netError);
                            });
                          }
                        })),
                        SizedBox(
                          width: 16,
                        ),
                        Flexible(
                          child: CustomButton(
                            "رجوع",
                            () {
                              print("back");
                              Navigator.pop(context);
                            },
                            color: Colors.red,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
