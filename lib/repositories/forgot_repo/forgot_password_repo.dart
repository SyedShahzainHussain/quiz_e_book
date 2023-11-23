import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class ForgotPasswordRepo {
  final BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> forgotPassword(dynamic body) async {
    try {
      final resposne =
          await baseApiServices.getPostApiResponse(AppUrl.forgotPassword, body);
      return resposne;
    } catch (e) {
      rethrow;
    }
  }
}
