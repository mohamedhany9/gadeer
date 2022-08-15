import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/call.model.dart';
import 'package:gadeer/data/response/consulting/consulting_action.response.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/forms/offline_time_form.bloc.dart';
import 'package:gadeer/modules/consulting/widgets/custom_duration_picker.dart';

class AddOfflineTimeWidget extends StatefulWidget {
  final CallModel? callModel;
  AddOfflineTimeWidget(this.callModel);
  @override
  _AddOfflineTimeWidgetState createState() => _AddOfflineTimeWidgetState();
}

class _AddOfflineTimeWidgetState extends State<AddOfflineTimeWidget> {
  late final OfflineTimeForm offlineTimeForm;
  Duration duration = Duration(minutes: 0);

  @override
  void initState() {
    super.initState();
    offlineTimeForm = OfflineTimeForm(widget.callModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("اضافة وقت الاستشاره"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child:
            FormBlocListener<OfflineTimeForm, ConsultingActionResponse, String>(
          formBloc: offlineTimeForm,
          onSubmitting: (_, __) => Notifications.showLoading(),
          onSuccess: offlineTimeForm.onSuccess,
          onFailure: offlineTimeForm.onFailure,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownFieldBlocBuilder<String>(
                  showEmptyItem: false,
                  selectFieldBloc: offlineTimeForm.type,
                  decoration: inputDecoration(
                    label: 'نوع الاستشارة',
                    borderRadius: 5,
                  ),
                  itemBuilder: (context, type) =>
                      type == "phone" ? "الهاتف" : "اخري",
                ),
                TextFieldBlocBuilder(
                  textFieldBloc: offlineTimeForm.other,
                  decoration:
                      inputDecoration(label: "تحديد النوع", borderRadius: 5),
                ),
                SizedBox(
                  width: 10,
                ),
                DateTimeFieldBlocBuilder(
                  dateTimeFieldBloc: offlineTimeForm.date,
                  format: DateFormat("dd-MM-yyyy"),
                  initialDate: offlineTimeForm.date.value ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 28)),
                  lastDate: DateTime.now(),
                  decoration: inputDecoration(
                    hint: 'التاريخ',
                    label: 'التاريخ',
                    borderRadius: 5,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "مده الاستشاره",
                  style: TextStyles.subTitleBold,
                ),
                SizedBox(
                    height: 150,
                    child: CupertinoTimerPickerX(
                        initialTimerDuration: duration,
                        mode: CupertinoTimerPickerMode.hm,
                        onTimerDurationChanged: (du) {
                          duration = du;
                        })),
                SizedBox(
                  height: 16,
                ),
                CustomButton("تأكيد", () async {
                  offlineTimeForm.duration = duration;
                  offlineTimeForm.submit();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
