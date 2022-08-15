import 'package:flutter/material.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/consulting/widgets/consulting_page/empty_list.widget.dart';
import 'package:gadeer/modules/show_associations/controller/show_associations.controller.dart';
import 'package:get/get.dart';

import 'widgets/association_item.widget.dart';

class ShowAssosiationPage extends StatelessWidget {
  final ShowAssociationsController _controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("الجمعيات"),
      body: Container(
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
        child: GetBuilder<ShowAssociationsController>(
          initState: (_) {
            Future.microtask(() => _controller.getAssosiations());
          },
          builder: (_) {
            return _controller.assosiations?.isNotEmpty == true
                ? ListView.separated(
                    separatorBuilder: (c, i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Divider(
                            color: Colors.blueGrey[300],
                          ),
                        ),
                    itemCount: _controller.assosiations?.length ?? 0,
                    itemBuilder: (c, i) {
                      return AssociationItemWidget(
                          _controller.assosiations?[i]);
                    })
                : EmptyListWidget("لا يوجد جمعيات");
          },
        ),
      ),
    );
  }
}
