import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/consuilt_profile_model.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/modules/consultants_home/widget/consult_card_page.dart';
import 'package:gadeer/modules/consultants_home/widget/consult_educations_view.dart';
import 'package:gadeer/modules/consultants_home/widget/consult_work_experience.dart';
import 'package:gadeer/modules/register/service/register_api_service.dart';
import 'package:get/get.dart';

class ShowProfilePageId extends StatefulWidget {
  // final bool isSelectable;
  // final ProfileModel? profile;
  //
  // ShowProfilePageId(this.profile, {this.isSelectable = false});'

  int id;
  ShowProfilePageId({required this.id});

  @override
  State<ShowProfilePageId> createState() => _ShowProfilePageIdState();
}

class _ShowProfilePageIdState extends State<ShowProfilePageId> {

  late ProfileModel consuiltData ;

  bool _loading = true ;

  getSubjectData() async {
    try {
      ServiceApi serviceApi = new ServiceApi();
      await serviceApi.getConsultProfile(widget.id);
      setState(() {
        consuiltData = serviceApi.consuiltdata;
        _loading = false;
      });
    } catch (e) {

    }
  }

  @override
  void initState() {
    getSubjectData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _loading == true ? Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Center(child: CircularProgressIndicator())) : Column(
          children: [
            Container(
                height: 480,
                child: ConsultCardPage(consuiltData)),
            // SizedBox(
            //   height: 12,
            // ),
            Column(
              children: [
                ConsultEducationsView(
                  consuiltData.educations,
                  editable: true,
                ),
                SizedBox(
                  height: 16,
                ),
                ConsultWorkexperienceView(
                    consuiltData.workExperiences,
                    editable: true),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            // if (!isSelectable && profile?.membershipType == "consultant")
            //   _buildAddConsultingButton(),
            // if (isSelectable && profile?.membershipType == "consultant")
            //   _buildSelectConsultingButton(),

            // _buildAddConsultingButton()


            // GestureDetector(
            //   onTap: (){
            //     print(profile!.link);
            //     Get.back();
            //   },
            //   child: Container(
            //     height: 50,
            //     width: MediaQuery.of(context).size.width,
            //     color: Colors.red,
            //     child: Text("Share"),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  _buildAddConsultingButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButton("مشاركة الخبير", () {
        print(consuiltData.link);
        Clipboard.setData(new ClipboardData(text: consuiltData.link));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied to Clipboard")));
        // key!.currentState.showSnackBar(
        //     new SnackBar(content: new Text("Copied to Clipboard"),));
      }),
    );
  }

  _buildSelectConsultingButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButton("تعيين الخبير", () {
        Get.back(result: consuiltData);
      }),
    );
  }
}
