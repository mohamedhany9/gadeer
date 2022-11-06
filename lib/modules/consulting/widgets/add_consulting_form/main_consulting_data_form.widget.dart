import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/modules/consulting/forms/consulting_create_form.bloc.dart';

class MainConsultingDataFormWidget extends StatelessWidget {
  const MainConsultingDataFormWidget(this.formBloc, {Key? key})
      : super(key: key);
  final ConsultingCreateFormBloc? formBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldBlocBuilder(
          textFieldBloc: formBloc!.title,
          decoration: inputDecoration(
            hint: 'عنوان الاستشاره',
            label: 'عنوان الاستشاره',
            borderRadius: 5,
          ),
        ),
        TextFieldBlocBuilder(
          textFieldBloc: formBloc!.description,
          minLines: 3,
          maxLines: 7,
          decoration: inputDecoration(
            hint: 'وصف الاستشاره',
            label: 'وصف الاستشاره',
            borderRadius: 5,
          ),
        ),
        // DateTimeFieldBlocBuilder(
        //   dateTimeFieldBloc: formBloc!.date,
        //   format: DateFormat("dd-MM-yyyy"),
        //   initialDate: formBloc!.date.value ?? DateTime.now(),
        //   firstDate: DateTime.now(),
        //   lastDate: DateTime.now().add(Duration(days: 300)),
        //   decoration: inputDecoration(
        //     hint: 'التاريخ المحدد للاستشارة',
        //     label: 'التاريخ',
        //     borderRadius: 5,
        //   ),
        // ),
        // SizedBox(
        //   width: 10,
        // ),
        // TimeFieldBlocBuilder(
        //   initialTime: TimeOfDay.now(),
        //   timeFieldBloc: formBloc!.time,
        //   format: DateFormat("hh:mm"),
        //   decoration: inputDecoration(
        //     hint: 'الوقت المحدد للاستشارة',
        //     label: 'الوقت',
        //     borderRadius: 5,
        //   ),
        // ),
      ],
    );
  }
}
