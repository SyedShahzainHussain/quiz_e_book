import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class ContactRepo {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> postContact(dynamic body, String token) async {
    try {
      dynamic responseJson = await baseApiServices.getPostApiResponse(
          AppUrl.contact, body,
          headers: {"Authorization": "Bearer $token"});
      return responseJson;
    } catch (e) {
      rethrow;
    }
  }
}
