import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';

class UpdateLevel {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> updateLevel(dynamic body, String token) async {
    try {
      dynamic resposne = await baseApiServices.updateAPiResponse(
          "https://quiz-backend-vc19.onrender.com/unlocked", body,
          headers: {"Authorization": "Bearer $token"});
      return resposne;
    } catch (e) {
      rethrow;
    }
  }
}
