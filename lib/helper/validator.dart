import 'package:form_field_validator/form_field_validator.dart';

class Validator {
  static final req = MultiValidator([
    RequiredValidator(errorText: "هذا الحقل مطلوب"),
  ]);
  static final email = MultiValidator([
    RequiredValidator(errorText: "هذا الحقل مطلوب"),
    EmailValidator(errorText: "اكتب بريد الكتروني صحيح"),
  ]);
  static final name = MultiValidator([
    RequiredValidator(errorText: "هذا الحقل مطلوب"),
    MinLengthValidator(3, errorText: "اكتب اسم جمعية صحيح"),
  ]);

  static final password = MultiValidator([
    RequiredValidator(errorText: "هذا الحقل مطلوب"),
    MinLengthValidator(6, errorText: "الرقم السري لا يقل عن 6 وحدات"),
  ]);

  static final phone = MultiValidator([
    RequiredValidator(errorText: "هذا الحقل مطلوب"),
    MinLengthValidator(12, errorText: "رقم الهاتف 12 وحده"),
    MaxLengthValidator(12, errorText: "رقم الهاتف 12 وحده"),
  ]);
}
