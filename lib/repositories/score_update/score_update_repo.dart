import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';

class ScoreUpdateRepo {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> updateScore(String url, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      dynamic response = await baseApiServices
          .updateAPiResponse(url, body, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
