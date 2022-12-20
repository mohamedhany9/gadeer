import 'package:flutter/material.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/component/custom_button.dart';
import 'package:gadeer/data/model/profile.model.dart';
import 'package:gadeer/data/request/consulting/search_consult.request.dart';
import 'package:gadeer/helper/app.theme.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/consulting/service/consulting_service.dart';
import 'package:gadeer/modules/select_consultant/widgets/selectable_consultant_item.widget.dart';
import 'package:get/get.dart';
import 'widgets/search_selectable_cosnultants_field.dart';

class SelectConsultantPage extends StatefulWidget {
  final List<int?> cats;
  SelectConsultantPage(this.cats);
  @override
  _SelectConsultantPageState createState() => _SelectConsultantPageState();
}

class _SelectConsultantPageState extends State<SelectConsultantPage> {
  final consultingService = Get.find<ConsultingService>();
  final filters = ["الأعلي تقييما", "الأقل تقييما"];
  List<ProfileModel>? consultants = [];
  int? selectedId;
  List<int?> cats = [];
  TextEditingController search = TextEditingController();
  @override
  void initState() {
    cats = widget.cats;

    print(cats.length);
    Future.microtask(() async {
      await _searchConsultants(null);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("اختيار الخبير"),
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
                if (filter == "الأعلي تقييما") {
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                selectedId == null
                    ? "اختيار الخبير"
                    : " تعيين الخبير ${selectedId == null ? "" : consultants?.firstWhere((element) => element.id == selectedId).name}",
                () {
                  ProfileModel? selected;
                  try {
                    selected = consultants
                        ?.firstWhere((element) => element.id == selectedId);
                  } catch (e) {
                    print(e.toString());
                  }
                  Get.back(result: selected);
                },
                color: selectedId == null ? Colors.grey : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _searchConsultants(String? jobTitle) async {
    Notifications.showLoading();
    await consultingService
        .searchConsulting(
            ConsultingSearchRequest(categories: cats, jobTitle: jobTitle ?? ""))
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
