import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/model/assosiation_section.dart';
import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/model/parnet_model.dart';
import 'package:gadeer/data/request/auth/register.request.dart';
import 'package:gadeer/data/response/auth/partners_response.dart';
import 'package:gadeer/data/response/home/assosiation_sections.dart';
import 'package:gadeer/data/response/auth/login.response.dart';
import 'package:gadeer/data/response/home/cities.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/helper/num_helper.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/register/service/register.service.dart';
import 'package:gadeer/data/service/data.service.dart';
import 'package:get/get.dart';

import '../register.bloc.dart';
import '../register.event.dart';

class PeopleFormBloc extends FormBloc<LoginResponse, Object>
    with FormValidateErrors {
  final DataService dataService = Get.find();
  final RegisterService registerService = Get.find();

  PeopleFormBloc() : super(isLoading: true) {
    addFieldBlocs(fieldBlocs: [
      name,
      // establishDate,
      // idNumber,
     // section,
      email,
      password,
      area,
      city,
     // partners,
      agreePolicy
    ]);
  }

  final name = TextFieldBloc(name: 'first_name');
  final email = TextFieldBloc(name: 'email');
  // final idNumber = TextFieldBloc(name: 'id_number');

  // final establishDate = InputFieldBloc<DateTime, Object>(
  //   name: 'establish_date',
  // );
  final password = TextFieldBloc(name: 'password');
  final area = SelectFieldBloc<CityModel, Object>(name: 'area_id');
  final city = SelectFieldBloc<CityModel, Object>(name: 'city_id');
  final partners = SelectFieldBloc<PartnersModel, Object>(name: 'partner_id');
  final section = SelectFieldBloc<AssosiationSection, Object>(name: 'section');

  final agreePolicy =
  BooleanFieldBloc(name: "agree_policy", initialValue: false);
  @override
  void onLoading() async {
    print("loading");

    CitiesResponse areasResponse =
    await this.dataService.getAreas().catchError((e) {
      Notifications.error(Constants.netError);
    });

    areasResponse.data?.forEach((item) => area.addItem(item));
    area.onValueChanges(onData: (p, current) async* {
      if (current.value != null) {
        await loadCities(areaId: current.value!.id).catchError((e) {
          Notifications.error(Constants.netError);
        });
      }
    });

    PartnersResponse partnersResponse =
    await this.dataService.getPartners().catchError((e) {
      print(e.toString());
      Notifications.error(Constants.netError);
    });
    partnersResponse.data!.forEach((item) => partners.addItem(item));
    partners.onValueChanges(onData: (p, current) async* {
      // if (current.value != null) {
      //   await loadCities(areaId: current.value!.id).catchError((e) {
      //     print(e.toString());
      //     Notifications.error(Constants.netError);
      //   });
      // }
    });

    AssosiatiosSectionsResponse assosiatiosSectionsResponse =
    await this.dataService.getSections().catchError((e) {
      Notifications.error(Constants.netError);
    });

    section.updateItems(assosiatiosSectionsResponse.data);

    emitLoaded();
    print("loaded");
  }

  Future<void> loadCities({int? areaId}) async {
    emitLoading();
    CitiesResponse citiesResponse =
    await this.dataService.getCities(areaId: areaId);
    city.updateItems(citiesResponse.data);
    emitLoaded();
  }

  @override
  void onSubmitting() {
    if (agreePolicy.value != true) {
      emitFailure(
          failureResponse:
          "يجب عليك الموافقه علي سياسه الخصوصية وشروط الاستخدام");
      return;
    }

    RegisterRequest registerRequest = RegisterRequest(
      firstName: name.value,
      phoneId: Get.find<RegisterBloc>().state.phoneId,
      email: email.value,
      password: password.value,
      // idNumber: idNumber.value == null ? null : NumHelper.parse(idNumber.value).toString(),
      // establishDate: establishDate.value,
      sectionId: section.value?.id ?? 0,
      areaId: area.value?.id,
      cityId: city.value?.id,
      //partnersId: partners.value?.id,
      membershipType: "user",
    );
    this
        .registerService
        .register(request: registerRequest)
        .then((response) async {
      if (response.status == 0) {
        handleValidateErrors(state, response.errors);
        emitFailure(failureResponse: response.message);
      } else {
        emitSuccess(successResponse: response);
      }
    }).catchError((error) {
      emitFailure(failureResponse: error);
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
