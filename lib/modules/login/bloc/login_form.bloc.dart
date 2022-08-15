import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/request/auth/login.request.dart';
import 'package:gadeer/data/response/auth/login.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/helper/validator.dart' as v;
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/login/service/login.service.dart';
import 'package:get/get.dart';

class LoginFormBloc extends FormBloc<LoginResponse, Object>
    with FormValidateErrors {
  final LoginService loginService = Get.find();

  final phone = TextFieldBloc(
    name: 'phone',
    validators: [v.Validator.phone],
  );

  final password = TextFieldBloc(
    name: 'password',
    validators: [v.Validator.password],
  );

  LoginFormBloc() : super() {
    addFieldBlocs(fieldBlocs: [
      phone,
      password,
    ]);
  }

  @override
  void onSubmitting() async {
    LoginRequest loginRequest = LoginRequest(
      phone: phone.value,
      password: password.value,
    );
    this.loginService.login(request: loginRequest).then((response) async {
      if (response.status == 0) {
        handleValidateErrors(state, response.errors ?? {});
        emitFailure(failureResponse: response.message);
      } else {
        emitSuccess(successResponse: response);
      }
    }).catchError((e) {
      emitFailure(failureResponse: Constants.netError);
    });
  }

  void onSuccess(_, FormBlocSuccess<LoginResponse, Object> state) {
    Get.find<AppBloc>().successLogin(state.successResponse);
  }

  void onFailure(_, FormBlocFailure<LoginResponse, Object> state) {
    Notifications.hideLoading();
    Notifications.error(state.failureResponse as String?);
  }
}
