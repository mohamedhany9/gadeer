import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/request/auth/send_verify_phone.request.dart';
import 'package:gadeer/data/request/auth/verify_phone.request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:gadeer/modules/register/service/register.service.dart';
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerificationCode extends StatefulWidget {
  VerificationCode();
  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final RegisterBloc registerBloc = Get.find();

  TextEditingController pinCode = TextEditingController();
  int time = 60;
  bool canResend = false;
  late Timer timer;
  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (time != 0) {
        canResend = false;
        time--;
        setState(() {});
      } else {
        canResend = true;
        setState(() {});
      }
    });
  }

  RegisterService _registerService = Get.find<RegisterService>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          SizedBox(
            height: 32,
          ),
          Text(
            "ادخل الرمز",
            style: TextStyles.subTitle,
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Directionality(
                textDirection: TextDirection.ltr,
                child: PinPut(
                  textStyle: TextStyles.subTitleBold,
                  eachFieldHeight: 60,
                  eachFieldWidth: 50,
                  fieldsCount: 4,
                  controller: pinCode,
                  keyboardType: TextInputType.number,
                  submittedFieldDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  followingFieldDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  disabledDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  selectedFieldDecoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: 60,
          ),
          Row(
            children: [
              Flexible(
                  flex: 1,
                  child: CustomButton("تأكيد", () {
                    if (pinCode.text.length == 4) {
                      Notifications.showLoading();
                      _registerService
                          .verifyPhone(
                              request: VerifyPhoneRequest(
                        phone: registerBloc.state.phone,
                        code: pinCode.text,
                      ))
                          .then((response) {
                        pinCode.clear();

                        Notifications.hideLoading();
                        if (response.status == 1) {
                          registerBloc.add(SuccessVerifyPhoneEvent(
                              phoneId: response.phoneId));
                        } else {
                          Notifications.error(response.message);
                        }
                      }).catchError((e) {
                        Notifications.hideLoading();
                        Notifications.error("خطأ في الشبكة");
                      });
                    }
                  })),
              SizedBox(
                width: 16,
              ),
              Flexible(
                flex: 1,
                child: CustomButton(
                  "اعاده الارسال",
                  !canResend
                      ? () {}
                      : () {
                          pinCode.clear();
                          Notifications.showLoading();
                          _registerService
                              .sendVerifyCode(
                                  request: SendVerifyPhoneRequest(
                            phone: registerBloc.state.phone,
                          ))
                              .then((response) {
                            Notifications.hideLoading();
                            if (response.status == 1) {
                              Notifications.success(response.message);
                            } else {
                              Notifications.error(response.message);
                            }
                          }).catchError((e) {
                            Notifications.hideLoading();
                            Notifications.error("خطأ في الشبكة");
                          });

                          time = 60;
                          canResend = false;
                          setState(() {});
                        },
                  color: canResend ? AppColors.primary : Colors.white,
                  textColor: canResend ? Colors.white : Colors.grey,
                  hasBorder: !canResend,
                ),
              )
            ],
          ),
          if (time > 0)
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                "اذا لم يصلك رمز التفعيل يمكنك اعادة الارسال بعد $time ثانية",
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
