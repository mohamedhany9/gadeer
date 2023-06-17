import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/response/profile/profile.response.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/profile/bloc/forms/work_create_form.bloc.dart';

class WorkCreateFormWidget extends StatefulWidget {
  WorkCreateFormWidget({Key? key}) : super(key: key);

  @override
  State<WorkCreateFormWidget> createState() => _WorkCreateFormWidgetState();
}

class _WorkCreateFormWidgetState extends State<WorkCreateFormWidget> {
  WorkCreateFormBloc? formBloc;
  @override
  void initState() {
    formBloc = WorkCreateFormBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBlocListener<WorkCreateFormBloc, ProfileResponse, Object>(
      formBloc: formBloc,
      onSubmitting: (_, __) => Notifications.showLoading(),
      onSuccess: formBloc!.onSuccess,
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
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Expanded(
          //       child: DateTimeFieldBlocBuilder(
          //         dateTimeFieldBloc: formBloc!.from,
          //         format: DateFormat("dd-MM-yyyy"),
          //         initialDate: formBloc!.from.value ?? DateTime.now(),
          //         firstDate: DateTime(1950),
          //         lastDate: DateTime.now(),
          //         decoration:
          //             inputDecoration(hint: 'تاريخ بداية العمل', label: 'من'),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     Expanded(
          //       child: DateTimeFieldBlocBuilder(
          //         dateTimeFieldBloc: formBloc!.to,
          //         format: DateFormat("dd-MM-yyyy"),
          //         initialDate: formBloc!.to.value ?? DateTime.now(),
          //         firstDate: DateTime(1950),
          //         lastDate: DateTime.now(),
          //         decoration:
          //             inputDecoration(hint: 'تاريخ بداية العمل', label: 'الي'),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(
            height: 30,
          ),
          CustomButton("اضافة", () => formBloc!.submit()),
        ],
      ),
    );
  }
}
