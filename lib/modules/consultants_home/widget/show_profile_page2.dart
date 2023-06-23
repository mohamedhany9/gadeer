import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/consultants_home/widget/consult_card_page.dart';
import 'package:gadeer/modules/consultants_home/widget/consult_educations_view.dart';
import 'package:gadeer/modules/consultants_home/widget/consult_work_experience.dart';
import 'package:gadeer/modules/consulting/pages/add_consulting_form.widget.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';
import 'package:get/get.dart';

class ShowProfilePage2 extends StatefulWidget {
  final bool isSelectable;
  final ProfileModel? profile;

  ShowProfilePage2(this.profile, {this.isSelectable = false});

  @override
  State<ShowProfilePage2> createState() => _ShowProfilePage2State();
}

class _ShowProfilePage2State extends State<ShowProfilePage2> {

  final AccountBloc _accountBloc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 480,
                child: ConsultCardPage(widget.profile)),
            // SizedBox(
            //   height: 12,
            // ),
            Column(
              children: [
                ConsultEducationsView(
                  widget.profile?.educations,
                  editable: true,
                ),
                SizedBox(
                  height: 16,
                ),
                ConsultWorkexperienceView(
                    widget.profile?.workExperiences,
                    editable: true),
              ],
            ),
            SizedBox(
              height: 12,
            ),

            _accountBloc.state.accountType != AccountType.consultant ?
            _buildSelectConsultingButton() : Container(),


            _buildAddConsultingButton()
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
        print(widget.profile!.link);
        Clipboard.setData(new ClipboardData(text: widget.profile!.link));
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied to Clipboard")));
        // key!.currentState.showSnackBar(
        //     new SnackBar(content: new Text("Copied to Clipboard"),));
      }),
    );
  }

  _buildSelectConsultingButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: CustomButton("طلب استشارة", () {
        Get.to(AddConsultingFormWidget(widget.profile));
      }),
    );
  }
}
