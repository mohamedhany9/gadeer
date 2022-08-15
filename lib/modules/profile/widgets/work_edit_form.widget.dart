import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/work_experience.model.dart';
import 'package:gadeer/data/response/profile/profile.response.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/profile/bloc/forms/work_edit_form.bloc.dart';

class WorkEditFormWidget extends StatefulWidget {
  final WorkExperienceModel workExperienceModel;

  WorkEditFormWidget({Key? key, required this.workExperienceModel})
      : super(key: key);

  @override
  _WorkEditFormWidgetState createState() => _WorkEditFormWidgetState();
}

class _WorkEditFormWidgetState extends State<WorkEditFormWidget> {
  WorkEditFormBloc? formBloc;

  @override
  void initState() {
    formBloc = WorkEditFormBloc(widget.workExperienceModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBlocListener<WorkEditFormBloc, ProfileResponse, Object>(
      formBloc: formBloc,
      onSubmitting: (_, __) => Notifications.showLoading(),
      onSuccess: formBloc!.onSuccess,
      onLoading: (_, __) =>
          formBloc!.loadInitialValues(widget.workExperienceModel),
      onFailure: formBloc!.onFailure,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc!.title,
            decoration: inputDecoration(
              hint: 'المسمي الوظيفي',
              label: 'المسمي الوظيفي',
              borderRadius: 5,
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc!.description,
            minLines: 3,
            maxLines: 3,
            decoration: inputDecoration(
              hint: 'الوصف الوظيفي',
              label: 'الوصف الوظيفي',
              borderRadius: 5,
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc!.place,
            decoration: inputDecoration(
              hint: 'مكان العمل',
              label: 'مكان العمل',
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
                      inputDecoration(hint: 'تاريخ بداية العمل', label: 'من'),
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
                      inputDecoration(hint: 'تاريخ نهاية العمل', label: 'الي'),
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
