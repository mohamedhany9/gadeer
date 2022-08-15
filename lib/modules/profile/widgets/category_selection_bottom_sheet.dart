import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/data/request/profile/add_category_request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDialogButtomSheet extends StatefulWidget {
  @override
  _CategoryDialogButtomSheetState createState() =>
      _CategoryDialogButtomSheetState();
}

class _CategoryDialogButtomSheetState extends State<CategoryDialogButtomSheet>
    with TickerProviderStateMixin {
  List<CategoryModel>? categories = [];
  List<CategoryModel> subCategories = [];
  CategoryModel? main;
  CategoryModel? sub;

  @override
  void initState() {
    super.initState();
    categories = Get.find<HomeController>().categories;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .5,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: ListView(
        children: [
          Center(
            child: Text(
              "اختيار المجال",
              style: TextStyles.title,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          DropdownButtonFormField<CategoryModel>(
              style: GoogleFonts.cairo(
                textStyle: TextStyles.subTitle
                    .copyWith(height: 1, color: Colors.blueGrey[600]),
              ),
              decoration: inputDecoration(hint: "المجال", label: "المجال"),
              items: [
                ...categories?.map((e) {
                      return DropdownMenuItem<CategoryModel>(
                        child: Text(e.title!),
                        value: e,
                      );
                    }).toList() ??
                    []
              ],
              onChanged: (c) {
                main = c;
                sub = null;

                setState(() {});
              }),
          SizedBox(
            height: 24,
          ),
          main == null
              ? Container(
                  height: 1,
                )
              : main!.children!.isEmpty
                  ? Container(
                      height: 1,
                    )
                  : DropdownButtonFormField<CategoryModel>(
                      style: GoogleFonts.cairo(
                        textStyle: TextStyles.subTitle
                            .copyWith(height: 1, color: Colors.blueGrey[600]),
                      ),
                      decoration: inputDecoration(),
                      items: [
                        ...main?.children!.map((e) {
                              return DropdownMenuItem<CategoryModel>(
                                child: Text(e.title!),
                                value: e,
                              );
                            }).toList() ??
                            []
                      ],
                      onChanged: (c) {
                        sub = c;
                        setState(() {});
                      }),
          SizedBox(
            height: 40,
          ),
          CustomButton("تأكيد", () async {
            await _addCategory();
          })
        ],
      ),
    );
  }

  Future _addCategory() async {
    if (main == null) {
      Notifications.error("برجاء اختيار مجال الاستشاره");
      return;
    }
    List<int?> selectedCats = [];
    selectedCats.add(main!.id);
    if (sub != null) {
      selectedCats.add(sub!.id);
    }

    Notifications.showLoading();
    await Get.find<ProfileService>()
        .editCategory(AddCategoryRequest(categories: selectedCats))
        .then((response) {
      Notifications.hideLoading();

      if (response.status == 1) {
        Get.find<ProfileBloc>().updateProfile(response.profile);
        Get.back();

        Notifications.success("تم تحديث بياناتك بنجاح");
      } else {
        Notifications.error(Constants.netError);
      }
    }).catchError((e) {
      Notifications.hideLoading();

      Notifications.error(Constants.netError);
    });
  }
}
