import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class ScoreUpdateRepo {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> updateScore(dynamic body,
      {Map<String, String>? headers}) async {
    try {
      dynamic response = await baseApiServices
          .updateAPiResponse(AppUrl.updateScore, body, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
