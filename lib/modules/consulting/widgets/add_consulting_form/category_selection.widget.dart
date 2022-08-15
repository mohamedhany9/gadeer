import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gadeer/component/input_decoration.dart';
import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/modules/consulting/forms/consulting_create_form.bloc.dart';

class CategorySelectionWidget extends StatelessWidget {
  const CategorySelectionWidget(this.formBloc, {Key? key}) : super(key: key);
  final ConsultingCreateFormBloc? formBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownFieldBlocBuilder<CategoryModel>(
          selectFieldBloc: formBloc!.category,
          showEmptyItem: false,
          decoration: inputDecoration(
            label: 'مجال الاستشارة',
            icon: FontAwesomeIcons.clipboard,
            borderRadius: 5,
          ),
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
    );
  }
}
