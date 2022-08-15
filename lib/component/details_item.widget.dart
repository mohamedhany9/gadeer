import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:get/get.dart';

import 'gradient.dart';

class DetailsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  DetailsItem({required this.icon, required this.title, required this.body});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: AppColors.primary,
            gradient: Gradients.linear,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: TextStyles.subTitle.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.all(8),
          width: Get.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blueGrey[50]!)),
          child: Text(
            body!,
            style: TextStyles.subTitle.copyWith(
              color: Colors.blueGrey,
              fontSize: 12,
            ),
          ),
        )
      ],
    );
  }
}
