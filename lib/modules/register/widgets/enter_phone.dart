import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/custom_text_field.dart';
import 'package:gadeer/data/request/auth/send_verify_phone.request.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/helper/validator.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:gadeer/modules/register/service/register.service.dart';
import 'package:get/get.dart';

class EnterPhone extends StatefulWidget {
  EnterPhone();
  @override
  _EnterPhoneState createState() => _EnterPhoneState();
}

class _EnterPhoneState extends State<EnterPhone> {
  final _formKey = GlobalKey<FormState>();
  final RegisterBloc registerBloc = Get.find();

  TextEditingController phone = TextEditingController();
  bool autoValidate = false;

  final RegisterService _registerService = Get.find<RegisterService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 32,
            ),
            SizedBox(
              height: 24,
            ),
            Text("ادخل رقم الجوال"),
            SizedBox(
              height: 16,
            ),
            buildTextField(
              label: "رقم الجوال",
              cont: phone,
              hint: "9665xxxxxxxx",
              autoValidate: autoValidate,
              validator: Validator.phone,
              suffix: Icon(Icons.phone),
              type: TextInputType.phone,
            ),
            SizedBox(
              height: 32,
            ),
            SizedBox(
              width: 150,
              child: CustomButton("متابعه", () {
                print("متابعه");
                autoValidate = true;
                setState(() {});
                if (_formKey.currentState!.validate()) {
                  Notifications.showLoading();
                  _registerService
                      .sendVerifyCode(
                          request: SendVerifyPhoneRequest(phone: phone.text))
                      .then((response) {
                    Notifications.hideLoading();
                    if (response.status == 1) {
                      if (response.phoneId == null) {
                        registerBloc
                            .add(SuccessSendVerifyCodeEvent(phone: phone.text));
                        Notifications.success(response.message);
                      } else {
                        registerBloc.add(
                            SuccessVerifyPhoneEvent(phoneId: response.phoneId));
                      }
                    } else {
                      Notifications.error(response.message);
                    }
                  }).catchError((e) {
                    Notifications.hideLoading();
                    Notifications.error(Constants.netError);
                  });
                }
              }),
            ),
            SizedBox(
              height: 32,
            ),
            Text("سيتم ارسال رقم مكون من 4 ارقام")
          ],
        ),
      ),
    );
  }
}
