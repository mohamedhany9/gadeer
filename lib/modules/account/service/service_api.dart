
import 'package:gadeer/data/model/common_question_model.dart';
import 'package:gadeer/data/model/file_data_model.dart';
import 'package:gadeer/data/service/api.service.dart';
import 'package:gadeer/data/service/hive.service.dart';
import 'package:get/get.dart';

class ServiceApi {
  final HiveService _hiveService = Get.find();
  final ApiService _apiService = Get.find();

  List<QuestionData> questiondata = [] ;
  late FileData filedata  ;


  Future<void> getQuestionData() async {
    // String url = "${Constants.baseUrl}faqs";

    var response = await _apiService.get(
      "faqs",
    );
    // Response response = await Dio().get(url,
    //     options: Options(
    //       validateStatus: (status) => true,
    //       headers: {
    //         "Accept": "application/json",
    //         'Content-Type': 'application/json',
    //         'Authorization' : 'Bearer ${Constants.token}'
    //       },
    //     )
    // );
    QuestionModel data = new QuestionModel.fromJson(response);
    questiondata = data.data!;
  }


  Future<void> getFileConsultData() async {

    var response = await _apiService.get(
      "file",
    );

    FileDataModel data = new FileDataModel.fromJson(response);
    filedata = data.data!;
  }

}