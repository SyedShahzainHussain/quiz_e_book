import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class UpdateLevel {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> updateLevel(dynamic body, String token) async {
    try {
      dynamic resposne = await baseApiServices.updateAPiResponse(
          AppUrl.updateLocked, body,
          headers: {"Authorization": "Bearer $token"});
      return resposne;
    } catch (e) {
      rethrow;
    }
  }
}
