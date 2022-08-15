import 'package:flutter/material.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/modules/search_consultants/controller/search_consultants.controller.dart';
import 'package:get/get.dart';

class ConsultantsSearchField extends StatelessWidget {
  const ConsultantsSearchField(this._controller, this.search, {Key? key})
      : super(key: key);
  final TextEditingController search;
  final SearchConsultantsController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onSubmitted: (s) async {
                FocusScope.of(Get.context!).unfocus();
                await _controller.searchConsultants(
                  jobTitle: s,
                );
              },
              decoration: inputDecoration(
                icon: Icons.search,
                hint: 'ابحث عن اي خبير',
                enabledBorder: AppColors.primary,
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          PopupMenuButton<CategoryModel>(
              icon: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: Image.asset(
                  Constants.assetImageDirectory + "filter.png",
                  height: 20,
                  fit: BoxFit.fitHeight,
                ),
              ),
              onSelected: (cat) {
                _controller.selected = cat;
                print(cat.title);

                _controller.searchConsultants(jobTitle: search.text);
              },
              itemBuilder: (c) => _controller.categories!.map((c) {
                    return PopupMenuItem<CategoryModel>(
                      value: c,
                      child: Center(
                        child: Text(
                          c.title!,
                          style: TextStyles.subTitle.copyWith(
                              color: c.id == _controller.selected?.id
                                  ? AppColors.primary
                                  : Colors.grey),
                        ),
                      ),
                    );
                  }).toList())
        ],
      ),
    );
  }
}
