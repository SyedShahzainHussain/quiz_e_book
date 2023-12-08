import 'package:quiz_e_book/data/network/base_api_services.dart';
import 'package:quiz_e_book/data/network/network_api_services.dart';
import 'package:quiz_e_book/resources/urls/app_url.dart';

class DeleteContactRepo {
  BaseApiServices baseApiServices = NetworkApiServices();

  Future<dynamic> deletedContact(String contactID,String token ) async {
    try {
      dynamic response =
          await baseApiServices.deleteApi('${AppUrl.contact}/$contactID',headers: {"Authorization":"Bearer $token"});
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
