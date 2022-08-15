import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/show_rating.widget.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/modules/consulting/forms/consulting_create_form.bloc.dart';
import 'package:gadeer/modules/select_consultant/select_consultant.page.dart';
import 'package:get/get.dart';

class ConsultantSelectionWidget extends StatelessWidget {
  const ConsultantSelectionWidget(this.formBloc, this.setState, {Key? key})
      : super(key: key);
  final ConsultingCreateFormBloc? formBloc;
  final Function setState;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      formBloc!.consultant == null
          ? Container()
          : Column(
              children: [
                _buildConsultantItem(formBloc!.consultant!),
                SizedBox(
                  height: 8,
                )
              ],
            ),
      SizedBox(
        height: 8,
      ),
      InkWell(
          onTap: () async {
            List<int?> selctedCats = [];
            if (formBloc!.category.value != null) {
              selctedCats.add(formBloc!.category.value!.id);
            }
            if (formBloc!.subCategory.value != null) {
              selctedCats.add(formBloc!.subCategory.value!.id);
            }
            var consultantx = await Get.to(SelectConsultantPage(selctedCats));
            if (consultantx != null) {
              formBloc!.updateConsultant(consultantx);
              setState();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add, size: 34, color: AppColors.primary),
              SizedBox(
                width: 6,
              ),
              Text(
                formBloc!.consultant == null ? "اختيار الخبير" : "تغيير الخبير",
              ),
            ],
          )),
      SizedBox(
        height: 16,
      ),
    ]);
  }

  Widget _buildConsultantItem(ProfileModel consultant) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        shadowColor: Colors.grey,
        elevation: 2,
        child: ListTile(
          title: Text(
            consultant.name ?? "",
            style: TextStyles.title.copyWith(color: AppColors.primary),
          ),
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: CachedNetworkImageProvider(
              consultant.photo ?? "",
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(consultant.jobTitle ?? ""),
              ShowRatingWidget(
                consultant.rate?.toDouble(),
                size: 15,
                isCenter: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
