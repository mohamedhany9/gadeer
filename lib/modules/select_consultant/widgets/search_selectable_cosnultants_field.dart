import 'package:flutter/material.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/helper/app.theme.dart';

class SearchSelectableConsultantsField extends StatelessWidget {
  const SearchSelectableConsultantsField(
      {Key? key,
      required this.search,
      required this.filters,
      required this.onEditingComplete,
      required this.onSelected})
      : super(key: key);

  final ValueChanged<String> onSelected;
  final ValueChanged<String?> onEditingComplete;
  final TextEditingController search;
  final List<String> filters;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: search,
              onEditingComplete: () async {
                onEditingComplete(search.text);
              },
              decoration: inputDecoration(
                icon: Icons.search,
                hint: 'ابحث عن أي خبير',
                enabledBorder: AppColors.primary,
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          PopupMenuButton<String>(
              icon: Icon(
                Icons.sort,
                color: AppColors.primary,
                size: 34,
              ),
              onSelected: (filter) {
                onSelected(filter);
              },
              itemBuilder: (c) => filters.map((filter) {
                    return PopupMenuItem<String>(
                      value: filter,
                      child: Center(
                        child: Text(
                          filter,
                        ),
                      ),
                    );
                  }).toList())
        ],
      ),
    );
  }
}
