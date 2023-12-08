import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class DeltingRatingRepo {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> deltedRating(String ratingId,String token ) async {
    try {
      dynamic response =
          await baseApiServices.deleteApi('${AppUrl.rating}/$ratingId',headers: {"Authorization":"Bearer $token"});
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
