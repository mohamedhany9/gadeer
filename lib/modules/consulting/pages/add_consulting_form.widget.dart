import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/response/consulting/add_consulting.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/forms/consulting_create_form.bloc.dart';
import 'package:gadeer/modules/consulting/widgets/add_consulting_form/category_selection.widget.dart';
import 'package:gadeer/modules/consulting/widgets/add_consulting_form/main_consulting_data_form.widget.dart';
import 'package:gadeer/modules/consulting/widgets/add_consulting_form/consultant_selection.widget.dart';

class AddConsultingFormWidget extends StatefulWidget {
  AddConsultingFormWidget(this.consultant, {Key? key}) : super(key: key);
  final ProfileModel? consultant;

  @override
  _AddConsultingFormWidgetState createState() =>
      _AddConsultingFormWidgetState();
}

class _AddConsultingFormWidgetState extends State<AddConsultingFormWidget> {
  ConsultingCreateFormBloc? formBloc;

  @override
  void initState() {
    formBloc = ConsultingCreateFormBloc();
    ProfileModel? consultant = widget.consultant;

    formBloc?.initializeConsultant(consultant);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        "اضافة استشارة جديدة",
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
        child: FormBlocListener<ConsultingCreateFormBloc, AddConsultingResponse,
            Object>(
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
                    CategorySelectionWidget(formBloc),
                    MainConsultingDataFormWidget(formBloc),
                    ConsultantSelectionWidget(formBloc, () {
                      setState(() {});
                    }),
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
}
