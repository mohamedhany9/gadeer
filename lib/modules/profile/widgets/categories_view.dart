import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:get/get.dart';

import 'category_selection_bottom_sheet.dart';

class CategoriesView extends StatelessWidget {
  final bool editable;
  final List<CategoryModel>? categories;
  CategoriesView(this.categories, {this.editable = false});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(right: 16, left: 16, top: 8),
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              InkWell(
                onTap: !editable
                    ? null
                    : () {
                        Get.bottomSheet(CategoryDialogButtomSheet(),
                            backgroundColor: Colors.white);
                      },
                child: Row(
                  mainAxisAlignment: editable
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: [
                    Text("مجال الخبير",
                        style: TextStyles.subTitleBold.copyWith(
                          color: AppColors.primary,
                        )),
                    if (editable)
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.add,
                          color: AppColors.primary,
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: categories!.isEmpty
              ? _buildEmptyCategories()
              : Column(
                  children: [
                    ...categories?.map((cat) {
                          return _CategoryItem(cat, editable);
                        }).toList() ??
                        []
                  ],
                ),
        ),
      ],
    );
  }

  _buildEmptyCategories() {
    return Text(
      "لم تحدد مجالك بعد",
      style: TextStyles.subTitle.copyWith(
        color: Colors.blueGrey,
        fontWeight: FontWeight.w300,
        fontSize: 12,
      ),
    );
  }
}

//tiny widgets

class _CategoryItem extends StatelessWidget {
  const _CategoryItem(this.cat, this.editable, {Key? key}) : super(key: key);
  final CategoryModel cat;
  final bool editable;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 40,
        width: 40,
        child: CachedNetworkImage(
          imageUrl: cat.image ?? "",
        ),
      ),
      title: Text(
        cat.title!,
        style: TextStyles.subTitle.copyWith(color: Colors.blueGrey[700]),
      ),
      trailing: editable
          ? IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              onPressed: () async {
                Notifications.confirmDialog(
                    title: "حذف المجال",
                    content: "هل انت متأكد من رغبتك بعمل الحذف",
                    confirmText: "تأكيد",
                    cancelText: "الغاء",
                    onConfirm: () {
                      _deleteCategory(cat.id);
                    });
              })
          : Container(
              height: 1,
              width: 1,
            ),
    );
  }

  Future _deleteCategory(int? id) async {
    Notifications.showLoading();
    await Get.find<ProfileService>().deleteCategory(id).then((value) async {
      Notifications.hideLoading();

      if (value.status == 1) {
        Get.find<ProfileBloc>().updateProfile(value.profile);
      } else {
        Notifications.error("فشل العملية");
      }
    }).catchError((e) {
      Notifications.hideLoading();

      print(e.toString());
      Notifications.error(Constants.netError);
    });
  }
}
