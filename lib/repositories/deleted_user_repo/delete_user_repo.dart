import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class DeletedUserRepo {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> deleteUser(String uid, {String? token}) async {
    try {
      dynamic response = await baseApiServices.deleteApi(
          "${AppUrl.deelteUser}/$uid",
          headers: {"Authorization": "Bearer $token"});
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
