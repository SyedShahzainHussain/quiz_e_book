import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class GetSingleUser {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<Map<String, dynamic>> getSingleUser(
      Map<String, String> headers, String userId) async {
    try {
      dynamic response = await baseApiServices.getGetApiResponse(
        '${AppUrl.singleUser}/$userId',
        headers: headers,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
