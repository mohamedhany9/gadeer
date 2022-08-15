import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/privacy_policy.model.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:gadeer/modules/register/service/register.service.dart';
import 'package:get/get.dart';

class PrivacyPolicyWidget extends StatefulWidget {
  PrivacyPolicyWidget(this.accountType, {Key? key}) : super(key: key);
  final AccountType accountType;

  @override
  _PrivacyPolicyWidgetState createState() => _PrivacyPolicyWidgetState();
}

class _PrivacyPolicyWidgetState extends State<PrivacyPolicyWidget> {
  final RegisterService _registerService = Get.find<RegisterService>();
  PrivacyPolicyModel? privacyPolicyModel;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Notifications.showLoading();
      await _registerService
          .showPage(widget.accountType == AccountType.consultant
              ? "consultant-privacy-policy"
              : "association-privacy-policy")
          .then((value) {
        privacyPolicyModel = value.policyModel;
        Notifications.hideLoading();
        setState(() {});
      }).catchError((e) {
        print(e.toString());
        Notifications.hideLoading();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(privacyPolicyModel?.title ?? ""),
            SizedBox(
              height: 16,
            ),
            Html(data: privacyPolicyModel?.content ?? ""),
            SizedBox(
              height: 10,
            ),
            CustomButton("رجوع", () {
              Get.back();
            })
          ],
        ),
      ),
    );
  }
}
