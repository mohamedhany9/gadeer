import 'package:flutter/material.dart';

import 'package:gadeer/helper/app.theme.dart';

buildTextField(
    {String? label,
    bool autoValidate = false,
    String? hint,
    TextEditingController? cont,
    FormFieldValidator<String>? validator,
    bool isPassword = false,
    TextInputType type = TextInputType.name,
    Widget? suffix,
    IconData? icon}) {
  return TextFormField(
    obscureText: isPassword,
    keyboardType: type,
    autovalidateMode:
        autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
    decoration: InputDecoration(
      prefixIcon: icon != null
          ? Icon(
              icon,
              color: AppColors.primary,
            )
          : null,
      suffix: suffix,
      hintText: hint,
      labelText: label ?? hint,
      hintStyle: TextStyle(color: Colors.blueGrey.shade600),
      labelStyle: TextStyle(color: Colors.blueGrey.shade600),
      errorStyle: TextStyle(
        color: Colors.red,
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xff175f8c)),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xff22A1F2),
        ),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    ),
    controller: cont,
    validator: validator,
  );
}

buildInputDecoration({String hint = "", Widget? suffex}) {
  return InputDecoration(
      hintText: hint,
      suffixIcon: suffex,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
      ));
}
