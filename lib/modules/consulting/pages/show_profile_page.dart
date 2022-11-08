import 'package:flutter/material.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/modules/consultants_home/widget/consult_card_page.dart';
import 'package:gadeer/modules/consultants_home/widget/consult_educations_view.dart';
import 'package:gadeer/modules/consultants_home/widget/consult_work_experience.dart';
import 'package:gadeer/modules/consulting/pages/add_consulting_form.widget.dart';
import 'package:gadeer/modules/consulting/widgets/show_profile/profile_details.widget.dart';
import 'package:gadeer/modules/consulting/widgets/show_profile/profile_header.widget.dart';
import 'package:gadeer/modules/profile/widgets/educations_view.dart';
import 'package:gadeer/modules/profile/widgets/work_experience_view.dart';
import 'package:get/get.dart';

class ShowProfilePage extends StatelessWidget {
  final bool isSelectable;
  final ProfileModel? profile;

  ShowProfilePage(this.profile, {this.isSelectable = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 480,
                child: ConsultCardPage(profile)),
            // SizedBox(
            //   height: 12,
            // ),
            Column(
              children: [
                ConsultEducationsView(
                  profile?.educations,
                  editable: true,
                ),
                SizedBox(
                  height: 16,
                ),
                ConsultWorkexperienceView(
                    profile?.workExperiences,
                    editable: true),
              ],
            ),
            if (!isSelectable && profile?.membershipType == "consultant")
              _buildAddConsultingButton(),
            if (isSelectable && profile?.membershipType == "consultant")
              _buildSelectConsultingButton(),
          ],
        ),
      ),
    );
  }

  _buildAddConsultingButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButton("طلب استشاره", () {
        Get.to(AddConsultingFormWidget(profile));
      }),
    );
  }

  _buildSelectConsultingButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButton("تعيين الخبير", () {
        Get.back(result: profile);
      }),
    );
  }
}
