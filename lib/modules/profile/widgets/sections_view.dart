import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/assosiation_section.dart';
import 'package:gadeer/data/model/section.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/profile/bloc/profile.bloc.dart';
import 'package:gadeer/modules/profile/service/profile.service.dart';
import 'package:gadeer/modules/profile/widgets/section_add_bottom_sheet.dart';
import 'package:get/get.dart';

class SectionsView extends StatelessWidget {
  final List<SectionModel>? sections;
  final bool editable;
  SectionsView(this.sections, {this.editable = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          sections == null
              ? Container(
                  height: 1,
                )
              : sections?.isEmpty == true
                  ? _buildEmptySections()
                  : Column(
                      children: [
                        ...sections?.map((sec) {
                              return _SectionItemWidget(sec, editable);
                            }).toList() ??
                            [],
                      ],
                    ),
          SizedBox(
            height: 24,
          ),
          if (editable)
            CustomButton("اضافه", () {
              Get.bottomSheet(SelectionButtomSheet(),
                  backgroundColor: Colors.white);
            })
        ],
      ),
    );
  }

  _buildEmptySections() {
    return Center(
      child: SizedBox(
        width: Get.width * .6,
        child: editable
            ? Text(
                "لم تضف اي اقسام لملفك الشخصي بعد",
                style: TextStyles.subTitle.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.blueGrey),
                textAlign: TextAlign.center,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      FontAwesomeIcons.exclamationCircle,
                      size: 150,
                      color: Colors.grey[100],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    "الملف الشخصي للجمعيه غير مكتمل",
                    style: TextStyles.subTitle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.blueGrey),
                  ),
                ],
              ),
      ),
    );
  }
}

//tiny widgets

class _SectionItemWidget extends StatelessWidget {
  const _SectionItemWidget(this.sec, this.editable, {Key? key})
      : super(key: key);
  final SectionModel sec;
  final bool editable;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      sec.title!,
                      style: TextStyles.title,
                    ),
                    if (editable) Spacer(),
                    if (editable)
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Get.bottomSheet(
                                SelectionButtomSheet(
                                  sectionModel: sec,
                                ),
                                backgroundColor: Colors.white);
                          }),
                    SizedBox(
                      height: 8,
                    ),
                    if (editable)
                      IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            Notifications.confirmDialog(
                                title: "حذف العنصر",
                                content: "هل انت متأكد من رغبتك بعمل الحذف",
                                confirmText: "تأكيد",
                                cancelText: "الغاء",
                                onConfirm: () async {
                                  await _deleteSection(sec.id);
                                });
                          }),
                  ],
                ),
                if (editable)
                  SizedBox(
                    height: 10,
                  ),
                Text(
                  sec.description!,
                  textAlign: TextAlign.start,
                  style: TextStyles.subTitle
                      .copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Divider(
          thickness: 2,
        )
      ],
    );
  }

  Future _deleteSection(int? id) async {
    Notifications.showLoading();
    print("show loading");
    await Get.find<ProfileService>().deleteSection(id).then((value) async {
      Notifications.hideLoading();
      print("hide loading");
      if (value.status == 1) {
        Get.find<ProfileBloc>().updateProfile(value.profile);
      } else {
        Notifications.error("فشل العملية");
        print("show error");
      }
    }).catchError((e) {
      Notifications.hideLoading();
      print(e.toString());
      Notifications.error(Constants.netError);
      print("show error");
    });
  }
}
