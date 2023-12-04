import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';

import 'package:quiz_e_book/model/quiz_model.dart';
import 'package:quiz_e_book/model/qustion.dart';
import 'package:quiz_e_book/model/users.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class QuizRepository {
  final BaseApiServices baseApiServices = NetworkApiServices();

  Future<List<Quiz>> getQuizData(String token) async {
    dynamic response = await baseApiServices.getGetApiResponse(AppUrl.getQuiz,
        headers: {"Authorization": "Bearer $token"});

    var data = response as List;
    return data.map((dynamic json) => Quiz.fromJson(json)).toList();
  }

  Future<List<Question>> getQuestionData(String token) async {
    dynamic response = await baseApiServices.getGetApiResponse(AppUrl.getQuestion,
        headers: {"Authorization": "Bearer $token"});

    var data = response as List;
    return data.map((dynamic json) => Question.fromJson(json)).toList();
  }

 Future<List<Users>> getUsersData(String token) async {
    dynamic response = await baseApiServices.getGetApiResponse(AppUrl.getAllUsers,
        headers: {"Authorization": "Bearer $token"});

    var data = response as List;
    return data.map((dynamic json) => Users.fromJson(json)).toList();
  }
}
