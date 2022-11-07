import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/response/consulting/add_consulting.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consultants_home/widget/all_constultants.dart';
import 'package:gadeer/modules/consulting/widgets/add_consulting_form/category_selection.widget.dart';

import '../consulting/forms/consulting_create_form.bloc.dart';


class ConsultantsPage extends StatefulWidget {
  const ConsultantsPage(this.consultant ,{Key? key}) : super(key: key);
  final ProfileModel? consultant;

  @override
  State<ConsultantsPage> createState() => _ConsultantsPageState();
}

class _ConsultantsPageState extends State<ConsultantsPage> {

  ConsultingCreateFormBloc? formBloc;

  List<int?> selctedCats = [];

  @override
  void initState() {
    formBloc = ConsultingCreateFormBloc();
    ProfileModel? consultant = widget.consultant;

    formBloc?.initializeConsultant(consultant);

    if (formBloc!.category.value != null) {
      selctedCats.add(formBloc!.category.value!.id);
    }
    if (formBloc!.subCategory.value != null) {
      selctedCats.add(formBloc!.subCategory.value!.id);
    }

    print("hany");
    print(formBloc!.consultant);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        "اضافة استشاره جديدة",
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  CategorySelectionWidget(formBloc),
                  Expanded(
                      child
                      : AllConsultantPage([]))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
