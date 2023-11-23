import 'dart:convert';

import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class RegisteredRepo {
  final BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> registerApi(
      dynamic data,) async {
    try {
      final response = await baseApiServices.getRegisterApiResponse(
          AppUrl.registered, data);
      return jsonDecode(response);
    } catch (e) {
      rethrow;
    }
  }
}
