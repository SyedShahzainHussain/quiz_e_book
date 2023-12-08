import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class VerifyRepo {
  final BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> verify(
    dynamic data,
  ) async {
    try {
      final response =
          await baseApiServices.getPostApiResponse(AppUrl.verify, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
