import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/model/naitionality_model.dart';
import 'package:gadeer/data/model/parnet_model.dart';
import 'package:gadeer/data/model/upluad_image_model.dart';
import 'package:gadeer/data/response/auth/login.response.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/helper_methods.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/register/bloc/forms/consultant_register_form_bloc.dart';
import 'package:gadeer/modules/register/bloc/register.bloc.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:gadeer/modules/register/widgets/privacy_policy.widget.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import 'package:google_fonts/google_fonts.dart';

File? image ;
String? image_id ;
class ConsultantRegisterForm extends StatefulWidget {
  final RegisterBloc? registerBloc;
  ConsultantRegisterForm(this.registerBloc);

  @override
  State<ConsultantRegisterForm> createState() => _ConsultantRegisterFormState();
}

class _ConsultantRegisterFormState extends State<ConsultantRegisterForm> {
  ConsultantRegisterFormBloc? _formBloc;

  int? id  ;
  bool sub = false;

  // Future<FormData> upluadimage( File file) async {
  //   String fileName = file.path.split('/').last;
  //   return FormData.fromMap({
  //     "file": await MultipartFile.fromFile(file.path, filename:fileName),
  //   });
  // }
  //
  // Future UpluadimageMethod(File file) async {
  //   print("go hANy");
  //   Response response =
  //   await Dio().post("${Constants.baseUrl}uploade/files",
  //       data: await upluadimage(file),
  //       options: Options(
  //         validateStatus: (status) => true,
  //         headers: {
  //           "Avar : "application/json",
  //           'Content-Type': 'multipart/form-data',
  //         },
  //       ));
  //
  //   if(response.statusCode == 200)
  //   {
  //     print(response.data);
  //     ProductCategoryModel data = ProductCategoryModel.fromJson(response.data);
  //     image_id = data.file;
  //    _formBloc!.submit();
  //   }
  // }


