import 'dart:convert';

import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class AdminRepo {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> adminLogin(dynamic body) async {
    try {
      final response =
          await baseApiServices.getPostApiResponse(AppUrl.login, body);
      return jsonDecode(response);
    } catch (e) {
      rethrow;
    }
  }
}
