import 'package:flutter/material.dart';
import 'package:gadeer/component/app_bar.dart';
import 'package:gadeer/data/model/common_question_model.dart';
import 'package:gadeer/helper/constants.dart';
import 'package:gadeer/helper/notifications.dart';
import 'package:gadeer/modules/account/service/service_api.dart';


class CommonQuestion extends StatefulWidget {
  const CommonQuestion({Key? key}) : super(key: key);

  @override
  State<CommonQuestion> createState() => _CommonQuestionState();
}

class _CommonQuestionState extends State<CommonQuestion> {

  List<QuestionData> questiondata = [];

  bool _loading = false;

  getQuestionData() async {
    //try {
        ServiceApi serviceApi = new ServiceApi();
        await serviceApi.getQuestionData();
        setState(() {
          questiondata = serviceApi.questiondata;
          _loading = true;
          // print(questiondata[0].id);
        });
      // } catch (e) {
      //   setState(() {
      //     // _loading = false;
      //     // Fluttertoast.showToast(
      //     //   msg: "Error From Server",
      //     //   toastLength: Toast.LENGTH_LONG,
      //     //   gravity: ToastGravity.CENTER,
      //     // );
      //   });
      // }

  }

  @override
  void initState() {
    getQuestionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("الاسئلة الشائعة"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            image: AssetImage(
              Constants.background1,
            ),
          ),
        ),
        child:  _loading == false ? NewOverLay() :  Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24),
          child: ListView.builder(
              itemCount: questiondata.length,
              itemBuilder: (context,index){
            return Card(
              child: ExpansionTile(
                title: Text(questiondata[index].question!,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      questiondata[index].answer!,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            );
          }),
        ) ,
      ),
    );
  }

}
