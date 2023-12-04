import 'dart:convert';

import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class UploadQuestion {
  BaseApiServices baseApiService = NetworkApiServices();

  Future<dynamic> uploadQuestion(dynamic body,
      {Map<String, String>? headers}) async {
    try {
      dynamic response = await baseApiService.getPostApiResponse(
        AppUrl.createQuestion,
        body,
        headers: headers,
      );

      return jsonDecode(response);
    } catch (e) {
      rethrow;
    }
  }
}
