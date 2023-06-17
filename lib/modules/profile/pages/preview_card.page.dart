import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/show_rating.widget.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/account/bloc/account_bloc.dart';
import 'package:gadeer/modules/home/controller/home.controller.dart';
import 'package:gadeer/modules/profile/widgets/preview_card_actions.widget.dart';
import 'package:gadeer/modules/profile/widgets/preview_card_details.widget.dart';
import 'package:gadeer/modules/profile/widgets/preview_card_footer.widget.dart';
import 'package:gadeer/modules/profile/widgets/preview_card_header.widget.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
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
            // Screenshot(
            //   controller: _screenshotController,
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 16),
            //     padding: EdgeInsets.symmetric(horizontal: 8),
            //     decoration: BoxDecoration(
            //         color: AppColors.primary,
            //         image: DecorationImage(
            //             repeat: ImageRepeat.repeat,
            //             image: AssetImage(Constants.background3)),
            //         borderRadius: BorderRadius.circular(25)),
            //     child: Column(
            //       children: [
            //         PreviewCardHeader(profileModel),
            //         PreviewCardDetails(profileModel),
            //         SizedBox(
            //           height: 8,
            //         ),
            //         PreviewCardFooter(),
            //       ],
            //     ),
            //   ),
            // ),
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    border: Border.all(color: HexColor("#1AC4B8"),width: 2)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height:50 ,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profileModel?.name ?? "",style: TextStyle(color: HexColor("#1AC4B8"),fontSize: 16
                                ,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            Text(profileModel?.jobTitle ?? "",style: TextStyle(color: HexColor("#3D3D3D"),fontSize: 14
                                ,fontWeight: FontWeight.bold),),
                            Text( profileModel?.categories?.map((cat) => cat.title).join(" - ") ?? "",style: TextStyle(color: HexColor("#3D3D3D"),fontSize: 14
                                ,fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                            ShowRatingWidget(
                              profileModel?.rate?.toDouble(),
                              size: 20,
                              isCenter: false,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height:18 ,),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        height: 70,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: HexColor('#607D8B'),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(18),bottomLeft: Radius.circular(18))
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(profileModel!.workHours,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                Text("ساعات التطوع",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
                              ],
                            ),
                            Column(
                              children: [
                                Text( Get.find<HomeController>().homeResponse?.consultingCount.toString() ??
                                    "0",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                Text("الاستشارات",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
                              ],
                            ),
                            Column(
                              children: [
                                Text( Get.find<HomeController>().homeResponse?.userCount?.toString() ??
                                    "0",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                Text("الجميعات",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: 40,
                    child: Container(
                      height: 160,
                      width: 100,
                      decoration: BoxDecoration(
                        color: HexColor("#1AC4B8"),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50))
                      ),
                      child: Column(
                        children: [
                          Text(Get.find<AccountBloc>().state.user?.number.toString() ?? "",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          Text("رقم العضوية",style: TextStyle(color: Colors.white
                              ,fontWeight: FontWeight.w500,fontSize: 10),),
                          Spacer(),
                          CircleAvatar(
                            radius: 45,
                            backgroundImage:
                            CachedNetworkImageProvider(profileModel?.photo ?? ""),
                          ),
                          SizedBox(height: 4,)
                        ],
                      ),
                    )),
                Positioned(
                  right: 20,
                  child:  Image.asset(
                  Constants.logoWhite,
                  height: 30,
                ),)
              ],
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
