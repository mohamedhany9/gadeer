import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/config/routes.dart';
import 'package:gadeer/data/response/auth/login.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/login/bloc/login_form.bloc.dart';
import 'package:gadeer/modules/login/widgets/reset_password_widget.dart';
import 'package:get/get.dart';

class LoginFormWidget extends StatefulWidget {
  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  LoginFormBloc? _formBloc;

  @override
  void initState() {
    _formBloc = LoginFormBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBlocListener<LoginFormBloc, LoginResponse, Object>(
      formBloc: _formBloc,
      onFailure: _formBloc!.onFailure,
      onSuccess: _formBloc!.onSuccess,
      onSubmitting: (_, __) => Notifications.showLoading(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(Constants.background2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("تسجيل الدخول"),
          SizedBox(
            height: 16,
          ),
          TextFieldBlocBuilder(
            textFieldBloc: _formBloc!.phone,
            keyboardType: TextInputType.phone,
            decoration: inputDecoration(
              label: "رقم الجوال",
              hint: "9665xxxxxxxxx",
              icon: Icons.phone,
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: _formBloc!.password,
            suffixButton: SuffixButton.obscureText,
            obscureTextFalseIcon: Icon(
              Icons.visibility_off,
              color: Colors.red,
            ),
            obscureTextTrueIcon: Icon(
              Icons.visibility,
              color: Colors.blueGrey,
            ),
            decoration: inputDecoration(
              icon: Icons.vpn_key,
              hint: 'كلمة المرور',
              label: 'كلمة المرور',
            ),
            style: TextStyle(
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton("دخول", () => _formBloc!.submit()),
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {
                    print("forget password");
                    Get.dialog(ResetPassword());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: AutoSizeText(
                        "هل نسيت الرقم السري؟",
                        maxLines: 1,
                        maxFontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.register);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("إنشاء حساب جديد"),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
