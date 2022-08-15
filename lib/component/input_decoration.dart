import 'package:flutter/material.dart';
import 'package:gadeer/helper/app.theme.dart';

InputDecoration inputDecoration(
    {String? hint,
    String? label,
    IconData? icon,
    Widget? suffix,
    Color? enabledBorder,
    double? borderRadius,
    double fontSize = 16.0,
    Color? fill = Colors.white}) {
  return InputDecoration(
    prefixIcon: icon != null
        ? Icon(
            icon,
            color: AppColors.primary,
          )
        : null,
    suffix: suffix,
    hintText: hint??label??"",
    fillColor: fill,
    hoverColor: fill,
    filled: true,
    labelText: label ?? hint,
    hintStyle: TextStyle(color: Colors.blueGrey[600], fontSize: fontSize),
    labelStyle: TextStyle(color: Colors.blueGrey[600]),
    errorStyle: TextStyle(
      color: Colors.red,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: enabledBorder ?? Color(0xff175f8c)),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 50)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff22A1F2),
      ),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 50)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 50)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 50)),
    ),
  );
}
