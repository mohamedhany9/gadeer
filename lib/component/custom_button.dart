import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final Color textColor;
  final Color color;
  final bool hasBorder;
  final int fontSize;
  final int padding;
  final bool enabled;

  CustomButton(this.title, this.onTap,
      {this.textColor = Colors.white,
      this.color = AppColors.primary,
      this.fontSize = 16,
      this.enabled = true,
      this.padding = 32,
      this.hasBorder = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !enabled
          ? null
          : () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              onTap();
            },
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: padding.toDouble(), vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(
                color: hasBorder
                    ? enabled
                        ? Colors.transparent
                        : Colors.grey
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(30),
            color: enabled ? color : Colors.grey),
        child: Center(
          child: AutoSizeText(
            title,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textColor,
                fontSize: fontSize.toDouble(),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
