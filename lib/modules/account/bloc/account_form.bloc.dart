import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/data/model/assosiation_section.dart';
import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/model/user.model.dart';
import 'package:gadeer/data/request/account/update_account.request.dart';
import 'package:gadeer/data/response/account/update_account.response.dart';
import 'package:gadeer/data/response/home/cities.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/form_validate_errors.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/helper/num_helper.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/account/service/account_service.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:gadeer/data/service/data.service.dart';
import 'package:get/get.dart';

class AccountFormBloc extends FormBloc<UpdateAccountResponse, String>
    with FormValidateErrors {
  final AccountBloc _accountBloc = Get.find();
  final HomeController _homeController = Get.find();

  final fName = TextFieldBloc(name: 'first_name');
  final lName = TextFieldBloc(name: 'last_name');

  final email = TextFieldBloc(name: 'email');
  final idNumber = TextFieldBloc(name: 'id_number');

  final establishDate = InputFieldBloc<DateTime, Object>(
    name: 'establish_date',
  );
  final area = SelectFieldBloc<CityModel, Object>(name: 'area_id');
  final city = SelectFieldBloc<CityModel, Object>(name: 'city_id');
  final section = SelectFieldBloc<AssosiationSection, Object>(name: 'section');
  final gender = SelectFieldBloc<String, String>(
    name: 'gender',
    items: ['ذكر', 'انثى'],
  );
  final jobTitle = TextFieldBloc(name: 'job_title');

  AccountFormBloc() {
    addFieldBlocs(fieldBlocs: [fName, email, city, area]);
    if (_accountBloc.state.accountType == AccountType.consultant) {

      addFieldBlocs(fieldBlocs: [idNumber,lName, jobTitle, gender]);

    } else if(_accountBloc.state.accountType == AccountType.association){

       addFieldBlocs(fieldBlocs: [idNumber,establishDate, section]);

    }else {
      addFieldBlocs(fieldBlocs: []);
    }
    loadData();
  }

  void loadData() {
    UserModel? userModel = _accountBloc.state.user;

    fName.updateInitialValue(userModel?.firstName);
    lName.updateInitialValue(userModel?.lastName);
    email.updateInitialValue(userModel?.email);
    jobTitle.updateInitialValue(userModel?.jobTitle);
    idNumber.updateInitialValue(userModel?.idNumber);
    if (userModel?.gender != null) {
      gender.updateInitialValue(userModel?.gender != "male" ? "انثى" : "ذكر");
    }

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    if (userModel?.establishDate != null) {
      establishDate
          .updateInitialValue(dateFormat.parse(userModel?.establishDate ?? ""));
    }

    area.updateItems(_homeController.areas);
    city.updateItems(_homeController.cities);
    section.updateItems(_homeController.sections);
    print(userModel?.area?.id);
    print(userModel?.city?.id);

    area.updateInitialValue(_homeController.areas
        .firstWhere((element) => element.id == userModel?.area?.id));
    city.updateInitialValue(_homeController.cities
        .firstWhere((element) => element.id == userModel?.city?.id));
    if (userModel?.section != null) {
      section.updateInitialValue(_homeController.sections
          .firstWhere((element) => element.id == userModel?.section));
    }

    area.onValueChanges(onData: (p, current) async* {
      if (area.value != null && p.value != null) {
        await loadCities(areaId: area.value?.id).catchError((e) {
          Notifications.error(Constants.netError);
        });
      }
    });
  }

  @override
  void onSubmitting() async {
    UpdateAccountRequest updateAccountRequest = UpdateAccountRequest(
      areaId: area.value?.id,
      cityId: city.value?.id,
      email: email.value,
      firstName: fName.value,
      gender: gender.value == null
          ? null
          : gender.value == "ذكر"
              ? "male"
              : "female",
      sectionId: section.value?.id,
      establishDate: establishDate.value,
      jobTitle: jobTitle.value,
      lastName: lName.value,
      idNumber: idNumber.value == null
          ? null
          : NumHelper.parse(idNumber.value).toString(),
    );
    await Get.find<AccountService>()
        .updateAccount(updateAccountRequest)
        .then((response) async {
      if (response.status == 1) {
        emitSuccess(successResponse: response, canSubmitAgain: true);
      } else {
        handleValidateErrors(state, response.errors);
        emitFailure(failureResponse: response.message);
      }
    }).catchError((e) {
      emitFailure(failureResponse: e.toString());
      return null;
    });
  }

  void onSuccess(_, FormBlocSuccess<UpdateAccountResponse, Object> state) {
    Notifications.hideLoading();
    _accountBloc.updateAccount(state.successResponse?.user ?? UserModel());
    Notifications.success(state.successResponse!.message);
  }

  void onFailure(_, FormBlocFailure<UpdateAccountResponse, String> state) {
    Notifications.hideLoading();
    Notifications.error(state.failureResponse);
  }

  Future<void> loadCities({int? areaId}) async {
    emitLoading();
    CitiesResponse citiesResponse =
        await Get.find<DataService>().getCities(areaId: areaId);
    city.updateItems(citiesResponse.data);
    emitLoaded();
  }
}
