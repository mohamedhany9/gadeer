import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/meeting_model.dart';
import 'package:gadeer/data/response/meeting/add_meeting.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/meeting/bloc/edit_meeting.form.dart';

class EditMeetingWidget extends StatefulWidget {
  final MeetingModel? meetingModel;
  final int? consultingId;
  EditMeetingWidget(this.consultingId, this.meetingModel);
  @override
  _EditMeetingWidgetState createState() => _EditMeetingWidgetState();
}

class _EditMeetingWidgetState extends State<EditMeetingWidget> {
  MeetingEditFormBloc? formBloc;
  @override
  void initState() {
    formBloc = MeetingEditFormBloc(widget.consultingId, widget.meetingModel!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("تعديل الاجتماع"),
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
            FormBlocListener<MeetingEditFormBloc, AddMeetingResponse, Object>(
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
                      maxLines: 3,
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
                    CustomButton("تأكيد", () => formBloc!.submit()),
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
