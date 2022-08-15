import 'package:flutter/material.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/profile/widgets/preview_card_actions.widget.dart';
import 'package:gadeer/modules/profile/widgets/preview_card_details.widget.dart';
import 'package:gadeer/modules/profile/widgets/preview_card_footer.widget.dart';
import 'package:gadeer/modules/profile/widgets/preview_card_header.widget.dart';
import 'package:screenshot/screenshot.dart';

class PreviewCardPage extends StatelessWidget {
  PreviewCardPage(this.profileModel, {Key? key}) : super(key: key);
  final ProfileModel? profileModel;
  final ScreenshotController _screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("بطاقه العضويه"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Screenshot(
              controller: _screenshotController,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    image: DecorationImage(
                        repeat: ImageRepeat.repeat,
                        image: AssetImage(Constants.background3)),
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  children: [
                    PreviewCardHeader(profileModel),
                    PreviewCardDetails(profileModel),
                    SizedBox(
                      height: 8,
                    ),
                    PreviewCardFooter(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            PreviewCardActions(profileModel, _screenshotController),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
