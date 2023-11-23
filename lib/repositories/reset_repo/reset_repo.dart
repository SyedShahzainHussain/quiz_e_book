import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class ResetRepository {
  final BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> resetOtp(dynamic body) async {
    try {
      final response =
          await baseApiServices.getPostApiResponse(AppUrl.resetPassword, body);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
