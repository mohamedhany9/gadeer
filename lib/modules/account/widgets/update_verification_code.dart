import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/data/request/auth/send_verify_phone.request.dart';
import 'package:gadeer/data/request/auth/verify_phone.request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_form.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/service/register.service.dart';
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';

class UpdateVerificationCode extends StatefulWidget {
  String oldphone;
  UpdateVerificationCode({required this.oldphone});
  @override
  _UpdateVerificationCodeState createState() => _UpdateVerificationCodeState();
}

class _UpdateVerificationCodeState extends State<UpdateVerificationCode> {
  final RegisterBloc registerBloc = Get.find();

  TextEditingController pinCode = TextEditingController();
  int time = 60;
  bool canResend = false;
  late Timer timer;

  late final AccountFormBloc _formBloc;

  @override
  void initState() {
    super.initState();
    _formBloc = AccountFormBloc();
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
    return Scaffold(
      appBar: buildAppBar("تعديل رقم الهاتف"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Image.asset("assets/images/logo-color.png",height: 200,),
              SizedBox(height: 20,),
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
                        print(widget.oldphone);
                        print(_formBloc.phoneNumber.value);
                        if (pinCode.text.length == 4) {
                          Notifications.showLoading();
                          _registerService
                              .verifyPhone(
                              request: VerifyPhoneRequest(
                                  phone: widget.oldphone,
                                  code: pinCode.text,
                                  area: _formBloc.area.value!.id.toString(),
                                  city: _formBloc.city.value!.id.toString(),
                                  email: _formBloc.email.value,
                                  first_name: _formBloc.fName.value,
                                  last_name: _formBloc.lName.value,
                                  gender: _formBloc.gender.value,
                                  new_phone: _formBloc.phoneNumber.value
                              ))
                              .then((response) {
                            pinCode.clear();

                            Notifications.hideLoading();
                            if (response.status == 1) {
                              print("succ");
                              // Get.back();
                              // Get.back();
                              Get.offAllNamed(Routes.main);
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
                              phone:  widget.oldphone,
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
