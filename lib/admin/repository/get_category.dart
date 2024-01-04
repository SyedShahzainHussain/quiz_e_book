import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/model/categorises.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class GetCategoryRepo {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<List<Categories>> getCategory(String token) async {
    try {
      dynamic response = await baseApiServices.getGetApiResponse(
          AppUrl.getCategory,
          headers: {"Authorization": "Bearer $token"});
      final data = response as List;
      return data.map((dynamic json) => Categories.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
