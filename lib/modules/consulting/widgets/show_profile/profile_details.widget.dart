import 'package:flutter/material.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/profile/widgets/categories_view.dart';
import 'package:gadeer/modules/profile/widgets/educations_view.dart';
import 'package:gadeer/modules/profile/widgets/sections_view.dart';
import 'package:gadeer/modules/profile/widgets/work_experience_view.dart';

class ProfileDeatilsWidget extends StatelessWidget {
  const ProfileDeatilsWidget(this.profile, {Key? key}) : super(key: key);
  final ProfileModel? profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          repeat: ImageRepeat.repeat,
          image: AssetImage(
            Constants.background1,
          ),
        ),
      ),
      child: Column(
        children: [
          profile!.membershipType != "consultant"
              ? SectionsView(profile!.sections)
              : Column(
                  children: [
                    CategoriesView(profile?.categories),
                    SizedBox(
                      height: 20,
                    ),
                    EducationsView(profile?.educations),
                    SizedBox(
                      height: 20,
                    ),
                    WorkexperienceView(profile?.workExperiences),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
