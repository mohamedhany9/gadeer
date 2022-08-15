import 'package:flutter_form_bloc/flutter_form_bloc.dart';

mixin FormValidateErrors {
  handleValidateErrors(state, Map<String, dynamic>? errors) {
    state.fieldBlocs(0).forEach((key, field) {
      if (errors?.containsKey(key)??false) {
        String? error =
            errors?[key].toString().replaceAll('[', '').replaceAll(']', '');
        if (field is TextFieldBloc) {
          field.addFieldError(error??"");
        }
        if (field is InputFieldBloc) {
          field.addFieldError(error??"");
        }
        if (field is SelectFieldBloc) {
          field.addFieldError(error??"");
        }
      }
    });
  }
}
