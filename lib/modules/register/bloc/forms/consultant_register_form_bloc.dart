import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/request/auth/register.request.dart';
import 'package:gadeer/data/response/auth/login.response.dart';
import 'package:gadeer/data/response/home/cities.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/helper/num_helper.dart';
import 'package:gadeer/modules/app/bloc/app.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:gadeer/modules/register/service/register.service.dart';
import 'package:gadeer/data/service/data.service.dart';
import 'package:get/get.dart';

class ConsultantRegisterFormBloc extends FormBloc<LoginResponse, Object>
    with FormValidateErrors {
  final DataService dataService = Get.find();
  final RegisterService registerService = Get.find();
  final List<CategoryModel> allCategories = <CategoryModel>[];

  final firstName = TextFieldBloc(name: 'first_name');
  final lastName = TextFieldBloc(name: 'last_name');
  final idNumber = TextFieldBloc(name: 'id_number');
  final email = TextFieldBloc(name: 'email');
  final password = TextFieldBloc(name: 'password');
  final area = SelectFieldBloc<CityModel, Object>(name: 'area_id');
  final city = SelectFieldBloc<CityModel, Object>(name: 'city_id');
  final gender = SelectFieldBloc<String, String>(
    name: 'gender',
    items: ['ذكر', 'انثى'],
  );
  final agreePolicy =
      BooleanFieldBloc(name: "agree_policy", initialValue: false);

  final jobTitle = TextFieldBloc(name: 'job_title');

  ConsultantRegisterFormBloc() : super(isLoading: true) {
    addFieldBlocs(fieldBlocs: [
      firstName,
      lastName,
      gender,
      email,
      password,
      area,
      city,
      jobTitle,
      idNumber,
      agreePolicy
    ]);
  }

  @override
  void onLoading() async {
    CitiesResponse areasResponse =
        await this.dataService.getAreas().catchError((e) {
      print(e.toString());
      Notifications.error(Constants.netError);
    });
    areasResponse.data!.forEach((item) => area.addItem(item));
    area.onValueChanges(onData: (p, current) async* {
      if (current.value != null) {
        await loadCities(areaId: current.value!.id).catchError((e) {
          print(e.toString());
          Notifications.error(Constants.netError);
        });
      }
    });
    emitLoaded();
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

    //print("phone id" + Get.find<RegisterBloc>().state.phoneId.toString());
    RegisterRequest registerRequest = RegisterRequest(
      firstName: firstName.value,
      lastName: lastName.value,
      phoneId: Get.find<RegisterBloc>().state.phoneId,
      email: email.value,
      password: password.value,
      areaId: area.value?.id,
      idNumber: idNumber.value == null
          ? null
          : NumHelper.parse(idNumber.value).toString(),
      cityId: city.value?.id,
      gender: gender.value == "ذكر" ? "male" : "female",
      jobTitle: jobTitle.value,
      membershipType: AccountType.consultant.toShortString(),
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
    if (state.failureResponse != null) {
      Notifications.error(state.failureResponse?.toString());
    } else {
      Notifications.error("حصل خطأ غير متوقع برجاء التواصل مع الدعم الفني");
    }
  }
}
