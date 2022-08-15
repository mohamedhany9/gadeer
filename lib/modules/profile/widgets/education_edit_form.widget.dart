import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/education.model.dart';
import 'package:gadeer/data/response/profile/profile.response.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/profile/bloc/forms/education_edit_form.bloc.dart';

class EducationEditFormWidget extends StatefulWidget {
  final EducationModel educationModel;
  EducationEditFormWidget({Key? key, required this.educationModel})
      : super(key: key);

  @override
  _EducationEditFormWidgetState createState() =>
      _EducationEditFormWidgetState();
}

class _EducationEditFormWidgetState extends State<EducationEditFormWidget> {
  EducationEditFormBloc? formBloc;

  @override
  void initState() {
    formBloc = EducationEditFormBloc(widget.educationModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBlocListener<EducationEditFormBloc, ProfileResponse, Object>(
      formBloc: formBloc,
      onSubmitting: (_, __) => Notifications.showLoading(),
      onSuccess: formBloc!.onSuccess,
      onLoading: (_, __) => formBloc!.loadInitialValues(widget.educationModel),
      onFailure: formBloc!.onFailure,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          DropdownFieldBlocBuilder<String>(
            selectFieldBloc: formBloc!.title,
            decoration: inputDecoration(
              hint: 'الدرجه العلميه',
              label: 'الدرجه العلميه',
              borderRadius: 5,
              icon: Icons.map,
            ),
            itemBuilder: (context, degree) => degree,
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc!.description,
            minLines: 3,
            maxLines: 3,
            decoration: inputDecoration(
              hint: 'وصف الدرجة العلمية',
              label: 'الدرجة العلمية',
              borderRadius: 5,
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc!.place,
            decoration: inputDecoration(
              hint: 'الجهة المانحة',
              label: 'الجهة المانحة',
              borderRadius: 5,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DateTimeFieldBlocBuilder(
                  dateTimeFieldBloc: formBloc!.from,
                  format: DateFormat("dd-MM-yyyy"),
                  initialDate: formBloc!.from.value ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  decoration:
                      inputDecoration(hint: 'تاريخ بداية الدراسة', label: 'من'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: DateTimeFieldBlocBuilder(
                  dateTimeFieldBloc: formBloc!.to,
                  format: DateFormat("dd-MM-yyyy"),
                  initialDate: formBloc!.to.value ?? DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  decoration:
                      inputDecoration(hint: 'تاريخ التخرج', label: 'الي'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          CustomButton("تعديل", () => formBloc!.submit()),
        ],
      ),
    );
  }
}
