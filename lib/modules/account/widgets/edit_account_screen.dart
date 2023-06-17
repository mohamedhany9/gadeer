import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/assosiation_section.dart';
import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/model/naitionality_model.dart';
import 'package:gadeer/data/model/parnet_model.dart';
import 'package:gadeer/data/request/account/update_account.request.dart';
import 'package:gadeer/data/response/account/update_account.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/helper/num_helper.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/account/bloc/account_form.bloc.dart';
import 'package:gadeer/modules/account/service/account_service.dart';
import 'package:gadeer/modules/account/widgets/update_verification_code.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class EditAccountScreen extends StatefulWidget {
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late final AccountFormBloc _formBloc;
  final AccountType accountType = Get.find<AccountBloc>().state.accountType!;


  bool frist = false;
  String? oldphone;

  int? partnerid;
  int? nationalityid;


  getData() async{
    Notifications.showLoading();
    UpdateAccountRequest updateAccountRequest = accountType == AccountType.consultant ?
    UpdateAccountRequest(
      areaId: _formBloc.area.value!.id,
      cityId: _formBloc.city.value!.id,
      email: _formBloc.email.value!,
      firstName: _formBloc.fName.value!,
      phoneNumber: _formBloc.phoneNumber.value!,
      partnerid: _formBloc.partner.value!.id,
      partnername: _formBloc.partnername.value!,
      nationalityname: _formBloc.nationality.value!.name,
      nationalityid: _formBloc.nationality.value!.id,
      gender: _formBloc.gender.value! == null
          ? null
          : _formBloc.gender.value! == "ذكر"
          ? "male"
          : "female",
      jobTitle: _formBloc.jobTitle.value!,
      lastName: _formBloc.lName.value!,
      idNumber: _formBloc.idNumber.value! == null
          ? null
          : NumHelper.parse(_formBloc.idNumber.value!).toString(),
    ) :
    accountType == AccountType.user ? UpdateAccountRequest(
      areaId: _formBloc.area.value!.id,
      cityId: _formBloc.city.value!.id,
      email: _formBloc.email.value!,
      firstName: _formBloc.fName.value!,
      phoneNumber: _formBloc.phoneNumber.value!,
      gender: _formBloc.gender.value! == null
          ? null
          : _formBloc.gender.value! == "ذكر"
          ? "male"
          : "female",
      jobTitle: _formBloc.jobTitle.value!,
      lastName: _formBloc.lName.value!,
      nationalityname: _formBloc.nationality.value!.name,
      nationalityid: _formBloc.nationality.value!.id,
      // idNumber: _formBloc.idNumber.value! == null
      //     ? null
      //     : NumHelper.parse(_formBloc.idNumber.value!).toString(),
    ) :
    UpdateAccountRequest(
      areaId: _formBloc.area.value!.id,
      cityId: _formBloc.city.value!.id,
      email: _formBloc.email.value!,
      firstName: _formBloc.fName.value!,
      phoneNumber: _formBloc.phoneNumber.value!,
      gender: _formBloc.gender.value! == null
          ? null
          : _formBloc.gender.value! == "ذكر"
          ? "male"
          : "female",
      jobTitle: _formBloc.jobTitle.value!,
      lastName: _formBloc.lName.value!,
      idNumber: _formBloc.idNumber.value! == null
          ? null
          : NumHelper.parse(_formBloc.idNumber.value!).toString(),
      establishDate: _formBloc.establishDate.value,
      sectionId: _formBloc.section.value?.id,
      nationalityname: _formBloc.nationality.value!.name,
      nationalityid: _formBloc.nationality.value!.id,
    );
    await Get.find<AccountService>()
        .updateAccount(updateAccountRequest)
        .then((response) async {
      if (response.status == 1) {
        Notifications.hideLoading();
        Get.to(UpdateVerificationCode(oldphone: oldphone!,newphone: _formBloc.phoneNumber.value!,));
      } else {

      }
    }).catchError((e) {

      return null;
    });
  }

  @override
  void initState() {
    super.initState();
    _formBloc = AccountFormBloc();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("تعديل الحساب"),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: AssetImage(
                Constants.background1,
              ),
            ),
          ),
          child:
              FormBlocListener<AccountFormBloc, UpdateAccountResponse, String>(
                  formBloc: _formBloc,
                  onFailure: _formBloc.onFailure,
                  onSuccess: _formBloc.onSuccess,
                  onSubmitting: (_, __) => Notifications.showLoading(),
                  child: BlocConsumer<AccountFormBloc, FormBlocState>(
                    bloc: _formBloc,
                    listener: (context, state) {
                      if (state is FormBlocLoading) {
                        Notifications.showLoading();
                      }
                      if (state is FormBlocLoaded) {
                        if(frist == false)
                        {
                          if(_formBloc.partner.value != null)
                            {
                              partnerid = _formBloc.partner.value!.id;
                            }

                          if(_formBloc.nationality.value != null)
                          {
                            nationalityid = _formBloc.nationality.value!.id;
                          }

                          oldphone = _formBloc.phoneNumber.value!;
                          frist = true;
                        }
                        Notifications.hideLoading();
                      }
                    },
                    builder: (context, state) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                                "رقم العضوية : ${Get.find<AccountBloc>().state.user?.number}"),
                            SizedBox(
                              height: 8,
                            ),
                            _buildName(),
                            _buildIdNumber(),
                            _buildSectionField(),
                            _buildJobTitleField(),
                            _buildLocationField(),
                            _buildEstablishDate(),
                            _buildEmailField(),
                            _buildGenderRow(),
                            _buildPhoneNumber(),
                            _buildNationalityForm(),
                            _buildPartnerField(),
                            partnerid == 1 ? _buildPartnerNote(): Container(),
                            SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                                'تحديث الحساب', (){
                                  if(_formBloc.phoneNumber.value!.length == 12)
                                    {
                                      if(_formBloc.phoneNumber.value! == oldphone)
                                        {
                                          _formBloc.submit();
                                        }
                                      else{
                                        print("change");
                                        getData();
                                      }
                                    }else{
                                    Notifications.error("رقم الهاتف 12 وحده");
                                  }
                            }),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ))),
    );
  }

  _buildName() {
    return Column(
      children: [
        TextFieldBlocBuilder(
          textFieldBloc: _formBloc.fName,
          decoration: inputDecoration(
            label: accountType == AccountType.association
                ? "اسم الجمعية"
                : "الاسم الأول",
            icon: accountType == AccountType.association
                ? Icons.location_city
                : Icons.person,
          ),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: _formBloc.lName,
          decoration: inputDecoration(
            label: "الاسم الأخير",
            icon: Icons.person,
          ),
        ),
      ],
    );
  }

  _buildEstablishDate() {
    return DateTimeFieldBlocBuilder(
      dateTimeFieldBloc: _formBloc.establishDate,
      format: DateFormat("dd-MM-yyyy"),
      initialDate: _formBloc.establishDate.value ?? DateTime.now(),
      firstDate: DateTime(1500),
      lastDate: DateTime.now(),
      decoration: inputDecoration(
        label: 'تاريخ التأسيس',
      ),
    );
  }

  _buildIdNumber() {
    return TextFieldBlocBuilder(
      textFieldBloc: _formBloc.idNumber,
      keyboardType: TextInputType.number,
      decoration: inputDecoration(
          label: accountType == AccountType.association
              ? "رقم الترخيص"
              : "رقم الهوية",
          icon: Icons.card_membership),
    );
  }

  _buildSectionField() {
    return DropdownFieldBlocBuilder<AssosiationSection>(
      selectFieldBloc: _formBloc.section,
      decoration: inputDecoration(hint: 'تخصص الجمعية', icon: Icons.category),
      itemBuilder: (context, sec) => sec.title ?? "",
    );
  }

  _buildLocationField() {
    return Column(
      children: [
        DropdownFieldBlocBuilder<CityModel>(
          selectFieldBloc: _formBloc.area,
          decoration: inputDecoration(
            hint: 'المنطقة',
            icon: Icons.map,
          ),
          itemBuilder: (context, area) => area.title!,
        ),
        DropdownFieldBlocBuilder<CityModel>(
          selectFieldBloc: _formBloc.city,
          decoration: inputDecoration(
            hint: 'المدينة',
            icon: Icons.location_city,
          ),
          itemBuilder: (context, city) => city.title!,
        ),
      ],
    );
  }

  _buildPartnerField() {
    return DropdownFieldBlocBuilder<PartnersModel>(
      selectFieldBloc: _formBloc.partner,
      decoration: inputDecoration(
        hint: 'جهة العمل',
        icon: Icons.accessibility_new_outlined,
      ),
      itemBuilder: (context, p) => p.title!,
      onChanged: (v){
        setState(() {
          partnerid = v!.id;
        });
      },
    );
  }

  _buildPartnerNote() {
    return Column(
      children: [
        TextFieldBlocBuilder(
          textFieldBloc: _formBloc.partnername,
          decoration: inputDecoration(
            label: "أخرى",
          ),
        ),
      ],
    );
  }

  _buildNationalityForm() {
    return DropdownFieldBlocBuilder<NationalityModel>(
      selectFieldBloc: _formBloc.nationality,
      decoration: inputDecoration(
        hint: 'اختيار الجنسيه',
        icon: Icons.accessibility,
      ),
      itemBuilder: (context, nationality) => nationality.name!,
      onChanged: (v){
        setState(() {
          nationalityid = v!.id ;
        });
      },
    );
  }

  _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextFieldBlocBuilder(
        keyboardType: TextInputType.emailAddress,
        textFieldBloc: _formBloc.email,
        decoration: inputDecoration(
          hint: 'aboali@gmail.com',
          label: "البريد الإلكتروني",
          icon: Icons.email,
        ),
      ),
    );
  }

  _buildJobTitleField() {
    return TextFieldBlocBuilder(
      textFieldBloc: _formBloc.jobTitle,
      decoration: inputDecoration(
        label: 'المسمي الوظيفي',
        hint: "المسمي الوظيفي",
        icon: Icons.label,
      ),
    );
  }

  _buildGenderRow() {
    return DropdownFieldBlocBuilder(
      selectFieldBloc: _formBloc.gender,
      decoration: inputDecoration(
        hint: 'الجنس',
        icon: FontAwesomeIcons.male,
      ),
      itemBuilder: (context, dynamic gender) => gender,
    );
  }

  _buildPhoneNumber() {
    return TextFieldBlocBuilder(
      textFieldBloc: _formBloc.phoneNumber,
      keyboardType: TextInputType.number,
      decoration: inputDecoration(
          label: "رقم الهاتف",
          icon: Icons.phone),
      maxLength: 12,

    );
  }
}
