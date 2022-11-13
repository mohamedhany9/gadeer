import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/request/consulting/search_consult.request.dart';
import 'package:gadeer/data/response/consulting/add_consulting.response.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consultants_home/widget/all_constultants.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:gadeer/modules/consulting/widgets/add_consulting_form/category_selection.widget.dart';
import 'package:gadeer/modules/select_consultant/widgets/search_selectable_cosnultants_field.dart';
import 'package:gadeer/modules/select_consultant/widgets/selectable_consultant_item.widget.dart';
import 'package:get/get.dart';

import '../consulting/forms/consulting_create_form.bloc.dart';


class ConsultantsPage extends StatefulWidget {
  const ConsultantsPage(this.consultant ,{Key? key}) : super(key: key);
  final ProfileModel? consultant;

  @override
  State<ConsultantsPage> createState() => _ConsultantsPageState();
}

class _ConsultantsPageState extends State<ConsultantsPage> {

  ConsultingCreateFormBloc? formBloc;


  final consultingService = Get.find<ConsultingService>();
  final filters = ["الاعلي تقييما", "الاقل تقييما"];
  List<ProfileModel>? consultants = [];
  int? selectedId;
  List<int?> selctedCats = [];
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    formBloc = ConsultingCreateFormBloc();
    ProfileModel? consultant = widget.consultant;

    formBloc?.initializeConsultant(consultant);

    if (formBloc!.category.value != null) {
      selctedCats.add(formBloc!.category.value!.id);
      print(selctedCats);
    }

    Future.microtask(() async {
      await _searchConsultants(null);
    });
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
         // onSubmitting: (_, __) => Notifications.showLoading(),
          onSuccess: formBloc!.onSuccess,
          onFailure: formBloc!.onFailure,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      DropdownFieldBlocBuilder<CategoryModel>(
                        selectFieldBloc: formBloc!.category,
                        showEmptyItem: false,
                        decoration: inputDecoration(
                          label: 'مجال الاستشارة',
                          icon: FontAwesomeIcons.clipboard,
                          borderRadius: 5,
                        ),
                        onChanged: (c){
                          setState(() {
                            selctedCats = [];
                            selctedCats.add(c!.id);
                          });
                          Future.microtask(() async {
                            await _searchConsultants(null);
                          });
                        },
                        itemBuilder: (context, cat) => cat.title!,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownFieldBlocBuilder<CategoryModel>(
                        selectFieldBloc: formBloc!.subCategory,
                        decoration: inputDecoration(
                          label: 'المجال الثانوي',
                          hint: '-- الكل --',
                          icon: FontAwesomeIcons.clipboard,
                          borderRadius: 5,
                        ),
                        itemBuilder: (context, sub) => sub.title ?? "",
                      ),
                    ],
                  ),
                   Expanded(
                      child
                      : Container(
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
                        child: Column(
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            SearchSelectableConsultantsField(
                              search: search,
                              filters: filters,
                              onEditingComplete: (s) async {
                                print(s);
                                FocusScope.of(context).unfocus();
                                await _searchConsultants(search.text);
                              },
                              onSelected: (filter) {
                                if (filter == "الاعلي تقييما") {
                                  consultants?.sort((pro1, pro2) {
                                    return (pro2.rate ?? 0.0).compareTo((pro1.rate ?? 0.0));
                                  });
                                } else {
                                  consultants?.sort((pro1, pro2) {
                                    return (pro1.rate ?? 0.0).compareTo((pro2.rate ?? 0.0));
                                  });
                                }
                                setState(() {});
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: consultants!.length,
                                    itemBuilder: (c, i) {
                                      return SelectableConsultantItemWidget(
                                        consultants![i],
                                            (id) {
                                          this.selectedId = id;
                                          setState(() {});
                                        },
                                        selected: consultants?[i].id == selectedId,
                                      );
                                    })),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: CustomButton(
                            //     selectedId == null
                            //         ? "اختيار الخبير"
                            //         : " تعيين الخبير ${selectedId == null ? "" : consultants?.firstWhere((element) => element.id == selectedId).name}",
                            //         () {
                            //       ProfileModel? selected;
                            //       try {
                            //         selected = consultants
                            //             ?.firstWhere((element) => element.id == selectedId);
                            //       } catch (e) {
                            //         print(e.toString());
                            //       }
                            //       Get.back(result: selected);
                            //     },
                            //     color: selectedId == null ? Colors.grey : AppColors.primary,
                            //   ),
                            // ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _searchConsultants(String? jobTitle) async {
    //Notifications.showLoading();
    await consultingService
        .searchConsulting(
        ConsultingSearchRequest(categories: selctedCats, jobTitle: jobTitle ?? ""))
        .then((value) {
      Notifications.hideLoading();

      consultants = value.data;

      setState(() {});
    }).catchError((e) {
      print(e.toString());
      Notifications.hideLoading();

      Notifications.error(Constants.netError);
    });
  }
}
