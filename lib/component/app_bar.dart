import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';

buildAppBar(String title, {List<Widget>? actions}) {
  return AppBar(
    centerTitle: true,
    actions: actions,
    backgroundColor: AppColors.primary,
    title: Text(
      title,
      style: TextStyles.title,
    ),
  );
}
