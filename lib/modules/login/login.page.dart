import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/widgets/call_us.widget.dart';
import 'package:gadeer/modules/login/widgets/login_form.widget.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool collapse = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 700), () {
      collapse = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      messages: UpgraderMessages(code: 'ar'),
      showIgnore: false,
      durationToAlertAgain: Duration(hours: 6),
      child: Scaffold(
        body: SingleChildScrollView(
          reverse: true,
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              SizedBox(
                height: 20,
              ),
              LoginFormWidget(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CallUsWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildHeader() {
    return AnimatedContainer(
      decoration: BoxDecoration(
          image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(Constants.background3)),
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30))),
      duration: Duration(milliseconds: 700),
      height: collapse ? Get.height * .4 : Get.height * .9,
      curve: Curves.easeIn,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 20,
          ),
          Image.asset(
            Constants.logoWhite,
            width: Get.width * 0.4,
          ),
          Text(
            "مرحبا",
            style: TextStyle(fontSize: 34, color: Colors.white),
          )
        ],
      ),
    );
  }
}
