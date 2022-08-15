import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:gadeer/modules/register/bloc/register.state.dart';
import 'package:gadeer/modules/register/helper/register_steps.helper.dart';
import 'package:gadeer/modules/register/service/register.service.dart';
import 'package:gadeer/data/service/data.service.dart';
import 'package:get/get.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  TabController? tabController;
  final RegisterService registerService = Get.find();
  final DataService dataService = Get.find();
  RegisterBloc() : super(RegisterState(currentStep: 0));

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is SelectedAccountTypeEvent) {
      yield* handleSuccessSelectAccountType(event);
    }

    if (event is SuccessSendVerifyCodeEvent) {
      yield* handleSuccessVerifyCode(event);
    }
    if (event is SuccessVerifyPhoneEvent) {
      yield* handleSuccessVerifyPhone(event);
    }
  }

  Stream<RegisterState> handleSuccessSelectAccountType(
      SelectedAccountTypeEvent event) async* {
    tabController!.index = state.currentStep! + 1;
    print(event.type.toString());
    yield state.copyWith(
        accountType: event.type, currentStep: state.currentStep! + 1);
  }

  Stream<RegisterState> handleSuccessVerifyPhone(
      SuccessVerifyPhoneEvent event) async* {
    tabController!.index = 3;
    print(this.state.accountType.toString());
    yield state.copyWith(
        phoneId: event.phoneId, currentStep: tabController?.index);
  }

  Stream<RegisterState> handleSuccessVerifyCode(
      SuccessSendVerifyCodeEvent event) async* {
    tabController!.index = state.currentStep! + 1;
    print(this.state.accountType.toString());
    yield state.copyWith(
        phone: event.phone, currentStep: state.currentStep! + 1);
  }

  initTabController(TickerProvider widget) {
    tabController = TabController(
      initialIndex: 0,
      length: registerStepsList.length,
      vsync: widget,
    );
  }
}