  @override
  void initState() {
    _formBloc = ConsultantRegisterFormBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBlocListener<ConsultantRegisterFormBloc, LoginResponse, Object>(
        formBloc: _formBloc,
        onFailure: _formBloc!.onFailure,
        onSuccess: _formBloc!.onSuccess,
        onSubmitting: (_, state) => Notifications.showLoading(),
        child: BlocConsumer<ConsultantRegisterFormBloc, FormBlocState>(
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
                  _buildNameForm(),
                  TextFieldBlocBuilder(
                    textFieldBloc: _formBloc!.idNumber,
                    keyboardType: TextInputType.number,
                    decoration: inputDecoration(
                      label: 'رقم الهويه',
                      hint: "رقم الهويه",
                      icon: FontAwesomeIcons.idCard,
                    ),
                  ),
                  _buildJobTitle(),
                  _buildGenderForm(),
                  _buildLocationForm(),
                  _buildEmailForm(),
                  _buildPassword(),
                  _buildPartnersForm(),
                  id == 1 ? _buildPartnersNameForm() :Container(),
                  _buildCategoriesForm(),
                  sub == true ? _buildSubCategoriesForm() : Container(),
                  _buildNationalityForm(),
                  _buildImageWidget(),
                  _buildagreePolicy(),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton('تسجيل الحساب', (){
                    _formBloc!.submit();
                    //UpluadimageMethod(image!);

                  }),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget _formRow({required List<Widget> children}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .map((e) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: e,
                  ),
                ))
            .toList(),
      );

  @override
  void dispose() {
    super.dispose();
    _formBloc!.close();
  }

  _buildNameForm() {
    return _formRow(
      children: [
        TextFieldBlocBuilder(
          textFieldBloc: _formBloc!.firstName,
          decoration: inputDecoration(
            label: 'الاسم الاول',
            hint: "الاسم الاول",
            icon: Icons.person,
          ),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: _formBloc!.lastName,
          decoration: inputDecoration(
            label: 'الاسم الاخير',
            hint: "الاسم الاخير",
            icon: Icons.person,
          ),
        ),
      ],
    );
  }

  _buildGenderForm() {
    return DropdownFieldBlocBuilder(
      selectFieldBloc: _formBloc!.gender,
      decoration: inputDecoration(
        hint: 'الجنس',
        icon: FontAwesomeIcons.male,
      ),
      itemBuilder: (context, dynamic gender) => gender,
    );
  }

  _buildLocationForm() {
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
  _buildCategoriesForm() {
    return DropdownFieldBlocBuilder<CategoryModel>(
      selectFieldBloc: _formBloc!.category,
      decoration: inputDecoration(
        hint: 'اختيار المجال',
        icon: Icons.accessibility,
      ),
      itemBuilder: (context, category) => category.title! ,
      onChanged: (v){
        setState(() {
          sub = false;
          if(v!.children!.isNotEmpty)
            {
              sub = true;
            }
        });
      },
    );
  }

  _buildSubCategoriesForm() {
    return DropdownFieldBlocBuilder<CategoryModel>(
      selectFieldBloc: _formBloc!.subcategory,
      decoration: inputDecoration(
        hint: 'اختيار المجال الثانوى',
        icon: Icons.accessibility,
      ),
      itemBuilder: (context, category) => category.title! ,
    );
  }

  _buildPartnersForm() {
    return DropdownFieldBlocBuilder<PartnersModel>(
      selectFieldBloc: _formBloc!.partners,
      decoration: inputDecoration(
        hint: 'جهة العمل',
        icon: Icons.accessibility,
      ),
      itemBuilder: (context, partners) => partners.title! ,
      onChanged: (v){
        setState(() {
          id = v!.id ;
        });
      },
    );
  }

  _buildPartnersNameForm() {
    return _formRow(
      children: [
        TextFieldBlocBuilder(
          textFieldBloc: _formBloc!.note,
          decoration: inputDecoration(
            label: 'أخرى',
            hint: "أخرى",
            //icon: Icons.person,
          ),
        ),
      ],
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

  _buildEmailForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextFieldBlocBuilder(
        textFieldBloc: _formBloc!.email,
        keyboardType: TextInputType.emailAddress,
        decoration: inputDecoration(
          label: 'البريد الالكتروني',
          hint: "ahmedali@gmail.com",
          icon: Icons.email,
        ),
      ),
    );
  }

  _buildPassword() {
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

  _buildJobTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextFieldBlocBuilder(
        textFieldBloc: _formBloc!.jobTitle,
        decoration: inputDecoration(
          label: 'المسمي الوظيفي',
          hint: "المسمي الوظيفي",
          icon: Icons.label,
        ),
      ),
    );
  }

  // _buildImageWidget() {
  //   return BlocBuilder<InputFieldBloc<File?, String>,
  //       InputFieldBlocState<File?, String>>(
  //       bloc: _formBloc!.imageFile,
  //       builder: (context, state) {
  //         return GestureDetector(
  //           onTap: () async {
  //             image = await HelperMethods.pickImage();
  //             setState(() {
  //             });
  //           },
  //           child: Container(
  //             height: 140,
  //             padding: const EdgeInsets.symmetric(vertical: 5),
  //             width: MediaQuery.of(context).size.width,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(8),
  //               border: Border.all(color: Colors.black),
  //             ),
  //             child: image != null ? Image.file(image!,width: MediaQuery.of(context).size.width,) :Icon(Icons.add),
  //           ),
  //         );
  //       });
  // }

  _buildImageWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Text("اضف صورة الهويه"),

          GestureDetector(
            onTap: () async{
              image = await HelperMethods.pickImage();
              setState(() {
                 image;
              });
            },
            child: Container(
              height: 140,
              padding: const EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black),
              ),
              child: image != null ? Image.file(image!,width: MediaQuery.of(context).size.width,) :Icon(Icons.add),
            ),
          ),
        ],
      ),
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
