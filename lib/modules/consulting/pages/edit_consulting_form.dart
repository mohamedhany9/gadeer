import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/response/consulting/add_consulting.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/bloc/consulting.bloc.dart';
import 'package:gadeer/modules/consulting/forms/consulting_edit_form.bloc.dart';
import 'package:get/get.dart';

class EditConsultingFormWidget extends StatefulWidget {
  @override
  _EditConsultingFormWidgetState createState() =>
      _EditConsultingFormWidgetState();
}

class _EditConsultingFormWidgetState extends State<EditConsultingFormWidget> {
  ConsultingEditFormBloc? consultingEditFormBloc;

  @override
  void initState() {
    consultingEditFormBloc =
        ConsultingEditFormBloc(Get.find<ConsultingBloc>().state.current!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        "تعديل بيانات الاستشارة",
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(
              Constants.background1,
            ),
          ),
        ),
        child: FormBlocListener<ConsultingEditFormBloc, AddConsultingResponse,
            Object>(
          formBloc: consultingEditFormBloc,
          onSubmitting: (_, __) => Notifications.showLoading(),
          onSuccess: (_, __) => consultingEditFormBloc!.onSuccess,
          onFailure: (_, __) => consultingEditFormBloc!.onFailure,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: consultingEditFormBloc!.title,
                      decoration: inputDecoration(
                        hint: 'عنوان الاستشاره',
                        label: 'عنوان الاستشاره',
                        borderRadius: 5,
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: consultingEditFormBloc!.description,
                      minLines: 3,
                      maxLines: 3,
                      decoration: inputDecoration(
                        hint: 'وصف الاستشاره',
                        label: 'وصف الاستشاره',
                        borderRadius: 5,
                      ),
                    ),
                    DateTimeFieldBlocBuilder(
                      dateTimeFieldBloc: consultingEditFormBloc!.date,
                      format: DateFormat("dd-MM-yyyy"),
                      initialDate:
                          consultingEditFormBloc!.date.value ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 300)),
                      decoration: inputDecoration(
                          hint: 'التاريخ المحدد للاستشاره', label: 'التاريخ'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TimeFieldBlocBuilder(
                      initialTime: TimeOfDay.now(),
                      timeFieldBloc: consultingEditFormBloc!.time,
                      format: DateFormat("hh:mm"),
                      decoration: inputDecoration(
                          hint: 'الوقت المحدد للاستشاره', label: 'الوقت'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                        "تأكيد", () => consultingEditFormBloc!.submit()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
