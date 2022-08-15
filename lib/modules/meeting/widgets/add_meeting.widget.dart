import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/response/meeting/add_meeting.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/meeting/bloc/add_meeting.form.dart';

class AddMeetingWidget extends StatefulWidget {
  final int? consultingId;
  AddMeetingWidget(this.consultingId);
  @override
  _AddMeetingWidgetState createState() => _AddMeetingWidgetState();
}

class _AddMeetingWidgetState extends State<AddMeetingWidget> {
  MeetingCreateFormBloc? formBloc;

  @override
  void initState() {
    formBloc = MeetingCreateFormBloc(widget.consultingId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("اضافة اجتماع جديد"),
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
        child:
            FormBlocListener<MeetingCreateFormBloc, AddMeetingResponse, Object>(
          formBloc: formBloc,
          onSubmitting: (_, __) => Notifications.showLoading(),
          onSuccess: formBloc!.onSuccess,
          onFailure: formBloc!.onFailure,
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
                      textFieldBloc: formBloc!.title,
                      decoration: inputDecoration(
                        hint: 'عنوان الاجتماع',
                        label: 'عنوان الاجتماع',
                        borderRadius: 5,
                      ),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: formBloc!.description,
                      minLines: 3,
                      maxLines: 7,
                      decoration: inputDecoration(
                        hint: 'وصف الاجتماع',
                        label: 'وصف الاجتماع',
                        borderRadius: 5,
                      ),
                    ),
                    DateTimeFieldBlocBuilder(
                      dateTimeFieldBloc: formBloc!.date,
                      format: DateFormat("dd-MM-yyyy"),
                      initialDate: formBloc!.date.value ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 300)),
                      decoration: inputDecoration(
                        hint: 'التاريخ المحدد للاجتماع',
                        label: 'التاريخ',
                        borderRadius: 5,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TimeFieldBlocBuilder(
                      initialTime: TimeOfDay.now(),
                      timeFieldBloc: formBloc!.time,
                      format: DateFormat("hh:mm"),
                      decoration: inputDecoration(
                        hint: 'الوقت المحدد للاجتماع',
                        label: 'الوقت',
                        borderRadius: 5,
                      ),
                    ),
                    CustomButton("اضافة", () => formBloc!.submit()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    formBloc!.close();
    super.dispose();
  }
}
