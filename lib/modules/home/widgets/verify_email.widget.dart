import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/user.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/account/service/account_service.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:get/get.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerifyEmailWidget extends StatefulWidget {
  @override
  _VerifyEmailWidgetState createState() => _VerifyEmailWidgetState();
}

class _VerifyEmailWidgetState extends State<VerifyEmailWidget> {
  late TextEditingController code;
  final _formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  @override
  void initState() {
    super.initState();
    code = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            SizedBox(
              height: 12,
            ),
            Text(
              "تأكيد البريد الالكتروني",
              style: TextStyles.subTitle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            Directionality(
                textDirection: TextDirection.ltr,
                child: PinPut(
                  textStyle: TextStyles.subTitleBold,
                  eachFieldHeight: 60,
                  eachFieldWidth: 50,
                  fieldsCount: 4,
                  controller: code,
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
            SizedBox(
              height: 8,
            ),
            Text(
              "قم بكتابة رمز التحقق المرسل لبريدك الالكتروني",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  "تأكيد",
                  () {
                    _verifyEmail();
                  },
                  padding: 16,
                ),
                CustomButton(
                  "اعاده الارسال",
                  () {
                    _resend();
                  },
                  color: Colors.white,
                  padding: 8,
                  textColor: AppColors.primary,
                  fontSize: 14,
                ),
              ],
            ),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }

  void _verifyEmail() {
    autoValidate = true;
    setState(() {});
    if (_formKey.currentState!.validate()) {
      Notifications.showLoading();
      Get.find<AccountService>().verifyEmail(code.text).then((response) {
        Notifications.hideLoading();
        if (response.status == 1) {
          Get.back();
          Notifications.success(response.message);
          UserModel? userModel = Get.find<AccountBloc>().state.user;
          userModel?.emailVerifiedAt = "";
          Get.find<AccountBloc>().updateAccount(userModel!);

          Get.find<HomeController>().verifyEmail();
        } else {
          Notifications.error(response.message);
        }
      }).catchError((e) {
        Notifications.hideLoading();
        Notifications.error(Constants.netError);
      });
    }
  }

  void _resend() {
    Notifications.showLoading();
    Get.find<AccountService>().resendCode().then((response) {
      Notifications.hideLoading();
      if (response.status == 1) {
        Get.back();
        Notifications.success(response.message);
      } else {
        Notifications.error(response.message);
      }
    }).catchError((e) {
      Notifications.hideLoading();
      Notifications.error(Constants.netError);
    });
  }
}
