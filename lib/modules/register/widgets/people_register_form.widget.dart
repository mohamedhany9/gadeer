import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/assosiation_section.dart';
import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/model/naitionality_model.dart';
import 'package:gadeer/data/model/parnet_model.dart';
import 'package:gadeer/data/response/auth/login.response.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/register/bloc/forms/people_register_form_bloc.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

import 'privacy_policy.widget.dart';

class PeopleFormWidget extends StatefulWidget {
  final RegisterBloc? registerBloc;
  PeopleFormWidget(this.registerBloc);

  @override
  State<PeopleFormWidget> createState() => _PeopleFormWidgetState();
}

class _PeopleFormWidgetState extends State<PeopleFormWidget> {
  PeopleFormBloc? _formBloc;
  @override
  void initState() {
    _formBloc = PeopleFormBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBlocListener<PeopleFormBloc, LoginResponse, Object>(
        formBloc: _formBloc,
        onFailure: _formBloc!.onFailure,
        onSuccess: _formBloc!.onSuccess,
        onSubmitting: (_, __) => Notifications.showLoading(),
        child: BlocConsumer<PeopleFormBloc, FormBlocState>(
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  _buildAssociationName(),
                  // _buildIdNumber(),
                 // _buildSectionField(),
                  _buildLocationField(),
                  // _buildEstablishDate(),
                  _buildEmailField(),
                  _buildNationalityForm(),
                  //_buildPartnersForm(),
                  _buildPasswordField(),
                  _buildagreePolicy(),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton('تسجيل الحساب', () => _formBloc!.submit()),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        ));
  }

  _buildAssociationName() {
    return TextFieldBlocBuilder(
      textFieldBloc: _formBloc!.name,
      decoration: inputDecoration(
        hint: "",
        label: "اسم الفرد",
        icon: Icons.build,
      ),
    );
  }

  // _buildEstablishDate() {
  //   return DateTimeFieldBlocBuilder(
  //     dateTimeFieldBloc: _formBloc!.establishDate,
  //     format: DateFormat("dd-MM-yyyy"),
  //     initialDate: _formBloc!.establishDate.value ?? DateTime.now(),
  //     firstDate: DateTime(1500),
  //     lastDate: DateTime.now(),
  //     decoration: inputDecoration(
  //       label: 'تاريخ التأسيس',
  //     ),
  //   );
  // }

  // _buildIdNumber() {
  //   return TextFieldBlocBuilder(
  //     textFieldBloc: _formBloc!.idNumber,
  //     keyboardType: TextInputType.number,
  //     decoration:
  //     inputDecoration(label: "رقم الترخيص", icon: Icons.card_membership),
  //   );
  // }

  // _buildSectionField() {
  //   return DropdownFieldBlocBuilder<AssosiationSection>(
  //     selectFieldBloc: _formBloc!.section,
  //     decoration: inputDecoration(hint: 'تخصص الفرد', icon: Icons.category),
  //     itemBuilder: (context, sec) => sec.title ?? "",
  //   );
  // }

  _buildPartnersForm() {
    return DropdownFieldBlocBuilder<PartnersModel>(
      selectFieldBloc: _formBloc!.partners,
      decoration: inputDecoration(
        hint: 'جهة العمل',
        icon: Icons.map,
      ),
      itemBuilder: (context, partners) => partners.title!,
    );
  }

  _buildLocationField() {
    return Column(
      children: [
        DropdownFieldBlocBuilder<CityModel>(
          selectFieldBloc: _formBloc!.area,
          decoration: inputDecoration(
            hint: 'المنطقة',
            icon: Icons.map,
          ),
          itemBuilder: (context, area) => area.title!,
        ),
        DropdownFieldBlocBuilder<CityModel>(
          selectFieldBloc: _formBloc!.city,
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
        textFieldBloc: _formBloc!.email,
        decoration: inputDecoration(
          hint: 'aboali@gmail.com',
          label: "البريد الالكتروني",
          icon: Icons.email,
        ),
      ),
    );
  }

  _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextFieldBlocBuilder(
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
        decoration: inputDecoration(icon: Icons.vpn_key, hint: 'كلمة المرور'),
        style: TextStyle(
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  _buildNationalityForm() {
    return DropdownFieldBlocBuilder<NationalityModel>(
      selectFieldBloc: _formBloc!.nationality,
      decoration: inputDecoration(
        hint: 'اختيار الجنسيه',
        icon: Icons.accessibility,
      ),
      itemBuilder: (context, nationality) => nationality.name!,
      onChanged: (v){
        setState(() {
          // id = v!.id ;
        });
      },
    );
  }

  _buildagreePolicy() {
    return CheckboxFieldBlocBuilder(
        booleanFieldBloc: _formBloc!.agreePolicy,
        padding: EdgeInsets.zero,
        controlAffinity: FieldBlocBuilderControlAffinity.leading,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text.rich(TextSpan(text: "اوافق علي ", children: [
            TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.dialog(Dialog(
                        child: PrivacyPolicyWidget(AccountType.association)));
                  },
                text: "سياسة الخصوصية وشروط الاستخدام",
                style:
                TextStyles.subTitleBold.copyWith(color: AppColors.primary))
          ])),
        ));
  }
}
