import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/model/rating_model.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class AdminUserRatingRepo {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<List<RatingModel>> getUserRating(String token) async {
    try {
      dynamic response = await baseApiServices.getGetApiResponse(
        AppUrl.rating,
        headers: {"Authorization": "Bearer $token"},
      );
      final data = response as List;
      return data.map((dynamic json) => RatingModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
