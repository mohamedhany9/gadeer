import 'package:flutter/material.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_page/empty_list.widget.dart';
import 'package:gadeer/modules/search_consultants/controller/search_consultants.controller.dart';
import 'package:get/get.dart';

import 'widgets/consultant_item.widget.dart';
import 'widgets/consultants_search_field.widet.dart';

class SearchConsultantsPage extends StatelessWidget {
  final TextEditingController search = TextEditingController();
  final SearchConsultantsController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("بحث الخبراء"),
      body: GetBuilder<SearchConsultantsController>(
        initState: (_) {
          Future.microtask(() => _controller.initData());
        },
        builder: (_) {
          return Container(
            height: double.infinity,
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
                SizedBox(
                  height: 16,
                ),
                ConsultantsSearchField(_controller, search),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: _controller.consultants?.isNotEmpty == true
                        ? ListView.separated(
                            separatorBuilder: (c, i) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  child: Divider(
                                    color: Colors.blueGrey[300],
                                  ),
                                ),
                            itemCount: _controller.consultants?.length ?? 0,
                            itemBuilder: (c, i) {
                              return ConsultantItemWidget(
                                  _controller.consultants?[i]);
                            })
                        : EmptyListWidget("لا يوجد خبراء")),
              ],
            ),
          );
        },
      ),
    );
  }
}
