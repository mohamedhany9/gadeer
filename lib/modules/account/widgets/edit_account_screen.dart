import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/assosiation_section.dart';
import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/response/account/update_account.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/account/bloc/account_form.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class EditAccountScreen extends StatefulWidget {
  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late final AccountFormBloc _formBloc;
  final AccountType accountType = Get.find<AccountBloc>().state.accountType!;
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
                                "رقم العضويه : ${Get.find<AccountBloc>().state.user?.number}"),
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
                            SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                                'تحديث الحساب', () => _formBloc.submit()),
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
                ? "اسم الجمعيه"
                : "الاسم الاول",
            icon: accountType == AccountType.association
                ? Icons.location_city
                : Icons.person,
          ),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: _formBloc.lName,
          decoration: inputDecoration(
            label: "الاسم الاخير",
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
              : "رقم الهويه",
          icon: Icons.card_membership),
    );
  }

  _buildSectionField() {
    return DropdownFieldBlocBuilder<AssosiationSection>(
      selectFieldBloc: _formBloc.section,
      decoration: inputDecoration(hint: 'تخصص الجمعيه', icon: Icons.category),
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

  _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextFieldBlocBuilder(
        keyboardType: TextInputType.emailAddress,
        textFieldBloc: _formBloc.email,
        decoration: inputDecoration(
          hint: 'aboali@gmail.com',
          label: "البريد الالكتروني",
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
}
