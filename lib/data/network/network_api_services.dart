import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// ignore: library_prefixes
import 'package:http/http.dart' as Response;
import 'package:http/http.dart';
import 'package:quiz_e_book/data/network/app_exception.dart';
import 'package:quiz_e_book/data/network/base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  @override
  Future getGetApiResponse(String url, {Map<String, String>? headers}) async {
    dynamic responseJson;
    try {
      final response = await get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 20));
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic body,
      {Map<String, String>? headers}) async {
    dynamic responseJson;
    try {
      final response = await post(
        Uri.parse(url),
        body: body,
        headers: headers,
      );

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  @override
  Future getRegisterApiResponse(String url, body) async {
    dynamic responseJson;
    try {
      final response = await Dio().post(
        url,
        data: body,
      );

      responseJson = returnResponse(response.data);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }

  dynamic returnResponse(Response.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
        throw BadRequestException(response.body.toString());
      case 404:
      case 401:
        throw UnauthorizedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while communicate with serverwith status code${response.statusCode}');
    }
  }

  @override
  Future updateAPiResponse(String url, dynamic body,
      {Map<String, String>? headers}) async {
    dynamic responseJson;
    try {
      final response = await put(
        Uri.parse(url),
        body: body,
        headers: headers,
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    }
    return responseJson;
  }
  
}
